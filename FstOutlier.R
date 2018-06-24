
# Install function for packages    
packages<-function(x){
  x<-as.character(match.call()[[2]])
  if (!require(x,character.only=TRUE)){
    install.packages(pkgs=x,repos="http://cran.r-project.org")
    require(x,character.only=TRUE)
  }
}
packages(dplyr)
packages(ggplot2)




ALLTHEFILES <- dir("../ProcessRadtags/SS_20180415_P_Pop20_Ind.80_m2_n7/", pattern = ".*fst_.*-.*")

File_Num <- length(ALLTHEFILES)

File_list <- data.frame(matrix(unlist(strsplit(ALLTHEFILES, "\\_|\\-|\\.")), ncol = 6, byrow = T))
File_list$runname <- ALLTHEFILES
colnames(File_list) <- c("batch", "Date", "fst", "Pop1", "Pop2", "tsv", "runname")
File_list <- select(File_list, runname, Date, Pop1, Pop2)

pdf(file="../figures/PairwiseFstAll.pdf")

for( fst_file in 1:length(File_list$runname)){
  #fst_file <- 21
  dataset <- File_list[fst_file, 1]
  fst_comp <- 0
  fst_comp <- read.csv(paste("../ProcessRadtags/SS_20180415_P_Pop20_Ind.80_m2_n7/", 
                             dataset, sep=""), sep = "\t")
  
  fst_comp$sigFisherP <- fst_comp$Fisher.s.P < .05
  
   print(ggplot(fst_comp, aes(Locus.ID, Smoothed.Fst, col= Odds.Ratio, shape=sigFisherP )) + geom_point() +
    scale_colour_gradientn(colours= c("Black", "Red")) + 
    ggtitle(paste("Fst ", File_list$Pop1[fst_file], " vs ", File_list$Pop2[fst_file], sep="")))
}

dev.off()




