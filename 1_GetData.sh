echo "1. Copying Files"

git clone https://github.com/ACharbonneau/supreme-octo-disco.git

mkdir RawFastq & cd RawFastq

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
cp -r /mnt/research/radishGenomics/OriginalSequencingFiles/GBS_Cornell_2015/Metadata/ .
cd Metadata/
mv QTL_F2_8.txt C6G98ANXX_8.fastq.gz.keys.txt
for i in `ls *fastq.gz.keys.txt`; do cut -f 3,4 ${i} | tail -n +2 > `echo ${i} | sed s/_fastq.gz.keys.txt/.barcodes/` ; done

echo "3. Setting up workspace"

cd ../
mkdir ProcessRadtags
mkdir ProcessRadtags/Indicies
mkdir ProcessRadtags/SigSelection
mkdir ProcessRadtags/AE_Deconvoluted
mkdir ProcessRadtags/SigSelection/BT2map/
mkdir ProcessRadtags/AE_Deconvoluted/BT2map/
mkdir ProcessRadtags/SigSelection/popSTACKS/
mkdir ProcessRadtags/AE_Deconvoluted/PopSTACKS/
mkdir ProcessRadtags/AE_Deconvoluted/GenMapSTACKS
echo "4. Launching fastqc"

mkdir fastQC
mkdir fastQC/RawFQC
mkdir fastQC/TrimmedFQC
cd fastQC/RawFQC

qsub ../../supreme-octo-disco/2_FastQC.qsub



