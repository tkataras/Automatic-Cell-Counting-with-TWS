##function to compare thresholding effect
library("EBImage")
library("OpenImageR")


# test1 <- readImage(("C:/Users/User/Desktop/Kaul_lab_work/Rohan/LAV2378-s75-051116-Iba-PSD95-10x-cortex-F1_XY1525225408_Z0_T0_C1test.tiff"))
# test2 <- readImage(("C:/Users/User/Desktop/Kaul_lab_work/Rohan/LAV2378-s75-051116-Iba-PSD95-10x-cortex-F2_XY1525225431_Z0_T0_C1test.tiff"))
# test3 <- readImage(("C:/Users/User/Desktop/Kaul_lab_work/Rohan/LAV2378-s75-051116-Iba-PSD95-10x-cortex-F3_XY1525225462_Z0_T0_C1test.tiff"))


### cropping as paint is unsitable and imageJ has stopped cropping the selected areas for some reason
#dim(test1)
#test1crop <- test1[150:1181,1:1280]
#display(test1crop)
#test1 <- test1crop

#test2crop <- test2[150:1280,1:1280]
#display(combine(test2crop ), all = T)
#test2 <- test2crop

#test3crop <- test3[100:1280,1:1280]
#display(combine(test3crop ), all = T)
#test3 <- test3crop



threshit <- function(datain = test1, start_offset = .02, end_offset = .8, interval =0.05, title = "NA"){
  counter <- 1
  cellcount <- NA
  offsets <- c(seq(start_offset,end_offset,interval))
  
  for (i in offsets){
    nmasktest = thresh(datain, w=10, h=10, offset=i) 
    cellcount[counter] <- max(bwlabel(nmasktest))
    counter <- counter+1
     
    }
  graph <- data.frame(offsets, cellcount)
  scatter.smooth(graph[,], xlab = title)
  
}

#source("C:/Users/User/Desktop/Kaul_lab_work/work_6_19.R")
#threshit(test1, start_offset = .08, end_offset = .2, interval = .005, title = "408 threshold")
