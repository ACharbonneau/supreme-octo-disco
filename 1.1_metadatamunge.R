# There are no unique identifiers in this project until the DNA prep,
# and even in the DNA prep, the unique identifiers aren't unique because
# ~80 samples were sequenced twice.
# One of these samples, 12059, was NOT supposed to be sequenced twice, but appears
# twice in the sequencing data, in the same plate. Since I have the correct number
# of samples, this means another sample must not have been sequenced. Or at least
# was mislabeled. This sample is 13245, which was supposed to be sequenced twice,
# but wasn't. I asked Jeff to check his metadata collection to see if he could
# determine whether 12059 really was sequenced twice, or if one of them is 13245
# just mislabeled.

# Jeff checked and now thinks that:
# "the sample in Cell C4 of plate 4 was really 12054, not 12059, so it is KXF2(2)/102."

# Since the two samples labeled 12059 are
# in the same plate, they get the same unique ID, so I've added a really stupid bit
# of code to add the sequencing well to the unique ID as well.

# Furthermore the ID names change subtley between datasheets.
# This script just munges the metadata into one useable format with unique IDs.

#It also makes the two .pop files needed for STACKS

rm(list = ls())

# Install function for packages
packages<-function(x){
  x<-as.character(match.call()[[2]])
  if (!require(x,character.only=TRUE)){
    install.packages(pkgs=x,repos="http://cran.r-project.org")
    require(x,character.only=TRUE)
  }
}
packages(tidyr)
packages(plyr)
packages(dplyr)



## They sequenced lots of samples twice, but used the same names, which breaks
## the deconvolution step. This loop gives each sample a unique name and writes
## out a new sequence list file for each lane with the unique names

Geno_dir <- file.path("../Metadata/PlateInfoSeq/")

Geno_list <- list.files(Geno_dir, pattern = "*gz.keys.txt")

All_geno_data <- list()

for( X in 1:length(Geno_list)){
  TempFile <- read.table(paste(Geno_dir, Geno_list[ X ], sep=""), sep = "\t", header = T, na.strings = "")
  TempFile$UniqID <- paste(TempFile$DNASample, TempFile$DNA_Plate, TempFile$SampleDNA_Well, sep="_")
  All_geno_data[[X]] <- TempFile
  write.table(TempFile, paste(Geno_dir, substr(Geno_list[X], 1, 11), ".unique.txt", sep=""), sep="\t", row.names=F, col.names=F, quote=F)
}


All_geno_data <- tbl_df( do.call( "rbind", All_geno_data ))

## Get global data frames

DNA_data <- read.csv("../Metadata/OriginalFiles/MetadataAll.txt", sep = "\t", header = F,
                     colClasses = "factor")

colnames(DNA_data) <- c("ID", "Type_Year", "Species", "Cross", "Indiv", "Date", "Prep")

# File from Jeff has all of these wrong :(
DNA_data$Species[DNA_data$Cross=="SAES"] <- "Rrl"
DNA_data$Species[DNA_data$Cross=="RA808"] <- "Rrl"
DNA_data$Species[DNA_data$Cross=="YEIL_CLNC"] <- "Rros"
DNA_data$Cross[DNA_data$Cross=="SPEU"] <- "SPNK"

DNA_data$Cross <- revalue(DNA_data$Cross, c("YEIL_CLNC" = "YEIL"))

DNA_data <- droplevels(DNA_data)

Pedigree <- read.csv("../Metadata/OriginalFiles/Pedigree.csv", colClasses = "factor")

# Get F0 data and combine

F0_Pheno_data <- read.csv("../Metadata/OriginalFiles/QTLParentalMeasurements.csv", colClasses =
                            c(rep("factor", 4), rep("numeric", 6), "factor"))

F0_Pheno_data$Indiv <- paste(F0_Pheno_data$Matriline, "/", F0_Pheno_data$Offspr, sep="")

AE_F0_DNA <- filter( DNA_data, Type_Year=="AS_EX_QTL_Parents_2011")

AE_F0_DNA <- droplevels(AE_F0_DNA)

AE_F0_DNA <- left_join(AE_F0_DNA, F0_Pheno_data)

write.csv(x = AE_F0_DNA, file= "../Metadata/AE_F0_merge.csv")

# Get F1 data and combine

F1_Pheno_data <- read.csv("../Metadata/OriginalFiles/QTLF1measurements.csv", colClasses =
                            c(rep("factor", 4), rep("numeric", 6), "factor"))

