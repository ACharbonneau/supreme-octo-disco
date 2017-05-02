#!/bin/bash

#Sativus Genome:
#Jeong, Y.-M., Kim, N., Ahn, B. O., Oh, M., Chung, W.-H., Chung, H., et al.
#(2016). Elucidating the triplicated ancestral genome structure of radish based
#on chromosome-level comparison with the Brassica genomes. Theoretical and
#Applied Genetics, 1–16. http://doi.org/10.1007/s00122-016-2708-0

#Change Derives_from from number.1 to number:
less /mnt/research/radishGenomics/PublicData/2016RsativusGenome/Rs_1.0.Gene.LFY.gff.gz | sed -r s/\(Derives_from=Rs[0-9]+\)\.[0-9]/\\1/g > /mnt/research/radishGenomics/PublicData/2016RsativusGenome/Edited_Rs_1.0.Gene.LFY.gff

qsub ../../supreme-octo-disco/1.22_build.qsub -N Jeong2016 -v genome=/mnt/research/radishGenomics/PublicData/2016RsativusGenome/Rs_1.0.chromosomes.fix.fasta,gff=/mnt/research/radishGenomics/PublicData/2016RsativusGenome/Edited_Rs_1.0.Gene.LFY.gff,gffi="Derives_from",exon="protein",stranded="yes"


#Sativus Genome: Draft sequences of the radish (Raphanus sativus L.) genome
#Kitashiba H, Li F, Hirakawa H, Kawanabe T, Zou Z, Hasegawa Y, Tonosaki K,
#Zhang Z, Shirasawa S, Fukushima A, Yokoi S, Takahata Y, Kakizaki T, Ishida M,
#Okamoto S, Sakamoto K, Shirasawa K, Tabata S, Nishio T (2014)

#Get FASTA into right format
awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < /mnt/research/radishGenomics/PublicData/RsativusGenome/RSA_r1.0 > /mnt/research/radishGenomics/PublicData/RsativusGenome/Edit_RSA_r1.0.fasta

qsub ../../supreme-octo-disco/1.22_build.qsub -N Kitashiba2014 -v genome=/mnt/research/radishGenomics/PublicData/RsativusGenome/Edit_RSA_r1.0.fasta,gff=/mnt/research/radishGenomics/PublicData/RsativusGenome/RSA_r1.0_genes.gff3.gz,gffi="Parent",exon="exon",stranded="no"


#Sativus Genome: Mitsui, Y., Shimomura, M., Komatsu, K., Namiki, N.,
#Shibata-Hatta, M., Imai, M., et al. (2015). The radish genome and comprehensive
#gene expression profile of tuberous root formation and development.
#Nature Publishing Group, 1–14. http://doi.org/10.1038/srep10835

qsub ../../supreme-octo-disco/1.22_build.qsub -N Mitsui2015 -v genome=/mnt/research/radishGenomics/PublicData/2015_RsativusGenome/rsg_all_v1.fasta,gff=/mnt/research/radishGenomics/PublicData/2015_RsativusGenome/rsgv1.gff,gffi="Parent",exon="CDS",stranded="no"


#Raphanistrum Genome: Moghe, G. D., Hufnagel, D. E., Tang, H., Xiao, Y.,
#Dworkin, I., Town, C. D., et al. (2014). Consequences of Whole-Genome
#Triplication as Revealed by Comparative Genomic Analyses of the Wild Radish
#Raphanus raphanistrum and Three Other Brassicaceae Species. The Plant Cell
#Online, 26(5), 1925–1937. http://doi.org/10.1105/tpc.114.124297

qsub ../../supreme-octo-disco/1.22_build.qsub -N Moghe2014 -v genome=/mnt/research/radishGenomics/AnalysisOfSequencingFiles/MoghePublished/RrContigs.fa.fasta,gff=/mnt/research/radishGenomics/AnalysisOfSequencingFiles/MoghePublished/Rr_gene_pseu.gff.mod,gffi="Parent",exon="exon",stranded="no"


#Raphanistrum transcriptome RR3_NY
#ESTs

qsub ../../supreme-octo-disco/1.22_build.qsub -N RR3_NY_EST -v genome=/mnt/research/radishGenomics/AnalysisOfSequencingFiles/EST_7pops/RR3_NY/1000017.est,gff=NA,gffi="NA",exon="NA",stranded="NA"


#Brassica rapa genome


qsub ../../supreme-octo-disco/1.22_build.qsub -N BR_2017 -v genome=/mnt/research/radishGenomics/PublicData/2017_Brapa/Brapa_R500_V1.2.fasta,gff=NA,gffi="NA",exon="NA",stranded="NA"


#Arabidopsis thaliana genome

qsub ../../supreme-octo-disco/1.22_build.qsub -N AT_2016 -v genome=/mnt/research/radishGenomics/PublicData/AT_TAIR10/TAIR10_chr_all.fas,gff=/mnt/research/radishGenomics/PublicData/AT_TAIR10/TAIR10_GFF3_genes.gff,gffi="Parent",exon="exon",stranded="no"
