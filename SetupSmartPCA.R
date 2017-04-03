
#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)

print(args[1])

stacksgenotypes <- data.table::fread(paste("../", args[1], sep = ""), header = F, sep="\t")
stacksmarkers <- read.table(paste("../", args[1], sep = ""), nrows = 1, skip = 1)
stacksmarkers <- as.data.frame(c("SSR", stacksmarkers))

forbiallele <- paste("../output/", args[1], "_for_biallele.csv", sep = "")
donebiallele <- paste("../output/", args[1], "_biallele.csv", sep="")

write.table(stacksmarkers, forbiallele, sep = ",", col.names = F, row.names = F, quote = F)

write.table(select(stacksgenotypes, -V2), forbiallele, col.names = F, sep = ",", row.names = F, append = T, quote = F)

system(paste("python bi-winning_allele.py", forbiallele, "-o", biallele, sep = " "), intern = TRUE,
       ignore.stdout = FALSE, ignore.stderr = FALSE,
       wait = TRUE, input = NULL)


geno <- as.data.frame(t(select(biallele, -SSR)))
write.table(geno, paste(args[1],".geno", sep = ""), sep = "", col.names = F, row.names = F, quote = F)

ind <- select(biallele, SSR)
ind$SSR <- as.factor(ind$SSR)
ind <- left_join(ind, SSmeta, by=c("SSR"="V1"))
ind$U <- "U"
ind <- select(ind, SSR, U, V2)

write.table(ind, paste(args[1],".ind", sep = ""), sep = "\t", col.names = F, row.names = F, quote = F)

snp <- colnames(biallele)
snp <- as.data.frame(snp[2:length(snp)])
#snp$FakeChromo <- rep(1:(length(snp$`snp[2:length(snp)]`)/104), each=104)
snp$FakeChromo <- rep(c(1:21), 104)
snp$zero1 <- 0
snp$zero2 <- 0

write.table(snp, paste(args[1],".snp", sep = ""), sep = "\t", col.names = F, row.names = F, quote = F)