F1_Pheno_data$UID <- paste(F1_Pheno_data$Plant.ID, "/", F1_Pheno_data$Offspr, sep="")

AE_F1_DNA <- filter( DNA_data, Type_Year=="AS_EX_QTL_F1s_2011")

AE_F1_DNA$UID <- paste(AE_F1_DNA$Cross, AE_F1_DNA$Indiv, sep="")

AE_F1_DNA <- left_join(AE_F1_DNA, F1_Pheno_data)

AE_F1_DNA <- droplevels(AE_F1_DNA)

write.csv(x = AE_F1_DNA, file = "../Metadata/AE_F1_merge.csv")


# Get F2 data and combine

F2_Pheno_data <- read.csv("../Metadata/OriginalFiles/Exsertion_F2_F2s.csv", colClasses =
                         c(rep("factor", 7), rep("numeric", 7), "factor"))

colnames(F2_Pheno_data)[1] <- "CrossX"

## Filter out F2s from Parents from F1s

AE_F2_DNA <- filter( DNA_data, Type_Year != "SigSelection" &
                       Type_Year!="AS_EX_QTL_Parents_2011" &
                       Type_Year!="AS_EX_QTL_F1s_2011") %>%
              separate( Indiv, into = c("Family", "F2" ), sep = "/")

AE_F2_DNA <- droplevels(AE_F2_DNA)

AE_F2_DNA$F2 <- as.factor(AE_F2_DNA$F2)

## Merge F2s sequencing and phenotype data

CrossList <- c(KF2="KxK", KXF2="KxR", RF2="RxR", RXF2="RxK")

AE_F2_DNA$Family <- factor(gsub( "[()]", "", AE_F2_DNA$Family ))

AE_F2_DNA$CrossX <- as.factor(CrossList[AE_F2_DNA$Cross])

AE_F2_DNA <- left_join(AE_F2_DNA, F2_Pheno_data)

AE_F2_DNA$F2s.produced <- as.factor(paste(AE_F2_DNA$Cross, "(", AE_F2_DNA$Family, ")", sep = ""))

AE_F2_DNA <- left_join(AE_F2_DNA, Pedigree)

write.csv(x = AE_F2_DNA, file = "../Metadata/AE_F2_merge.csv")


# Write out STACKS metadata
# Each version of the analysis needs three files:

# ${name}_stacks_list is a one column matrix where each row is
#                     a single samfile WITH the file extension

# ${name}_stacks_fastqs is a one column matrix where each row is
#                     a single fastq WITH the file extension


# ${name}_cs_stacks_list is a single line list, where each individual is listed with a -s flag
#                        and the path to its samfile WITHOUT the file extension: -s 14766_QTL_F2_12_D09.fq_q20

# [SS or AE]_data.pop is a three column, tab-delimited matrix, where each row is a single samfile
#                     WITHOUT the file extension then a pop/cross ID, then a species/pedigree ID
#                     All the AE runs can use the same file for this one, so it's only made once.

ForStacksAE <- rbind(select(AE_F2_DNA, ID, Cross, Type_Year),
      select(AE_F0_DNA, ID, Cross, Type_Year),
      select(AE_F1_DNA, ID, Cross, Type_Year))

ForStacksAEUniq <- dplyr::left_join(ForStacksAE, All_geno_data, by=c("ID"="DNASample"))

ForStacksAEUniq <- unique(ForStacksAEUniq)

ForStacksAEUniq$UniqID <- paste(ForStacksAEUniq$UniqID, ".fq_q20", sep = "")

write.table(x = select(ForStacksAEUniq, UniqID, Cross, Type_Year), file = "../Metadata/AE_data.pop",
            quote = F, sep = "\t", col.names = F, row.names = F)


Just_F0s <- ForStacksAEUniq$UniqID[ForStacksAEUniq$Cross == "KH" |
                                     ForStacksAEUniq$Cross == "KL" |
                                     ForStacksAEUniq$Cross == "RH" |
                                     ForStacksAEUniq$Cross == "RL" ]

Just_F1s <- ForStacksAEUniq$UniqID[ForStacksAEUniq$Cross == "KF1A" |
                                     ForStacksAEUniq$Cross == "KF1B" |
                                     ForStacksAEUniq$Cross == "KXF1A" |
                                     ForStacksAEUniq$Cross == "KXF1B" |
                                     ForStacksAEUniq$Cross == "RF1A" |
                                     ForStacksAEUniq$Cross == "RF1B" |
                                     ForStacksAEUniq$Cross == "RXF1A" |
                                     ForStacksAEUniq$Cross == "RXF1B" ]

