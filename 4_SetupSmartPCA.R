
#!/usr/bin/env Rscript

# Install function for packages
packages<-function(x){
  x<-as.character(match.call()[[2]])
  if (!require(x,character.only=TRUE)){
    install.packages(pkgs=x,repos="http://cran.r-project.org")
    require(x,character.only=TRUE)
  }
}

packages(dplyr)

args = commandArgs(trailingOnly=TRUE)

#print(args[1])

#args="NameOfStructureFile" "path to .pop file" "path to 4.1_bi-winning_allele.py"
#args="batch_20170402.structure.tsv"

metadata <- read.csv(args[2], header = F, sep="\t")
stacksgenotypes <- data.table::fread(paste("../", args[1], sep = ""), header = F, sep="\t")
stacksmarkers <- read.table(paste("../", args[1], sep = ""), nrows = 1, skip = 1)

newbasename <- strsplit(args[1], split = ".structure.tsv")
newbasename <- strsplit(newbasename[[1]], split = "batch_")[[1]][2]

stacksmarkers <- as.data.frame(c("SSR", stacksmarkers))

forbiallele <- paste(newbasename, "_for_biallele.csv", sep = "")
donebiallele <- paste(newbasename, "_biallele.csv", sep="")

write.table(stacksmarkers, forbiallele, sep = ",", col.names = F, row.names = F, quote = F)

write.table(select(stacksgenotypes, -V2), forbiallele, col.names = F, sep = ",", row.names = F, append = T, quote = F)

system(paste("python", args[3], forbiallele, "-o", donebiallele, sep = " "), intern = TRUE,
       ignore.stdout = FALSE, ignore.stderr = FALSE,
       wait = TRUE, input = NULL)

biallele <- read.csv(donebiallele)


geno <- as.data.frame(t(select(biallele, -SSR)))
write.table(geno, paste(newbasename,".geno", sep = ""), sep = "", col.names = F, row.names = F, quote = F)

ind <- select(biallele, SSR)
ind$SSR <- as.factor(ind$SSR)
ind <- left_join(ind, metadata, by=c("SSR"="V1"))
ind$U <- "U"
ind <- select(ind, SSR, U, V2)

write.table(ind, paste(newbasename,".ind", sep = ""), sep = "\t", col.names = F, row.names = F, quote = F)

snp <- colnames(biallele)
snp <- as.data.frame(snp[2:length(snp)])
snp$FakeChromo <- c(1, 2, 3)
snp$zero1 <- 0
snp$zero2 <- 0

write.table(snp, paste(newbasename,".snp", sep = ""), sep = "\t", col.names = F, row.names = F, quote = F)

parnames <- c("genotypename:", "snpname:", "indivname:", "evecoutname:",
              "evaloutname:", "altnormstyle:", "numoutevec:", "familynames:",
              "grmoutname:", "snpweightoutname:", "genotypeoutname:",
              "snpoutname:", "indivoutname:")

parvalues <- c(paste(newbasename,".geno", sep = ""), paste(newbasename,".snp", sep = ""),
               paste(newbasename,".ind", sep = ""), paste(newbasename,".evec", sep = ""),
               paste(newbasename,".eval", sep = ""), "NO", length(snp$zero2), "NO",
               paste(newbasename,".grmjunk", sep = ""), paste(newbasename,".weights", sep = ""),
               paste(newbasename,".badgeno", sep = ""), paste(newbasename,".badsnp", sep = ""),
               paste(newbasename,".badindiv", sep = ""))
parfile <- cbind(parnames, parvalues)

write.table(parfile, "smartpca.par", quote = F, sep = " ", row.names = F, col.names = F)
