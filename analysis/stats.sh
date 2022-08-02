#!/bin/bash

# Compute other stats on BXD files

REFSTRS=/gymreklab-tscc/mikhail/090520_unified_workflow/data/ref/str_regions.for_gangstr.bed
echo "Number of reference loci..." $(cat $REFSTRS |  wc -l) # 1178073
echo "Number of reference STRs..." $(cat $REFSTRS | awk '($4<=6)' |  wc -l) # 1156732
echo "Number of reference VNTRs..." $(cat $REFSTRS | awk '($4>6)' |  wc -l) # 21341