Just_F2s <- ForStacksAEUniq$UniqID[ForStacksAEUniq$Cross == "KF2" |
                                     ForStacksAEUniq$Cross == "KXF2" |
                                     ForStacksAEUniq$Cross == "RF2" |
                                     ForStacksAEUniq$Cross == "RXF2" ]


write.table(paste( " -s ./", Just_F0s, sep=""), file = "../Metadata/AE_F0_cs_stacks_list", quote = F, col.names = F, row.names = F, eol = "")
write.table(paste( " -s ./", Just_F1s, sep=""), file = "../Metadata/AE_F1_cs_stacks_list", quote = F, col.names = F, row.names = F, eol = "")
write.table(paste( " -s ./", Just_F2s, sep=""), file = "../Metadata/AE_F2_cs_stacks_list", quote = F, col.names = F, row.names = F, eol = "")

write.table(paste( " -s ./", Just_F0s, sep=""), file = "../Metadata/AE_Mapping_cs_stacks_list", quote = F, col.names = F, row.names = F, eol = "")
write.table(paste( " -s ./", Just_F2s, sep=""), file = "../Metadata/AE_Mapping_cs_stacks_list", quote = F, col.names = F, row.names = F, eol = "", append = T)


write.table(paste( " -p ./", Just_F0s, sep=""), file = "../Metadata/AE_Mapping_cs_stacks_geno", quote = F, col.names = F, row.names = F, eol = "")
write.table(paste( " -r ./", Just_F2s, sep=""), file = "../Metadata/AE_Mapping_cs_stacks_geno", quote = F, col.names = F, row.names = F, eol = "", append = T)

Just_F0s <- paste(Just_F0s, ".sam", sep = "")
Just_F1s <- paste(Just_F1s, ".sam", sep = "")
Just_F2s <- paste(Just_F2s, ".sam", sep = "")

write.table(Just_F0s, file = "../Metadata/AE_F0_stacks_list", quote = F, col.names = F, row.names = F)
write.table(Just_F1s, file = "../Metadata/AE_F1_stacks_list", quote = F, col.names = F, row.names = F)
write.table(Just_F2s, file = "../Metadata/AE_F2_stacks_list", quote = F, col.names = F, row.names = F)

write.table(Just_F0s, file = "../Metadata/AE_Mapping_stacks_list", quote = F, col.names = F, row.names = F)
write.table(Just_F2s, file = "../Metadata/AE_Mapping_stacks_list", quote = F, col.names = F, row.names = F, append = T)

Just_F0s <- gsub("_q20.sam","", Just_F0s )
Just_F1s <- gsub("_q20.sam","", Just_F1s )
Just_F2s <- gsub("_q20.sam","", Just_F2s )

write.table(Just_F0s, file = "../Metadata/AE_F0_stacks_fastqs", quote = F, col.names = F, row.names = F)
write.table(Just_F1s, file = "../Metadata/AE_F1_stacks_fastqs", quote = F, col.names = F, row.names = F)
write.table(Just_F2s, file = "../Metadata/AE_F2_stacks_fastqs", quote = F, col.names = F, row.names = F)

write.table(Just_F0s, file = "../Metadata/AE_Mapping_stacks_fastqs", quote = F, col.names = F, row.names = F)
write.table(Just_F2s, file = "../Metadata/AE_Mapping_stacks_fastqs", quote = F, col.names = F, row.names = F, append = T)



## STACKS for signatures of selection

ForStacksSS <- filter( DNA_data, Type_Year == "SigSelection") %>%
  select(ID, Cross, Species)

ForStacksSSUniq <- dplyr::left_join(ForStacksSS, All_geno_data, by=c("ID"="DNASample"))
ForStacksSSUniq <- droplevels(ForStacksSSUniq)

ForStacksSSUniq$UniqID <- paste(ForStacksSSUniq$UniqID, ".fq_q20", sep = "")

write.table(x = select(ForStacksSSUniq, UniqID, Cross, Species.x), file = "../Metadata/SS_data.pop",
            quote = F, sep = "\t", col.names = F, row.names = F)

# Just RRR data
Just_Rrr <- ForStacksSSUniq$UniqID[ForStacksSSUniq$Species.x == "Rrr"]
write.table(paste( " -s ./", Just_Rrr, sep=""), file = "../Metadata/SS_Rrr_cs_stacks_list", quote = F, col.names = F, row.names = F, eol = "")
Just_Rrr <- paste(Just_Rrr, ".sam", sep = "")
write.table(Just_Rrr, file = "../Metadata/SS_Rrr_stacks_list", quote = F, col.names = F, row.names = F)
Just_Rrr <- gsub("_q20.sam","", Just_Rrr )
write.table(Just_Rrr, file = "../Metadata/SS_Rrr_stacks_fastqs", quote = F, col.names = F, row.names = F)

