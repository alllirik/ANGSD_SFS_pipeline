for(i in seq(2, 4, by=2))
{
  print(i)
  nnorm <- function(x) x/sum(x)
  path_1 = paste(c(i,"X/GL1.",i,"X.sfs"), collapse = "")
  path_2 = paste(c(i,"X/GL2.",i,"X.sfs"), collapse = "")
  res <- rbind(
    GL1=scan(path_1)[-1],
    GL2=scan(path_2)[-1]
  )
  #density instead of expected counts
  res <- t(apply(res,1,nnorm))
  
  name=paste(c("SFS_",i,"X.pdf"), collapse = "")
  pdf(file = name,   # The directory you want to save the file in
      width = 6, # The width of the plot in inches
      height = 4) # The height of the plot in inches
  
  #plot the none ancestral sites
  barplot(res,beside=T,main="Folded SFS", names=1:20, col=c("lightblue","blue"))
  legend("topright", 
         fill = c("lightblue","blue"),
         legend = c("SAMtools", "GATK"), 
         cex = 0.35)
  
  dev.off()
}
