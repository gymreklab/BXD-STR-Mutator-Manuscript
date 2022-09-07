library(fs)
library(tidyverse)
data_dir = '../data/'

#### Note see /gymreklab-tscc/mikhail/072321_bxd_mutator_paper/BXDstrs_package/BXDstrs/data/
#### for full datasets

######### Load new mutations list ##########
# Snorlax source: /gymreklab-tscc/mikhail/072321_bxd_mutator_paper/data/denovo_info/denovo_ri_gts_hom.tsv
# Generated from:  /gymreklab-tscc/mikhail/072321_bxd_mutator_paper/workflows/5_prep_denovo_list/2_calc_delta_fou.R
# Script now at scripts/2_calc_delta_fou.R 
denovo_strs = read_tsv(fs::path(data_dir, 'denovo_info/denovo_ri_gts_hom.tsv'), 
  col_types = cols(
    chr         = col_character(),
    pos         = 'i',
    end         = 'i',
    RN_A        = 'i',
    RN_B        = 'i',
    strain      = col_character(),
    founder     = col_character(),
    fou_rn  = 'i',
    delta_fou   = 'i',
    expand_sign = 'i',
    expand_type = col_character()
    ),
  comment = '#'
)

# format and filter duplicate sample BXD194
denovo_strs = denovo_strs %>% 
  mutate(RN_T = RN_A + RN_B) %>%
  dplyr::rename(founder_rn = fou_rn) %>%
  filter(strain != 'BXD194')

# Restrict to loci where inference is correct
correct_loci = read_tsv('../data/denovo_info/denovo_ri_gts_hom_bycomp.tsv', col_types = cols())
denovo_strs = denovo_strs %>%
  semi_join(correct_loci, by = c('chr', 'pos', 'end'))

# Output mutations list to a file
write.csv(denovo_strs, file='../outs/denovo_strs_filtered.csv')

######### Load strain info ##########
# load strain info
strain_info = read_tsv(fs::path(data_dir, 'bxd_strain_names_plus.tsv'),
  col_types = cols(
  long_name      = 'c',
  short_name     = 'c',
  bxd_id         = 'c',
  batch          = 'c',
  off_epoch      = 'c',
  type           = 'c',
  gen_inbreeding = 'i',
  gen_breeding   = 'i',
  note           = 'c',
  cross_type     = 'c'
  )
)

# remove redundant columns
strain_info = strain_info %>% select(!c(batch, note, type))

# get list of strains for which sequencing data is available (either have strain in snp vcf or bams for str genotyping)
seqed_strains = list(snp = 'snp_strain_list', 
                     str = 'str_strain_list') %>%
  map_df(~read_tsv(fs::path(data_dir, .x), 
                   col_names = 'short_name', 
                   col_types = cols('c')), .id = 'seq_data') %>%
  mutate(is_seq = TRUE) %>%
  pivot_wider(id_cols = short_name, 
              names_from = seq_data, names_prefix = 'is_seq_',
              values_from = is_seq, values_fill = list(is_seq = FALSE))
strain_info = strain_info %>% 
  left_join(seqed_strains, by = 'short_name') %>%
  mutate(across(matches('is_seq_'), ~replace_na(.x, FALSE))) %>%
  mutate(gen_inbreeding = ifelse(bxd_id == 'BXD029', 158, gen_inbreeding)) %>%
  mutate(gen_inbreeding = ifelse(bxd_id == 'BXD221', 3, gen_inbreeding)) %>%
  mutate(gen_inbreeding = ifelse(bxd_id == 'BXD222', 3, gen_inbreeding)) %>%
  mutate(gen_inbreeding = ifelse(bxd_id == 'BXD223', 4, gen_inbreeding)) %>%
  mutate(gen_inbreeding = ifelse(bxd_id == 'BXD224', 4, gen_inbreeding)) %>%
  mutate(gen_inbreeding = ifelse(bxd_id == 'BXD225', 3, gen_inbreeding)) %>%
  mutate(gen_inbreeding = ifelse(bxd_id == 'BXD226', 3, gen_inbreeding)) %>%
  mutate(gen_inbreeding = ifelse(bxd_id == 'BXD227', 2, gen_inbreeding)) %>%
  mutate(gen_inbreeding = ifelse(bxd_id == 'BXD073', 38, gen_inbreeding))
write_csv(strain_info, '../outs/strain_info.csv')

######### Load genotype info ##########
# Snorlax source: /gymreklab-tscc/mikhail/072321_bxd_mutator_paper/data/str_gts/all_repcn_proc_nosegdup_nolowcr_segreg.rds
# Code to generate: scripts/3_segreg.R 
gt_strs = readRDS(fs::path(data_dir, 'str_gts/all_repcn_proc_nosegdup_nolowcr_segreg.rds'))
write_csv(gt_strs, '../outs/all_repcn_proc_nosegdup_nolowcr_segreg.csv') # keep a csv version

gtloc_per_strain = gt_strs %>%
  summarise(across(.cols = c(matches('BXD'), C57BL, DBA), 
                   .fns = list(ngt = ~sum(!is.na(.x)),
                               nmiss = ~sum(is.na(.x)),
                               ntot = ~length(.x)
                   ),
                   .names = '{col}:{fn}'
  )) %>%
  pivot_longer(everything(), names_to = c('strain', 'var'), names_sep = ':', values_to = 'val') %>%
  pivot_wider(id_cols = strain, names_from = var, values_from = val)

# reformat
gtloc_per_strain = gtloc_per_strain %>% select(strain, n_loci = ngt)
write_csv(gtloc_per_strain, '../outs/gtloc_per_strain.csv')

######### Load motif info ##########
# Snorlax path: /gymreklab-tscc/mikhail/090520_unified_workflow/data/ref/motif_comp/str_regions_mm10_filt_w_hom.tsv.gz
# Code to generate: scripts/calc_motif_info.R
motif_info = read_tsv(fs::path(data_dir, 'str_regions_mm10_filt_w_hom.tsv.gz'), 
                      col_types = cols(
                        chr = col_character(),
                        pos = 'i',
                        end = 'i',
                        motif_len = 'i',
                        motif = 'c',
                        unq_motif = 'c',
                        unq_motif_len = 'i',
                        A = 'i',
                        C = 'i',
                        G = 'i',
                        T = 'i',
                        canon_motif = 'c',
                        canon_unq_motif = 'c'
                      )
) 

# drop not useful columns
motif_info = motif_info %>% select(c(chr, pos, end, motif_len, motif, canon_motif))

# Write to file
write_csv(motif_info, '../outs/motif_info.csv')

######### Load data needed for QTL mapping ##########
# Snorlax path: /gymreklab-tscc/mikhail/072321_bxd_mutator_paper/data/snp_qtl2/gw/

# load qtl2 formatted objects
# genotype probabilities, physical map and strain kinship
snp_probs   = readRDS(fs::path(data_dir, 'qtl_data/probs.rds'))
snp_pmap    = readRDS(fs::path(data_dir, 'qtl_data/pmap.rds'))
snp_kinship = readRDS(fs::path(data_dir, 'qtl_data/kinship.rds'))

# Write qtl_data to a file
qtl_data = list(
  snp_probs   = snp_probs, 
  snp_pmap    = snp_pmap, 
  snp_kinship = snp_kinship)

saveRDS(qtl_data, fs::path('../outs/qtl_data.rds'))