#Just landra
Just_landra <- ForStacksSSUniq$UniqID[ForStacksSSUniq$Species.x == "Rrl"]
write.table(paste( " -s ./", Just_landra, sep=""), file = "../Metadata/SS_Rrl_cs_stacks_list", quote = F, col.names = F, row.names = F, eol = "")
Just_landra <- paste(Just_landra, ".sam", sep = "")
write.table(Just_landra, file = "../Metadata/SS_Rrl_stacks_list", quote = F, col.names = F, row.names = F)
Just_landra <- gsub("_q20.sam","", Just_landra )
write.table(Just_landra, file = "../Metadata/SS_Rrl_stacks_fastqs", quote = F, col.names = F, row.names = F)

#Just crops
Just_Rsat <- ForStacksSSUniq$UniqID[ForStacksSSUniq$Species.x == "Rsat"]
write.table(paste( " -s ./", Just_Rsat, sep=""), file = "../Metadata/SS_Rsat_cs_stacks_list", quote = F, col.names = F, row.names = F, eol = "")
Just_Rsat <- paste(Just_Rsat, ".sam", sep = "")
write.table(Just_Rsat, file = "../Metadata/SS_Rsat_stacks_list", quote = F, col.names = F, row.names = F)
Just_Rsat <- gsub("_q20.sam","", Just_Rsat )
write.table(Just_Rsat, file = "../Metadata/SS_Rsat_stacks_fastqs", quote = F, col.names = F, row.names = F)

#RRR and landra
Rrr_landra <- ForStacksSSUniq$UniqID[ForStacksSSUniq$Species.x == "Rrr" | ForStacksSSUniq$Species.x == "Rrl"]
write.table(paste( " -s ./", Rrr_landra, sep=""), file = "../Metadata/SS_RrrRrl_cs_stacks_list", quote = F, col.names = F, row.names = F, eol = "")
Rrr_landra <- paste(Rrr_landra, ".sam", sep = "")
write.table(Rrr_landra, file = "../Metadata/SS_RrrRrl_stacks_list", quote = F, col.names = F, row.names = F)
Rrr_landra <- gsub("_q20.sam","", Rrr_landra )
write.table(Rrr_landra, file = "../Metadata/SS_RrrRrl_stacks_fastqs", quote = F, col.names = F, row.names = F)




#All signature of selection
All_SS <- ForStacksSSUniq$UniqID

write.table(paste( " -s ./", All_SS, sep=""), file = "../Metadata/SS_cs_stacks_list", quote = F, col.names = F, row.names = F, eol = "")

All_SS <- paste(All_SS, ".sam", sep = "")

write.table(All_SS, file = "../Metadata/SS_stacks_list", quote = F, col.names = F, row.names = F)
All_SS <- gsub("_q20.sam","", All_SS )  
write.table(All_SS, file = "../Metadata/SS_stacks_fastqs", quote = F, col.names = F, row.names = F)




# Write out ChooseSigSel.sh

AEcommand <- cbind("cp", select(ForStacksAEUniq, UniqID), "AE_Deconvoluted/", select(ForStacksAEUniq, UniqID))
AEcommand$Folder <- paste(AEcommand[,3], AEcommand[,4], ".sam", sep = "")
colnames(AEcommand) <- c("cp", "UniqID", "JustFolder", "UniqRepeat", "Folder")


SScommand <- cbind("cp", select(ForStacksSSUniq, UniqID), "SigSelection/", select(ForStacksSSUniq, UniqID))
SScommand$Folder <- paste(SScommand[,3], SScommand[,4], ".sam", sep = "")
colnames(SScommand) <- c("cp", "UniqID", "JustFolder", "UniqRepeat", "Folder")
command <- rbind(AEcommand, SScommand)
command <- mutate(command, UniqID=paste("*",UniqID, ".fq.sam", sep=""))
command <- select(command, cp, UniqID, Folder)

#write.table(x = command, file = "1.4_ChooseSigSel.sh", quote = F,
#            sep = " ", col.names = F, row.names = F)

# Write out full data with phenotypes for SigSelection

