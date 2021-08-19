library("EBImage")
library("OpenImageR")


openit <- function(datain = test1, start_size = .02, end_size = .8, interval =0.05, title = "NA", opening_size = 5){
  counter <- 1
  cellcount <- NA
  size <- c(seq(start_size,end_size,interval))
  
  for (i in size){
    nmasktest = thresh(datain, w=10, h=10, offset=.01) 
    opening_test <- opening(nmasktest, makeBrush(i, shape='disc'))#added an opening step
    cellcount[counter] <- max(bwlabel(opening_test))
    counter <- counter+1
    
  }
  graph <- data.frame(size, cellcount)
  scatter.smooth(graph[,], xlab = title)
  
}
