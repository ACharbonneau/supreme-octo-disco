Install function for packages    
packages<-function(x){
  x<-as.character(match.call()[[2]])
  if (!require(x,character.only=TRUE)){
    install.packages(pkgs=x,repos="http://cran.r-project.org")
    require(x,character.only=TRUE)
  }
}

packages(fastqcr)

qc <- qc_aggregate(".")

qc_report(qc.dir, result.file = "multi-qc-report" )
