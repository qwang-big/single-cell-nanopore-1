if(!require(stringdist)){
    install.packages("stringdist",repos="https://cloud.r-project.org")
    library(stringdist)
}
options(stringsAsFactors = FALSE)
Sys.setlocale("LC_NUMERIC","C")
args = commandArgs(trailingOnly=TRUE)
x=read.table(args[1])
y=read.table(args[2])
y=y[seq(2,nrow(y),2),1]
r=unlist(lapply(y,function(d) x[stringdist(d,x[,2],method='dl')<2,2]))
r=unique(c(r,y))
write.table(r,file=args[3],sep="\t",quote=F,row.names=F,col.names=F)
