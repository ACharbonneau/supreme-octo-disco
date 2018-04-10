echo "1. Getting Raw Files"

mkdir RawFastq
cd RawFastq || exit

ln -sf /mnt/research/radishGenomics/OriginalSequencingFiles/GBS_Cornell_2015/C6G98ANXX_8_fastq.gz .
ln -sf /mnt/research/radishGenomics/OriginalSequencingFiles/GBS_Cornell_2015/C6P86ANXX_4_fastq.gz .
ln -sf /mnt/research/radishGenomics/OriginalSequencingFiles/GBS_Cornell_2015/C81E4ANXX_1_fastq.gz .
ln -sf /mnt/research/radishGenomics/OriginalSequencingFiles/GBS_Cornell_2015/C81FNANXX_1_fastq.gz .
ln -sf /mnt/research/radishGenomics/OriginalSequencingFiles/GBS_Cornell_2015/C81FNANXX_2_fastq.gz .
ln -sf /mnt/research/radishGenomics/OriginalSequencingFiles/GBS_Cornell_2015/C81FNANXX_3_fastq.gz .
ln -sf /mnt/research/radishGenomics/OriginalSequencingFiles/GBS_Cornell_2015/C81FNANXX_4_fastq.gz .
ln -sf /mnt/research/radishGenomics/OriginalSequencingFiles/GBS_Cornell_2015/C81KHANXX_8_fastq.gz .
ln -sf /mnt/research/radishGenomics/OriginalSequencingFiles/GBS_Cornell_2015/C81LCANXX_2_fastq.gz .
ln -sf /mnt/research/radishGenomics/OriginalSequencingFiles/GBS_Cornell_2015/C81LCANXX_3_fastq.gz .
ln -sf /mnt/research/radishGenomics/OriginalSequencingFiles/GBS_Cornell_2015/C81LCANXX_4_fastq.gz .
ln -sf /mnt/research/radishGenomics/OriginalSequencingFiles/GBS_Cornell_2015/C81LCANXX_5_fastq.gz .
ln -sf /mnt/research/radishGenomics/OriginalSequencingFiles/GBS_Cornell_2015/C81LCANXX_6_fastq.gz .
ln -sf /mnt/research/radishGenomics/OriginalSequencingFiles/GBS_Cornell_2015/C81LCANXX_7_fastq.gz .
ln -sf /mnt/research/radishGenomics/OriginalSequencingFiles/GBS_Cornell_2015/C81LCANXX_8_fastq.gz .

echo "2. Getting MetaData"

cd ../ || exit
mkdir Metadata/
cp -r /mnt/research/radishGenomics/OriginalSequencingFiles/GBS_Cornell_2015/Metadata/ Metadata/OriginalFiles/
mv Metadata/OriginalFiles/PlateInfoSeq/ Metadata/PlateInfoSeq/
mv Metadata/OriginalFiles/SequencerQC Metadata/SequencerQC
cd Metadata/PlateInfoSeq/ || exit
mv QTL_F2_8.txt C6G98ANXX_8_fastq.gz.keys.txt
cd ../../supreme-octo-disco/ || exit
module load R/3.2.0
R --file=1.1_metadatamunge.R
cd ../ || exit

echo "3. Setting up workspace"


mkdir ProcessRadtags
mkdir ProcessRadtags/Indicies
mkdir ProcessRadtags/MogheMap


echo "4. Launching fastqc"

mkdir fastQC
mkdir fastQC/RawFQC
mkdir fastQC/TrimmedFQC

#Build indicies for mapping
cd ProcessRadtags/Indicies || exit
qsub ../../supreme-octo-disco/1.1_GS_build.qsub

cd ../../RawFastq/ || exit

ThisT=`ls *fastq.gz | wc -w`
ThisT=`expr $ThisT - 1`

qsub ../supreme-octo-disco/1.1_FastQC.qsub -t 0-${ThisT}
