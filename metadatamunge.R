# There are no unique identifiers in this project until the DNA prep, 
# and the ID names change subtley between datasheets. This script just
# munges the metadata into one useable format with unique IDs.

#Also makes the two .pop files

require(tidyr)
require(dplyr)

## Get data frames
Pheno_data <- read.csv("../RawData/Exsertion F2 All.csv", colClasses = 
                         c(rep("factor", 7), rep("numeric", 7), "factor"))

DNA_data <- read.csv("../RawData/MetadataAll.txt", sep = "\t", header = F,
                     colClasses = "factor")


colnames(DNA_data) <- c("UniqID", "Type_Year", "Species", "CrossX", "Indiv", "Date", "Prep")

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

## Merge F2s sequencing and phenotype data

CrossList <- c(KF2="KxK", KXf2="KxR", KXF2="KxR", RF2="RxR", RXF2="RxK")

AE_F2_DNA$Family <- factor(gsub( "[()]", "", AE_F2_DNA$Family ))

AE_F2_DNA$Cross <- as.factor(CrossList[AE_F2_DNA$CrossX])

AE_F2_DNA <- left_join(AE_F2_DNA, Pheno_data)

write.csv(x = AE_F2_DNA, file = "../Output/R/AE_F2_merge.csv")

# Write out STACKS metadata

ForStacksAE <- rbind(select(AE_F2_DNA, UniqID, CrossX, Type_Year), 
      select(AE_Parent_DNA, UniqID, CrossX, Type_Year),
      select(AE_F1_DNA, UniqID, CrossX, Type_Year))

write.table(x = ForStacksAE, file = "AE_deconvoluted.pop", 
            quote = F, sep = "\t", col.names = F, row.names = F)

ForStacksSS <- filter( DNA_data, Type_Year == "SigSelection") %>%
  select(UniqID, CrossX, Species)

write.table(x = ForStacksSS, file = "SigSelection.pop", 
            quote = F, sep = "\t", col.names = F, row.names = F)

# Write out ChooseSigSel.sh

AEcommand <- cbind("mv", select(ForStacksAE, UniqID), "AE_Deconvoluted/")
colnames(AEcommand) <- c("mv", "UniqID", "Folder")
SScommand <- cbind("mv", select(ForStacksSS, UniqID), "SigSelection/")
colnames(SScommand) <- c("mv", "UniqID", "Folder")
command <- rbind(AEcommand, SScommand)
command <- mutate(command, UniqID=paste(UniqID, ".fq", sep=""))

write.table(x = command, file = "ChooseSigSel.sh", quote = F,
            sep = " ", col.names = F, row.names = F)


