# supreme-octo-disco
Processing and Analysis of 2015 GBS data for **Signatures of Selection** and **AE F2 mapping** projects

TLDR; 

1. Make a main directory
2. Clone repo onto HPC
2. Change hardcoded file paths in 1_GetData.sh, if necessary
3. Run numbered scripts, in numerical order
	- .sh and .qsub scripts should be run from the main directory
	- .R and .Rmd scripts must be run from the script folder (uses R 3.2.3)

##Files

##File Functions:

###1_GetData.sh
Gets raw data and metadata, copies it to scratch and makes it useable. Also sets up
workspace and launches pipeline.

Calls:
- metadatamunge.R
- BT2_build.qsub
- FastQC.qsub
- ProcessRadtags.qsub

###metadatamunge.R
Creates metadata files and a script that are needed later in the analysis:

- AE_F2_merge.csv
- AE_deconvoluted.pop
- SigSelection.pop
- ChooseSigSel.sh

Calls: nothing

###BT2_build.qsub
Builds a Bowtie2 index for the reference

Calls: nothing

###FastQC.qsub
Runs FastQC on untrimmed fastqs

Calls: nothing

###ProcessRadtags.qsub
Runs the first step of a STACKS pipeline to trim reads: remove adapters & demultiplex
*This command changes the file extensions from fastq to fq*

Calls: FastQC_trimmed.qsub

###FastQC_trimmed.qsub
Runs FastQC on trimmed and demultiplexed fastq files

Calls: 
- ChooseSigSel.sh
- BT2Map.qsub

###ChooseSigSel.sh
Moves all the trimmed fastq files to either AE_Deconvoluted or SigSelection directory

###BT2Map.qsub
Runs Bowtie2 mapping for each individual to reference

Calls: 
- echo.qsub
- view_samtools.qsub

###echo.qsub
A series of echo commands that write out the program versions and files used for
a given individual for pipeline

Calls: nothing

###view_samtools.qsub
Uses samtools to get mapped reads into correct format for STACKS

Calls:
- GenMap_STACKS.qsub
- Pop_STACKS.qsub

###GenMap_STACKS.qsub
For Anther Exsertion lines, uses STACKS pipeline to create a genetic map

###Pop_STACKS.qsub
For both datasets, uses STACKS pipeline to get summary statistics 

###supreme-octo-disco.Rproj
R project for all R analysis scripts


