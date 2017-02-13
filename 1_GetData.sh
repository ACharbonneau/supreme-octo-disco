echo "1. Copying Files"

mkdir RawFastq
cd RawFastq

gunzip -c  /mnt/research/radishGenomics/OriginalSequencingFiles/GBS_Cornell_2015/C6G98ANXX_8_fastq.gz > C6G98ANXX_8.fastq
gunzip -c  /mnt/research/radishGenomics/OriginalSequencingFiles/GBS_Cornell_2015/C6P86ANXX_4_fastq.gz > C6P86ANXX_4.fastq
gunzip -c  /mnt/research/radishGenomics/OriginalSequencingFiles/GBS_Cornell_2015/C81E4ANXX_1_fastq.gz > C81E4ANXX_1.fastq
gunzip -c  /mnt/research/radishGenomics/OriginalSequencingFiles/GBS_Cornell_2015/C81FNANXX_1_fastq.gz > C81FNANXX_1.fastq
gunzip -c  /mnt/research/radishGenomics/OriginalSequencingFiles/GBS_Cornell_2015/C81FNANXX_2_fastq.gz > C81FNANXX_2.fastq
gunzip -c  /mnt/research/radishGenomics/OriginalSequencingFiles/GBS_Cornell_2015/C81FNANXX_3_fastq.gz > C81FNANXX_3.fastq
gunzip -c  /mnt/research/radishGenomics/OriginalSequencingFiles/GBS_Cornell_2015/C81FNANXX_4_fastq.gz > C81FNANXX_4.fastq
gunzip -c  /mnt/research/radishGenomics/OriginalSequencingFiles/GBS_Cornell_2015/C81KHANXX_8_fastq.gz > C81KHANXX_8.fastq
gunzip -c  /mnt/research/radishGenomics/OriginalSequencingFiles/GBS_Cornell_2015/C81LCANXX_2_fastq.gz > C81LCANXX_2.fastq
gunzip -c  /mnt/research/radishGenomics/OriginalSequencingFiles/GBS_Cornell_2015/C81LCANXX_3_fastq.gz > C81LCANXX_3.fastq
gunzip -c  /mnt/research/radishGenomics/OriginalSequencingFiles/GBS_Cornell_2015/C81LCANXX_4_fastq.gz > C81LCANXX_4.fastq
gunzip -c  /mnt/research/radishGenomics/OriginalSequencingFiles/GBS_Cornell_2015/C81LCANXX_5_fastq.gz > C81LCANXX_5.fastq
gunzip -c  /mnt/research/radishGenomics/OriginalSequencingFiles/GBS_Cornell_2015/C81LCANXX_6_fastq.gz > C81LCANXX_6.fastq
gunzip -c  /mnt/research/radishGenomics/OriginalSequencingFiles/GBS_Cornell_2015/C81LCANXX_7_fastq.gz > C81LCANXX_7.fastq
gunzip -c  /mnt/research/radishGenomics/OriginalSequencingFiles/GBS_Cornell_2015/C81LCANXX_8_fastq.gz > C81LCANXX_8.fastq

echo "2. Getting MetaData"

cd ../
mkdir Metadata/
cp -r /mnt/research/radishGenomics/OriginalSequencingFiles/GBS_Cornell_2015/Metadata/ Metadata/OriginalFiles/
cd Metadata/OriginalFiles/PlateInfoSeq/
mv QTL_F2_8.txt C6G98ANXX_8_fastq.gz.keys.txt
cd ../../../supreme-octo-disco/
module load R/3.2.0
R --file=1.1_metadatamunge.R


echo "3. Setting up workspace"

cd ../
mkdir ProcessRadtags
mkdir ProcessRadtags/Indicies
mkdir ProcessRadtags/BT2map
mkdir ProcessRadtags/BT2map/AE_Deconvoluted
mkdir ProcessRadtags/BT2map/SigSelection
mkdir ProcessRadtags/BT2map/SigSelection/PopSTACKS
mkdir ProcessRadtags/BT2map/AE_Deconvoluted/PopSTACKS
mkdir ProcessRadtags/BT2map/AE_Deconvoluted/GenMapSTACKS
echo "4. Launching fastqc"

mkdir fastQC
mkdir fastQC/RawFQC
mkdir fastQC/TrimmedFQC

#Build indicies for mapping
cd ProcessRadtags/Indicies
qsub ../../supreme-octo-disco/1.1_BT2_build.qsub

cd ../../RawFastq/

ThisT=`ls *.fastq | wc -w`
ThisT=`expr $ThisT - 1`

qsub ../supreme-octo-disco/1.1_FastQC.qsub -t 0-${ThisT}

qsub ../supreme-octo-disco/1.1_ProcessRadtags.qsub -t 0-${ThisT}

