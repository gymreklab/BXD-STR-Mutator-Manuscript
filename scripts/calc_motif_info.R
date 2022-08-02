#!/home/momaksimov/anaconda3/envs/r/bin/Rscript
#!/usr/bin/Rscript

# about: gather information on STR motifs, this is somewhat computationally intensive better done once for all loci

# options
options(stringsAsFactors = FALSE)

# libraries
library(tidyverse)
library(optparse)

# get the complement or reverse completement of motif
motif_compl = function(motif, reverse = FALSE) {
    motif = motif %>% 
	toupper %>% 
	str_split(., pattern = '', simplify = TRUE) %>%
	as.character %>%
	recode(A = 'T', T = 'A', C = 'G', G = 'C')
    if (reverse) {
	motif = rev(motif)
    }
    str_c(motif, collapse = '')
}
# motif_compl('ATCGA', reverse = TRUE)
# motif_compl('ATCGA', reverse = FALSE)

# function to reverse motif
motif_rev = function(motif) {
    motif %>% 
	toupper %>% 
	str_split(., pattern = '', simplify = TRUE) %>%
	as.character %>%
	rev %>%
	str_c(collapse = '')
}
# motif_rev('AC')

# function to get the canonical motif
get_canonical = function(motif) {
    # rotation X completement
    motifs = c(motif, motif_rev(motif), motif_compl(motif, reverse = FALSE), motif_compl(motif, reverse = TRUE))

    # sort alphabetically to always get the same canonical motif
    str_sort(motifs)[1]
}
# sapply(c("ACT", "AGT", "TCA", "TGA"), get_canonical)

# parse options
option_list = list(
  make_option(c("--loci_list"), dest = 'loci_list', default = NULL, help = "chr,pos,end,motif_len,motif (no header)"),
  make_option(c("--prefix"), dest = 'prefix', default = NULL, help = "Prefix for output file")
)
opt <- parse_args(OptionParser(option_list=option_list))

debug = FALSE
# set up for debugging
if (debug) {
    out_dir = '../../data/ref/motif_comp'; dir.create(out_dir, showWarnings = FALSE)
    opt$loci_list = '../../data/ref/trf/str_regions_hg19_filt_w_hom.bed'
    opt$prefix = paste0(out_dir, '/', 'str_regions_hg19_filt_w_hom')
}

# time
print(Sys.time())

# load the complete list of strs with motif lengths and motifs
loci_list = read.table(opt$loci_list, header = FALSE, sep = '\t') %>%
    as_tibble %>%
    set_names(c('chr', 'pos', 'end', 'motif_len', 'motif'))

# debug
# loci_list = loci_list %>% slice(1:1000)

# add unique row_ids
loci_list = loci_list %>% mutate(r_id = 1:n())

# loop over each locus
motif_info = loci_list %>%
    group_by(r_id) %>%
    group_modify(.f = function(.x, .y) {
	print(.y$r_id)
	m = str_split(.x$motif, pattern = "")
	tibble(base = m[[1]])
    }) %>%
    count(r_id, base) %>%
    mutate(perc = n*100/sum(n)) %>%
    group_by(r_id) %>%
    arrange(base, .by_group = TRUE) %>%
    mutate(unq_motif = paste0(base, collapse = ''),
	   unq_motif_len = length(base)) %>%
    ungroup %>%
    select(-n) %>%
    spread(base, perc, fill = 0)

# format output
motif_info = loci_list %>% 
    left_join(motif_info, by = 'r_id') %>%
    group_by(r_id) %>%
    mutate(canon_motif = get_canonical(motif),
	   canon_unq_motif = get_canonical(unq_motif)) %>%
    ungroup %>%
    select(-r_id)

# check
for (d_col in c('motif', 'unq_motif', 'canon_motif', 'canon_unq_motif')) {
    print(sprintf('N distinct %ss: %d', d_col, motif_info %>% pull(!!d_col) %>% unique %>% length))
}

# write output
write_tsv(motif_info, sprintf('%s.tsv', opt$prefix))

# time
print(Sys.time())