FullSS <- filter( DNA_data, Type_Year == "SigSelection")
FullSSUniq <- dplyr::left_join(FullSS, All_geno_data, by=c("ID"="DNASample"))
FullSSUniq <- droplevels(FullSSUniq)

GeographyList <- c(AFFR="France", AROL="NA", BINY="nonNative", DEES="Spain", ESNK="NA",
                   GMIL="pugiformis", MAES="Spain", NAAU="nonNative", NELO="NA",
                   OIBG="NA", PBFR="France", RA226="Algeria", RA444="Italy",
                   RA761="Turkey", RA808="Turkey", RABG="NA", RACA="NA", SAES="Spain",
                   SPNK="NA", TOBG="NA", YEIL="pugiformis")

TaxonomyList <- c(AFFR="raphanistrum", AROL="oleifera", BINY="raphanistrum", DEES="raphanistrum",
                  ESNK="european", GMIL="pugiformis", MAES="raphanistrum", NAAU="raphanistrum", NELO="daikon",
                  OIBG="oleifera", PBFR="landra", RA226="landra", RA444="landra",
                  RA761="landra", RA808="landra", RABG="caudatus", RACA="caudatus", SAES="landra",
                  SPNK="european", TOBG="daikon", YEIL="pugiformis")


HabitatList <- c(AFFR="agricultural", AROL="cultivar", BINY="agricultural", DEES="natural",
                 ESNK="cultivar", GMIL="natural", MAES="disturbed", NAAU="agricultural", NELO="cultivar",
                 OIBG="cultivar", PBFR="natural", RA226="natural", RA444="natural",
                 RA761="natural", RA808="natural", RABG="cultivar", RACA="cultivar", SAES="natural",
                 SPNK="cultivar", TOBG="cultivar", YEIL="natural")

LocationList <- c(AFFR="raphNatW", AROL="oleifera", BINY="raphNN", DEES="raphNatW",
                  ESNK="european", GMIL="pugiformis", MAES="raphNatW", NAAU="raphNN", NELO="daikon",
                  OIBG="oleifera", PBFR="landra", RA226="landra", RA444="landra",
                  RA761="landra", RA808="landra", RABG="caudatus", RACA="caudatus", SAES="landra",
                  SPNK="european", TOBG="daikon", YEIL="pugiformis")

SpeciesList <- c(AFFR="raphanistrum", AROL="sativus", BINY="raphanistrum", DEES="raphanistrum",
                 ESNK="sativus", GMIL="pugiformis", MAES="raphanistrum", NAAU="raphanistrum", NELO="sativus",
                 OIBG="sativus", PBFR="raphanistrum", RA226="raphanistrum", RA444="raphanistrum",
                 RA761="raphanistrum", RA808="raphanistrum", RABG="sativus", RACA="sativus", SAES="raphanistrum",
                 SPNK="sativus", TOBG="sativus", YEIL="pugiformis")



OrderList <- c(AFFR=1, AROL=7, BINY=2, DEES=3,
               ESNK=1, GMIL=1, MAES=4, NAAU=5, NELO=3,
               OIBG=8, PBFR=1, RA226=3, RA444=4,
               RA761=5, RA808=6, RABG=5, RACA=6, SAES=2,
               SPNK=2, TOBG=4, YEIL=2)

FullSSUniq$Geo <- as.factor(GeographyList[FullSSUniq$Cross])
FullSSUniq$Taxon <- as.factor(TaxonomyList[FullSSUniq$Cross])
FullSSUniq$Habit <- as.factor(HabitatList[FullSSUniq$Cross])
FullSSUniq$locals <- as.factor(LocationList[FullSSUniq$Cross])
FullSSUniq$Species <- as.factor(SpeciesList[FullSSUniq$Cross])
FullSSUniq$Order <- as.factor(OrderList[FullSSUniq$Cross])
FullSSUniq$Order <- as.numeric(FullSSUniq$Order)

FullSSUniq <- select(FullSSUniq, -Pedigree, -Population, -SeedLot, -Species.y)

colnames(FullSSUniq) <- c("ID","Type_Year","STACKSspecies","Pop","Indiv","Date",
                               "Prep","Flowcell","Lane","Barcode","LibraryPlate",
                               "Row","Col","LibraryPrepID","LibraryPlateID","Enzyme",
                               "BarcodeWell","DNA_Plate","SampleDNA_Well","Genus",
                               "FullSampleName","UniqID","Geo","Taxon","Habit","locals",
                               "Species","Order")

write.csv(FullSSUniq, "../Metadata/SigSelectionMeta.csv")
