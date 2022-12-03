#' STR regions
#' 
#' a names list of bed files with STR coordinates
#' 
#' @format a data frame with:
#' \describe{
#' 	\item{chr}{chromosome name}
#' 	\item{pos}{start position bp}
#' 	\item{end}{end position bp}
#' }
#' @source 
"regions"

#' STR motif information
#' 
#' Properties of STR motifs
#' 
#' @format a data frame with:
#' \describe{
#' 	\item{chr}{chromosome name}
#' 	\item{pos}{start position bp}
#' 	\item{end}{end position bp}
#' 	\item{motif_len}{length of the motif bp}
#' 	\item{motif}{motif identity}
#' 	\item{A}{number of As}
#' 	\item{C}{number of Cs}
#' 	\item{G}{number of Gs}
#' 	\item{T}{number of Ts}
#' 	\item{canon_motif}{canonical motif}
#' }
#' @source 
"motif_info"

#' Denovo STRs
#' 
#' RIL genotypes for denovo STRs. Homozygous denovos only
#' 
#' @format a data frame with:
#' \describe{
#' 	\item{chr}{chromosome name}
#' 	\item{pos}{start position}
#' 	\item{end}{end position}
#' 	\item{RN_A}{A allele repeat count}
#' 	\item{RN_B}{B allele repeat count}
#' 	\item{RN_T}{Total repeat count}
#' 	\item{strain}{Strain name}
#' 	\item{founder}{Founder label B/D}
#' 	\item{founder_rn}{Repeat count in founder (single allele)}
#' 	\item{delta_fou}{Absolute difference in repeat count b/w RIL and founder (RU)}
#' 	\item{expand_sign}{Direction of difference +1/-1}
#' 	\item{expand_type}{Expansion/contraction}
#' }
#' @source 
"denovo_strs"

#' R/qtl2 formatted data
#' 
#' genotype probabilities, physical map and strain kinship using SNPs
#' 
#' @format a list of qtl2 objects:
#' \describe{
#' }
#' @source 
"qtl_data"

#' sqlite databases
#' 
#' Addresses of relevant sqlite databases
#' 
#' @format a list of file paths:
#' \describe{
#' }
#' @source 
"sqlite_files"

#' vcf files
#' 
#' Addresses of relevant vcf files
#' 
#' @format a list of file paths:
#' \describe{
#' }
#' @source 
"vcf_files"

#' fasta files
#' 
#' Addresses of relevant fasta files
#' 
#' @format a list of file paths:
#' \describe{
#' }
#' @source 
"fasta_files"

#' Database schema
#' 
#' Names of tables and fields within table for relevant sqlite databases
#' 
#' @format a list of lists. Top level item are schema names. Next level are table names and finally field names.
#' \describe{
#' }
#' @source 
"db_schemas"

#' BXD strain info
#' 
#' Strain information about BXD strains
#' 
#' @format a data frame with:
#' \describe{
#' 	\item{long_name}{Long name for the strain; e.g. 4512-JFI-0361_BXD001_TyJ}
#' 	\item{short_name}{Short name for the strain; e.g. BXD001_TyJ_0361}
#' 	\item{bxd_id}{BXD id for the strain; e.g. BXD001}
#' 	\item{off_epoch}{Name of official epoch}
#' 	\item{gen_inbreeding}{Number of generations of inbreeding}
#' 	\item{gen_breeding}{Number of generations of breeding}
#' 	\item{cross_type}{Cross type}
#' }
#' @source 
"strain_info"

#' GeneNetwork dataset info
#' 
#' Tissue types for each GeneNetwork expression dataset
#' 
#' @format a data frame with:
#' \describe{
#' 	\item{dset}{Dataset id; e.g. GN206}
#' 	\item{tissue}{Tissue type; e.g. eye_retina}
#' 	\item{tissue_group}{Tissue group; e.g. eye}
#' 	\item{tissue_id}{Tissue id; unique identifier if multiple datasets with same tissue; e.g. brain_hippocampus_1}
#' }
#' @source 
"gn_info"

#' Representative probes
#' 
#' List of representative probes per GeneNetwork gene per dataset in case there are
#' multiple probes per gene
#' 
#' @format a data frame with:
#' \describe{
#' 	\item{dset}{Dataset id; e.g. GN105}
#' 	\item{probe}{Probe name; e.g. A_51_P249793}
#' 	\item{probe_chr}{Chromosome name for probe}
#' 	\item{gene_symbol}{Gene symbol that probe tags; e.g. 0710001B24Rik}
#' }
#' @source 
"repr_probes"

#' Founder blocks from snps
#' 
#' bedgraph stype dataframe with starts and stops of B/D inheritance blocks within
#' BXD
#' 
#' @format a data frame with:
#' \describe{
#' 	\item{strain}{Strain id; e.g. BXD001}
#' 	\item{chr}{Chromosome name}
#' 	\item{pos}{Start position bp}
#' 	\item{end}{End position bp}
#' 	\item{lab}{Founder label}
#' 	\item{n_loci}{Number of loci}
#' }
#' @source 
"founder_blocks"

#' Genotyped loci per BXD strain
#' 
#' Number of successfully genotyped STR loci per BXD strain
#' 
#' @format a data frame with:
#' \describe{
#' 	\item{strain}{Strain id; e.g. BXD001}
#' 	\item{n_loci}{Number of loci}
#' }
#' @source 
"gtloc_per_strain"

#' GRM matrices for GEMMA analysis
#' 
#' List of lists. One for strs and the other for snps. Each list is a list of
#' chromosomes. Relatedness matrices are scaled.
#' 
#' @format a data frame with:
#' \describe{
#' }
#' @source 
"gemma_grm"

#' List of BXD strains featured in each expression dataset
#' 
#' Each dataset has its own unique set of strains available
#' 
#' @format a data frame with:
#' \describe{
#' 	\item{GN}{Dataset id; e.g. GN105}
#' 	\item{strain}{BXD strain name; e.g. BXD001}
#' }
#' @source 
"dset_strains"

#' STR regions
#' 
#' a names list of bed files with STR coordinates
#' 
#' @format a data frame with:
#' \describe{
#' 	\item{chr}{chromosome name}
#' 	\item{pos}{start position bp}
#' 	\item{end}{end position bp}
#' }
#' @source 
"regions"

