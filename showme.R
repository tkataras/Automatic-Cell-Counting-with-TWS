showme <- function(datain = NA, start_offset=NA, end_offset=NA, interval = NA, count = NA){
  
  #### code below compares the counts of one thresh range with and without opening ##################################################
   #datain <- test1
   #start_offset <- .01
   #end_offset <- .2
   #interval <- .005
  # 
  
  
  counter <- 1
  cellcount <- NA
  offsets <- c(seq(start_offset,end_offset,interval))
  
  for (i in offsets){
    nmasktest = thresh(datain, w=10, h=10, offset=i) 
    cellcount[counter] <- max(bwlabel(nmasktest))
    counter <- counter+1
    
  }
  graph1 <- data.frame(offsets, cellcount) #just thresholding
  
  
  counter <- 1
  cellcount <- NA
  #bluring step
  w = makeBrush(size = 11, shape = 'gaussian', sigma = 6)  # makes the blurring brush
  datain2 = filter2(datain, w) # apply the blurring filter
  display(combine(datain, datain2), all = T)
  
  
  for (i in offsets){
    
    nmasktest = thresh(datain2, w=10, h=10, offset=i) 
    #opening_test <- opening(nmasktest, makeBrush(1, shape='disc'))#spot for opening
    cellcount[counter] <- max(bwlabel(nmasktest))
    counter <- counter+1
    
  }
  
  graph2 <- data.frame(offsets, cellcount)# just blurring
  
  
  
  
  # graph12 <- cbind(graph1, graph2$cellcount)
  # p = ggplot() + 
  #   geom_line(data = graph12, aes(x = graph12$offsets, y = graph12$cellcount), color = "blue") +
  #   geom_line(data = graph12, aes(x = graph12$offsets, y = graph12$`graph2$cellcount`), color = "red") +
  #   ylim(low=1, high= 500)
  #   #labs(title = "blu = no opening, longer around count value 177")
  # 
  # print(p)
  
  
  # disp1 <- thresh(datain, w=10, h=10, offset=start_offset)
  # disp2 <- thresh(datain, w=10, h=10, offset=((end_offset - start_offset)*0.5 + start_offset))
  # disp1b <- thresh(datain2, w=10, h=10, offset=start_offset)
  # disp2b <- thresh(datain2, w=10, h=10, offset=((end_offset - start_offset)*0.5 + start_offset))
  # 
  # cellcount_disp1b <- max(bwlabel(disp1b))
  # 
  # display(combine(datain, disp1, disp2, datain2, disp1b, disp2b),all = T)
  
  #this makes blurring look very good, but blurring and opening very restrictive
  
  ## next should look at how just threshold, just blurred and just opened compare
  
  counter <- 1
  cellcount <- NA
  for (i in offsets){
    
    nmasktest = thresh(datain, w=10, h=10, offset=i) 
    opening_test <- opening(nmasktest, makeBrush(3, shape='disc'))#spot for opening
    cellcount[counter] <- max(bwlabel(opening_test))
    counter <- counter+1
    
  }
  
  graph3 <- data.frame(offsets, cellcount)#just opening
  
  
  counter <- 1
  cellcount <- NA
  
  for (i in offsets){
    
    nmasktest = thresh(datain2, w=10, h=10, offset=i) 
    opening_test <- opening(nmasktest, makeBrush(3, shape='disc'))#spot for opening
    cellcount[counter] <- max(bwlabel(opening_test))
    counter <- counter+1
    
  }
  
  graph4 <- data.frame(offsets, cellcount)# blurring and opening
  
  opening_testtest1 <- opening(nmasktest, makeBrush(1, shape='disc'))#spot for opening
  opening_testtest <- opening(nmasktest, makeBrush(2.02, shape='disc'))#spot for opening
  opening_testtest2 <- opening(nmasktest, makeBrush(2.09, shape='disc'))#spot for opening
  opening_testtest3 <- opening(nmasktest, makeBrush(3, shape='disc'))#spot for opening

  display(combine(opening_testtest1,opening_testtest, opening_testtest2, opening_testtest3), all= T)
  
  optestcount2 <- max(bwlabel(opening_testtest2))
  optestcount3 <- max(bwlabel(opening_testtest3))
  
  
  
  graph123 <- cbind(graph1, graph2$cellcount, graph3$cellcount, graph4$cellcount)# shows that blurring reduces the ridiculously high counts atound 0.04 thresholds
  #names(graph123)
  #line[1:length(offsets)] <- 113# hand count of cropped test1 gave 177 microglia
  
  
  
  
  p2 = ggplot() + 
    geom_line(data = graph123, aes(x = graph123$offsets, y = graph123$cellcount), color = "blue") +
    geom_line(data = graph123, aes(x = graph123$offsets, y = graph123$`graph2$cellcount`), color = "red") +
    geom_line(data = graph123, aes(x = graph123$offsets, y = graph123$`graph3$cellcount`), color = "green") +
    geom_line(data = graph123, aes(x = graph123$offsets, y = graph123$`graph4$cellcount`), color = "brown") +
    geom_hline(yintercept = count) +
    #geom_vline(xintercept=otsu(datain)) +
    ylim(low=50, high= 400) +
    labs(title = "blu = thresh,red = blur, grn = open, brwn = blr+op")
  
  print(p2)
  
  
  
  
  
}