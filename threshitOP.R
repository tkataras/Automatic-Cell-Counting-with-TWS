library("EBImage")
library("OpenImageR")


threshitOP <- function(datain = test1, start_offset = .02, end_offset = .8, interval =0.05, title = "NA", opening_size = 3){
  counter <- 1
  cellcount <- NA
  offsets <- c(seq(start_offset,end_offset,interval))
  
  for (i in offsets){
    nmasktest = thresh(datain, w=10, h=10, offset=i) 
    opening_test <- opening(nmasktest, makeBrush(3, shape='disc'))#added an opening step
    cellcount[counter] <- max(bwlabel(opening_test))
    counter <- counter+1
    
  }
  graph <- data.frame(offsets, cellcount)
  scatter.smooth(graph[,], xlab = title)
  
}
