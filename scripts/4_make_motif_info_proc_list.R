#!/home/momaksimov/anaconda3/envs/r/bin/Rscript

# about: make a "processing list" for motif calculation
# split large str and snp loci lists into chunks

# clean vars
rm(list = ls())

# options
options(stringsAsFactors = FALSE)

# libraries
library(tidyverse)

# config
ref_dir = '../../data/ref/trf'
out_file = '_to_proc'
chunk_size = 100e3

# define regions files
regions_files = list(
    mm10__unfilt = sprintf('%s/str_regions_mm10_unfilt.bed', ref_dir),
    hg19__unfilt = sprintf('%s/str_regions_hg19_unfilt.bed', ref_dir),
    mm10__filt_w_hom = sprintf('%s/str_regions_mm10_filt_w_hom.bed', ref_dir) ,
    hg19__filt_w_hom = sprintf('%s/str_regions_hg19_filt_w_hom.bed', ref_dir)
)

# read regions files
regions = map_df(regions_files, function(regions_file) {
    print(regions_file)
    read_tsv(regions_file, 
	     col_names = c('chr', 'pos', 'end', 'motif_len', 'motif'),
	     col_types = cols('c', 'i', 'i', 'i', 'c'))
}, .id = 'name')

# split reference and type from name
regions = regions %>% separate('name', c('ref', 'type'), sep = '__')

# check
regions %>% count(ref, type)

# split into chunks
regions = regions %>% 
    group_by(ref, type) %>%
    mutate(loc_id = 1:n()) %>%
    mutate(chunk = cut_width(loc_id, chunk_size, boundary = 0, labels = FALSE)) %>%
    ungroup

# define chunk boundaries
reg_bounds = regions %>%
    group_by(ref, type, chunk) %>%
    summarise(from = min(loc_id), to = max(loc_id)) %>%
    ungroup

# check
reg_bounds %>% filter(ref == 'hg19') %>% tail
reg_bounds %>% filter(ref == 'mm10') %>% tail

# write outputs
write_tsv(reg_bounds %>% 
	    left_join(regions_files %>% 
			as_tibble %>% 
			gather(name, in_file) %>%
			separate('name', c('ref', 'type'), sep = '__'), 
		      by = c('ref', 'type')) %>%
	    select(ref, type, in_file, chunk, from, to) %>%
	    arrange(type, ref, chunk), 
	  out_file, col_names = FALSE)
