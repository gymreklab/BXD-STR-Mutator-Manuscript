#!/bin/bash

# Compute other stats on BXD files

############## Reference TR set #################
REFSTRS=/gymreklab-tscc/mikhail/090520_unified_workflow/data/ref/str_regions.bed
MOTIFINFO=/gymreklab-tscc/mikhail/090520_unified_workflow/data/ref/motif_comp/str_regions_mm10_filt_w_hom.tsv.gz
# Unique TRs: 1,176,016
zcat $MOTIFINFO | grep -v motif | cut -f 1-4 | \
  intersectBed -a $REFSTRS -b stdin -wa -wb -f 1 | \
  awk '($2==$5 && $3==$6)' | wc -l
# How many are STRs: 1,154,738
zcat $MOTIFINFO | grep -v motif | cut -f 1-4 | \
  intersectBed -a $REFSTRS -b stdin -wa -wb -f 1 | \
  awk '($2==$5 && $3==$6)' | awk '($7<=6)' | wc -l
# How many are VNTRs: 21,278
zcat $MOTIFINFO | grep -v motif | cut -f 1-4 | \
  intersectBed -a $REFSTRS -b stdin -wa -wb -f 1 | \
  awk '($2==$5 && $3==$6)' | awk '($7>6)' | wc -l
# Check:1154738+21278=1176016