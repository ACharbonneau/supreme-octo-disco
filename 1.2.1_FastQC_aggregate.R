qc_report <- function(fastqcr) {
  #Install function for packages    
  packages<-function(x){
    x<-as.character(match.call()[[2]])
    if (!require(x,character.only=TRUE)){
      install.packages(pkgs=x,repos="http://cran.r-project.org")
      require(x,character.only=TRUE)
    }
  }
  
  packages(fastqcr)
}

qc.path <- "/mnt/scratch/charbo24/GBSFinal/fastQC/TrimmedFQC"

list.files(qc.path)

qc <- qc_aggregate(qc.path)

qc_report(qc.path, result.file = "All_GBS_qc_report" )



# Not run: ------------------------------------
 # Demo QC Directory
 qc.path <- "."
 qc.path

  # List of files in the directory
 list.files(qc.path)
 
 # Multi QC report
 qc_report(qc.path, result.file = "test")
 
# ---------------------------------------------
