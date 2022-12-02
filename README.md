# BXD-STR-Mutator-Manuscript

Notebooks for generating figures and results are in the `analysis/` directory.

### 1. `analysis/stats.sh` 

Computes some general statistics:
* Total number of TRs: 1,176,016
* Total number of STRs: 1,154,738
* Total number of VNTRs: 21,278

### 2. `analysis/1_denovo_strs.Rmd`

Computes statistics:
* Number of unique loci with mutations: 18,119
* Number of STRs: 18,053
* Number of VNTRs: 66
* Excess of mutations on B haplotypes: 52.5%
* Percent of mutated loci that are singletons: 57.6%

Figures:
* 1b: distribution of sizes of mutations
* 1c: Proportion new mutations by epoch
* Supp Figure 1: karyoplot with locations of new mutations
* Supp Figure 2: properties of mutations by repeat unit length
* Supp Figure 3: number of strains with new mutations per locus

### 3. `analysis/2_mutator_pheno_scan.Rmd`

Computes statistics:
* Total number of LD-pruned SNPs: 7,101
* Max LOD (all): 6.1
* LOD center and interval (all): 79.7, 91.2, 93.4
* Max LOD (tetra): 8.4
* LOD center and interval (tetra): 89.4, 90.4, 93.4
* Z-test proportions by epoch

Figures:
* 2b: Expansion propensity vs. B/D
* 2c: Expansion propensity vs. B/D by epoch
* Supp Figure 5: QTL scan by multiple features
* Supp Figure 6: Distribution of exp propensity by period
* Supp Figure 7: QTL scan by epoch

### 4. `analysis/2_mutator_pheno_plots.ipynb`

Figures:
* 2a: QTL signal
* 2d: zoom in on trace for QTL signal
* Supp Figure 4: zoom in on trace for modest peaks

### 5. `analysis/2_prep_suppdata`

* prepares Supplementary Datasets 1-3
* Generates auto_info used by `2_mutation_patterns`

### 6. `analysis/2_mutation_patterns`

Figures:
* 2e: mutation rate vs. length
* 2f: expansion propensity vs. length
* Supp Figure 8: mutation patterns
* Supp Figure 9: motif analysis

Computes statistics:
* Z-test proportions by repeat unit length 
* Correlation of repeat length vs. mutation rate 
* Correlation of repeat length vs. expansion propensity

