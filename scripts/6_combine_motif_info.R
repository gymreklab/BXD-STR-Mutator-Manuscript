#!/home/momaksimov/anaconda3/envs/r/bin/Rscript

# about: combine motif information output files into a single file

# options
options(stringsAsFactors = FALSE)

# libraries
library(tidyverse)

# config
in_dir = '../../data/ref/motif_comp/by_chunk'
out_dir = '../../data/ref/motif_comp'
ref_dir = '../../data/ref/trf'
proc_list = '_to_proc'
reproc_list = '_to_reproc'

# define regions files
regions_files = list(
    mm10__unfilt = sprintf('%s/str_regions_mm10_unfilt.bed', ref_dir),
    hg19__unfilt = sprintf('%s/str_regions_hg19_unfilt.bed', ref_dir),
    mm10__filt_w_hom = sprintf('%s/str_regions_mm10_filt_w_hom.bed', ref_dir) ,
    hg19__filt_w_hom = sprintf('%s/str_regions_hg19_filt_w_hom.bed', ref_dir)
)

# first find out which chunks are unprocessed
ref_files = bind_rows(
    tibble(name = list.files(in_dir, pattern = '.*__unfilt__\\d+.tsv')),
    tibble(name = list.files(in_dir, pattern = '.*__filt_w_hom__\\d+.tsv'))
) %>% 
    mutate(file = name) %>%
    mutate(name = sub('\\.tsv', '', name)) %>%
    separate('name', c('ref', 'type', 'chunk'), sep = '__') %>%
    mutate_at('chunk', as.integer)

# find missing chunks
miss_chunks = ref_files %>%
    group_by(ref, type) %>%
    top_n(1, chunk) %>%
    rename(max_chunk = chunk) %>%
    mutate(chunk = list(1:max_chunk)) %>%
    unnest(cols = 'chunk') %>%
    ungroup %>%
    anti_join(ref_files, by = c('ref', 'type', 'chunk'))

# user out
if (nrow(miss_chunks) != 0) {
    # user out
    print('Missing chunks:')
    miss_chunks %>% print(n = nrow(.))

    # read the _to_proc list to make a _to_reproc list
    to_proc = read_tsv(proc_list, 
		       col_names = c('ref', 'type', 'in_file', 'chunk', 'from', 'to'),
		       col_types = cols('c', 'c', 'c', 'i', 'i', 'i'))

    # subset and write new file
    to_reproc = to_proc %>% semi_join(miss_chunks, by = c('ref', 'chunk'))
    write_tsv(to_reproc, reproc_list, col_names = FALSE)

    stop('Run missing chunks first')
}

# read regions files
regions = map_df(regions_files, function(regions_file) {
    print(regions_file)
    read_tsv(regions_file, 
	     col_names = c('chr', 'pos', 'end', 'motif_len', 'motif'),
	     col_types = cols('c', 'i', 'i', 'i', 'c'))
}, .id = 'name')

# split reference and type from name
regions = regions %>% separate('name', c('ref', 'type'), sep = '__')

# load all motif info files
# ref = 'mm10'
# type = 'filt_w_hom'
motif_info = map_df(list(mm10 = 'mm10', hg19 = 'hg19'), function(ref) {
    print(ref)
    map_df(list(unfilt = 'unfilt', filt_w_hom = 'filt_w_hom'), function(type) {
	print(type)
	map_df(list.files(in_dir, 
			  pattern = sprintf('%s__%s__\\d+.tsv', ref, type),
			  full.names = TRUE), function(f) {
	    read_tsv(f, col_types = cols(
			  chr = col_character(),
			  pos = col_double(),
			  end = col_double(),
			  motif_len = col_double(),
			  motif = col_character(),
			  unq_motif = col_character(),
			  unq_motif_len = col_double(),
			  A = col_double(),
			  C = col_double(),
			  G = col_double(),
			  T = col_double(),
			  canon_motif = col_character(),
			  canon_unq_motif = col_character()
			))
	})
    }, .id = 'type')
}, .id = 'ref')

# check for unprocessed loci
miss_loci = regions %>% anti_join(motif_info, by = c('chr', 'pos', 'end', 'ref', 'type'))

# summarise missing loci
print('Missing loci count')
miss_loci %>% count(ref, chr) %>% print

# check
motif_info %>% count(ref, type)

# it doesn't make sense to save percent A/C/G/T rather save the count
# TODO: go back to original calculation script and undo the percentage calculation there
motif_info = motif_info %>%
    mutate(A = A*motif_len/100,
	   C = C*motif_len/100,
	   G = G*motif_len/100,
	   T = T*motif_len/100) %>%
    mutate_at(c('A', 'C', 'T', 'G'), as.integer)

# write motif info for unfiltered loci
motif_info %>% 
    # filter(type != 'unfilt') %>%
    group_by(ref, type) %>%
    group_walk(.f = function(.x, .y) {
	print(.y$ref)
	write_tsv(.x, sprintf('%s/str_regions_%s_%s.tsv.gz', out_dir, .y$ref, .y$type))
    })
