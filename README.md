# supreme-octo-disco
Processing and Analysis of 2015 GBS data for **Signatures of Selection** and **AE F2 mapping** projects
Designed to work on MSU HPCC inte16 cluster

TLDR;

1. Make a main directory
2. Clone repo into main directory
2. Change hardcoded file paths in 1_GetData.sh, if necessary
3. Run numbered 1_GetData.sh, from the main directory


## Files

## File Functions:

### 1_GetData.sh
Gets raw data and metadata, copies it to main directory and makes it useable. Also sets up
workspace and launches pipeline.

Calls:
- 1.1_metadatamunge.R
- 1.1_BT2_build.qsub
- 1.1_FastQC.qsub
- 1.1_ProcessRadtags.qsub

### 1.1_metadatamunge.R
Creates metadata files and a script that are needed later in the analysis:

- ../Metadata/AE_F2_merge.csv
- ../Metadata/AE_deconvoluted.pop
- ../Metadata/SigSelection.pop
- ChooseSigSel.sh

Calls: nothing

### 1.1_BT2_build.qsub
Builds a Bowtie2 index for the reference

Calls: nothing

### 1.1_FastQC.qsub
Runs FastQC on untrimmed fastqs

Calls: nothing

### 1.1_ProcessRadtags.qsub
Runs the first step of a STACKS pipeline to trim reads: remove adapters & demultiplex
*This command changes the file extensions from fastq to fq*

Calls:

- 1.2_FastQC_trimmed.qsub
- 1.2_BT2Map.qsub

### 1.2_FastQC_trimmed.qsub
Slowly runs FastQC on trimmed and demultiplexed fastq files a few at a time

Calls: 1.2.1_FastQC_aggregate.R

### 1.2.1_FastQC_aggregate.R
Makes a

### 1.2_BT2Map.qsub
Runs Bowtie2 mapping for each individual to reference (simultanous with FastQC_trimmed)

Calls:
- 1.3_echo.qsub
- 1.3_view_samtools.qsub

### 1.3_echo.qsub
A series of echo commands that write out the program versions and files used for
a given pipeline

Calls: nothing

### 1.3_view_samtools.qsub
Uses samtools to get mapped reads into correct format for STACKS

Calls:
- 1.4_ChooseSigSel.sh
- 1.5_GenMap_STACKS.qsub
- 1.5_Pop_STACKS.qsub

### 1.4_ChooseSigSel.sh
Moves all the sam and bam files to either AE_Deconvoluted or SigSelection directory. Since
two different sets of plants were sequenced together, the files need to be separated for
downstream analysis.


### 1.5_GenMap_STACKS.qsub
For Anther Exsertion lines, uses STACKS pipeline to create a genetic map

### 1.5_Pop_STACKS.qsub
For both datasets, uses STACKS pipeline to get summary statistics

### supreme-octo-disco.Rproj
R project for all R analysis scripts
