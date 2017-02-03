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


## Get data frames
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


F2_Pheno_data <- read.csv("../Metadata/Exsertion_F2_F2s.csv", colClasses = 
                         c(rep("factor", 7), rep("numeric", 7), "factor"))

Parent_Pheno_data <- read.csv("../Metadata/Exsertion_F2_Parents.csv", colClasses = 
                            c(rep("factor", 2), rep("numeric", 7), "factor"))

DNA_data <- read.csv("../Metadata/MetadataAll.txt", sep = "\t", header = F,
                     colClasses = "factor")


colnames(DNA_data) <- c("ID", "Type_Year", "Species", "CrossX", "Indiv", "Date", "Prep")

## Filter out F2s from Parents from F1s

AE_F2_DNA <- filter( DNA_data, Type_Year != "SigSelection" & 
                       Type_Year!="AS_EX_QTL_Parents_2011" & 
                       Type_Year!="AS_EX_QTL_F1s_2011") %>%
              separate( Indiv, into = c("Family", "F2" ), sep = "/")

AE_F2_DNA <- droplevels(AE_F2_DNA)

AE_Parent_DNA <- filter( DNA_data, Type_Year=="AS_EX_QTL_Parents_2011")

AE_Parent_DNA <- droplevels(AE_Parent_DNA)

AE_F1_DNA <- filter( DNA_data, Type_Year=="AS_EX_QTL_F1s_2011")

AE_F1_DNA <- droplevels(AE_F1_DNA)

write.csv(x = AE_F1_DNA, file = "../Metadata/AE_F1_merge.csv")

## Merge F2s sequencing and phenotype data

CrossList <- c(KF2="KxK", KXf2="KxR", KXF2="KxR", RF2="RxR", RXF2="RxK")

AE_F2_DNA$Family <- factor(gsub( "[()]", "", AE_F2_DNA$Family ))

AE_F2_DNA$Cross <- as.factor(CrossList[AE_F2_DNA$CrossX])

AE_F2_DNA <- left_join(AE_F2_DNA, F2_Pheno_data)

write.csv(x = AE_F2_DNA, file = "../Metadata/AE_F2_merge.csv")

# Write out STACKS metadata

ForStacksAE <- rbind(select(AE_F2_DNA, ID, CrossX, Type_Year), 
      select(AE_Parent_DNA, ID, CrossX, Type_Year),
      select(AE_F1_DNA, ID, CrossX, Type_Year))

ForStacksAEUniq <- dplyr::left_join(ForStacksAE, All_geno_data, by=c("ID"="DNASample"))

write.table(x = select(ForStacksAEUniq, UniqID, CrossX, Type_Year), file = "../Metadata/AE_deconvoluted.pop", 
            quote = F, sep = "\t", col.names = F, row.names = F)

ForStacksSS <- filter( DNA_data, Type_Year == "SigSelection") %>%
  select(ID, CrossX, Species)

ForStacksSSUniq <- dplyr::left_join(ForStacksSS, All_geno_data, by=c("ID"="DNASample"))


write.table(x = select(ForStacksSSUniq, UniqID, CrossX, Species.x), file = "../Metadata/SigSelection.pop", 
            quote = F, sep = "\t", col.names = F, row.names = F)

# Write out ChooseSigSel.sh

AEcommand <- cbind("cp", select(ForStacksAEUniq, UniqID), "AE_Deconvoluted/", select(ForStacksAEUniq, UniqID)) 
AEcommand$Folder <- paste(AEcommand[,3], AEcommand[,4], ".bam", sep = "")
colnames(AEcommand) <- c("cp", "UniqID", "JustFolder", "UniqRepeat", "Folder")


SScommand <- cbind("cp", select(ForStacksSSUniq, UniqID), "SigSelection/", select(ForStacksSSUniq, UniqID))
SScommand$Folder <- paste(SScommand[,3], SScommand[,4], ".bam", sep = "")
colnames(SScommand) <- c("cp", "UniqID", "JustFolder", "UniqRepeat", "Folder")
command <- rbind(AEcommand, SScommand)
command <- mutate(command, UniqID=paste("*",UniqID, ".fq.sorted.bam", sep=""))
command <- select(command, cp, UniqID, Folder)

write.table(x = command, file = "1.4_ChooseSigSel.sh", quote = F,
            sep = " ", col.names = F, row.names = F)


