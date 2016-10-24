# There are no unique identifiers in this project until the DNA prep, 
# and the ID names change subtley between datasheets. This script just
# munges the metadata into one useable format with unique IDs.

require(tidyr)
require(dplyr)

DNA_data <- read.csv("../RawData/MetadataAEall.txt", sep = "\t", header = F)
Pheno_data <- read.csv("../RawData/Exsertion F2 All.csv")

colnames(DNA_data) <- c("UniqID", "Type_Year", "Species", "Cross", "Indiv", "Prep")

AE_DNA_data <- filter(DNA_data, Type_Year != "SigSelection")

DNA_data <- separate(DNA_data, Indiv, into = c("Family", "F2" ), sep = "/")
