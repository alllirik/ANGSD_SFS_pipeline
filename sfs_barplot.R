nnorm <- function(x) x/sum(x)
res <- rbind(
  GL1=scan("path/to/file/filename.GL1.2X.sfs")[-1],
  GL2=scan("path/to/file/filename.GL2.2X.sfs")[-1],
  GL3=scan("path/to/file/filename.GL3.2X.sfs")[-1]
)

#density instead of expected counts
res <- t(apply(res,1,nnorm))

#plot the none ancestral sites
barplot(res,beside=T,main="Folded SFS 2X", names=1:4, col=c("lightblue","blue","darkblue"))
legend("topright", 
       fill = c("lightblue","blue","darkblue"),
       legend = c("SAMtools", "GATK", "SYK"), 
       cex = 0.35)