# There are no unique identifiers in this project until the DNA prep,
# and even in the DNA prep, the unique identifiers aren't unique because
# ~80 samples were sequenced twice.
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
packages(dplyr)



## They sequenced lots of samples twice, but used the same names, which breaks
## the deconvolution step. This loop gives each sample a unique name and writes
## out a new sequence list file for each lane with the unique names

Geno_dir <- file.path("../Metadata/PlateInfoSeq/")

Geno_list <- list.files(Geno_dir, pattern = "*gz.keys.txt")

All_geno_data <- list()

for( X in 1:length(Geno_list)){
  TempFile <- read.table(paste(Geno_dir, Geno_list[ X ], sep=""), sep = "\t", header = T, na.strings = "")
  TempFile$UniqID <- paste(TempFile$DNASample, TempFile$DNA_Plate, sep="_")
  All_geno_data[[X]] <- TempFile
  write.table(TempFile, paste(Geno_dir, substr(Geno_list[X], 1, 11), ".unique.txt", sep=""), sep="\t", row.names=F, col.names=F, quote=F)
}


All_geno_data <- tbl_df( do.call( "rbind", All_geno_data ))

## Get global data frames

Samfile <- read.csv("../Metadata/OriginalFiles/ID_samfile.csv", head=T, colClasses = "factor")


DNA_data <- read.csv("../Metadata/MetadataAll.txt", sep = "\t", header = F,
                     colClasses = "factor")

colnames(DNA_data) <- c("ID", "Type_Year", "Species", "Cross", "Indiv", "Date", "Prep")

DNA_data <- left_join(DNA_data, Samfile)

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

ForStacksAE <- rbind(select(AE_F2_DNA, ID, Cross, Type_Year), 
      select(AE_F0_DNA, ID, Cross, Type_Year),
      select(AE_F1_DNA, ID, Cross, Type_Year))

ForStacksAEUniq <- dplyr::left_join(ForStacksAE, All_geno_data, by=c("ID"="DNASample"))

ForStacksAEUniq <- unique(ForStacksAEUniq)

write.table(x = select(ForStacksAEUniq, UniqID, Cross, Type_Year), file = "../Metadata/AE_Deconvoluted.pop", 
            quote = F, sep = "\t", col.names = F, row.names = F)

ForStacksSS <- filter( DNA_data, Type_Year == "SigSelection") %>%
  select(ID, Cross, Species)

ForStacksSSUniq <- dplyr::left_join(ForStacksSS, All_geno_data, by=c("ID"="DNASample"))


write.table(x = select(ForStacksSSUniq, UniqID, Cross, Species.x), file = "../Metadata/SigSelection.pop", 
            quote = F, sep = "\t", col.names = F, row.names = F)

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

write.table(x = command, file = "1.4_ChooseSigSel.sh", quote = F,
            sep = " ", col.names = F, row.names = F)


