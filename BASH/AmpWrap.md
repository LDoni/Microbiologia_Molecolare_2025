### AmpWrap Analysis

### Reviewing the Results
#### 1. Initial Quality Control with FastQC and Summary Report with MultiQC

Navigate to the `raw_qc_initial` directory:
   ```
   cd run_1/QC/raw_qc_initial
   ls -ltrh
   ```
   Examine the generated files. Opening a FastQC HTML report will display a detailed assessment of raw read quality, including per-base quality scores, sequence length distribution, GC content, and other key metrics.

   The MultiQC HTML report provides an aggregated, sample-wide overview of all FastQC outputs, enabling a comparative evaluation of sequencing quality across the dataset.
   
   FastQC documentation: https://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/3%20Analysis%20Modules/
   
   MultiQC tutorial: https://www.youtube.com/watch?v=qPbIlO_KWN0

#### 2. Primer removal from sequencing reads with Cutadapt.
Amplicon primers are removed from paired-end sequencing reads using Cutadapt.  
This step generates trimmed FASTQ files (`*_trimmed_R1.fq.gz` and `*_trimmed_R2.fq.gz`) and a detailed Cutadapt log file reporting trimming statistics, read retention, and primer-detection outcomes.
Navigate to the `cutadapt` directory:
   ```
   cd run_1/intermediate/cutadapt
   ls -ltrh
   ```
The summary file reporting the percentage of reads and basepairs retained after primer trimming.  
This provides a quick quality check to verify that primer sequences were correctly detected and that most reads were preserved for downstream analysis.
   ```
   cat cutadapt_summary.log
   ```
<img width="427" height="71" alt="image" src="https://github.com/user-attachments/assets/10d77e5d-8813-4a4f-a1a4-4372627ce09f" />

- **reads_retained** indicates the proportion of read pairs that contained the expected primers and were therefore kept.
- **bps_retained** reflects the proportion of total basepairs retained after trimming, which decreases slightly due to primer removal.

High retention values (>95% reads retained; ~90% bp retained) indicate that:
- primer sequences were present and correctly identified in the vast majority of reads,  
- the sequencing run produced high-quality and consistent amplicons,  
- very few reads were discarded due to missing or incomplete primer sequences.

The stats file contains the full Cutadapt report for each sample, including primer detection statistics, read filtering outcomes, and trimming efficiency.
   ```
   cat cutadapt_primer_trimming_stats.txt
   ```
<img width="2128" height="1158" alt="image" src="https://github.com/user-attachments/assets/b98991a9-d077-4743-a68a-e0d7b3b3c58f" />

- **Total read pairs processed**: The total number of paired reads supplied to Cutadapt.

- **Read pairs with primer detected**: Indicates how many reads contained the forward and reverse primer sequences at the expected position.  
High percentages (>98%) show that primer binding was successful and consistent.

- **Read fate breakdown**: Reads without detectable primers are removed (`--discard-untrimmed`), ensuring only true amplicon reads proceed to DADA2.

- **Basepairs processed vs. written**: Shows how many total bases remain after trimming.  
A typical result:

   - ~90–92% bp retained
   - reduction corresponds to primer removal plus slight trimming adjustments

- **Adapter (primer) trimming statistics**:
For each primer:

  - exact primer sequence
  - type (anchored 5′)
  - number of allowed mismatches
  - number of reads trimmed
  - distribution of match lengths and error rates  

These tables help assess how consistently primers were detected and whether mismatches were present.

#### 3. Post-cutadapt quality control with FastQC and QC report generation with MultiQC
   After primer trimming, FastQC and MultiQC are run again to evaluate improvements in read quality and to verify the effectiveness of the trimming step.
   Navigate to the `raw_qc_post_cutadapt` directory:
   ```
   cd run_1/QC/raw_qc_post_cutadapt
   ls -ltrh
   ```
#### 4. Determine optimal trimming parameters for DADA2 with FIGARO
FIGARO automatically identifies optimal trimming parameters, such as truncation lengths for DADA2 denoising, balancing read retention and expected error rates.

#### 5. Amplicon sequence variant inference with DADA2
   - Filter and trim
   - Learn the Error Rates
   - Sample Inference
   - Merge paired reads
   - Construct sequence table
   - Remove chimeras
   - Merge the forward and reverse reads together to obtain the full denoised sequences.
      - Merging is performed by aligning the denoised forward reads with the reverse-complement of the corresponding denoised reverse reads, and then constructing the merged “contig” sequences. By default, merged sequences are only output if the forward and reverse reads overlap by at least 12 bases, and are identical to each other in the overlap region (but these conditions can be changed via function arguments).
   - Assign taxonomy

Vediamo il report finale creato da AmpWrap
   ```
   cd results/
   ls -ltrh
   cat final_report.txt
   ```
<img width="1236" height="843" alt="image" src="https://github.com/user-attachments/assets/e9dbb78d-e9c2-44ff-bd60-f724c6845806" />

Cosa ci dice?
- **reads.in** : Numero di raw reads in input (FASTQ).
- **reads.out** : Reads rimaste dopo cutadapt
- **dadaF** e **dadaR** : Numero di letture rimaste dopo il filtraggio per forward (F) e reverse (R) in DADA2.
- **merged** : Numero di coppie di reads R1–R2 che sono state mergiate.
- **nonchim** : Reads rimaste dopo la rimozione delle chimere.
- **total_retained** : Percentuale di reads finali rispetto all’iniziale.

DADA2 tutorial: https://benjjneb.github.io/dada2/tutorial.html
