gateit <- function(datain = NA, mn = , mx = ){
  
  datain = test4
  mn = (mean(test3)*.6)
  mx = 1.8 #??
  
  datain_mn <- datain - mn #sub min val
  datain_mn[datain_mn <= 0] = 0
  
  #scalin to max
  
  
  test4b_mm2 <- datain_mn/(max(datain_mn))
  display(test4b_mm2)
  
  
  
  
  display(combine(datain, datain_mn), all=T)
  
  datain_mn2 <- datain_mn
  display(combine(datain, datain_mn, datain_mn2), all=T)
  
  max(datain_mn)
  
  ############need to figure out how to set top 30% of values to 1.
  
  ##example code for top 5% 
  #n <- 5
  #data[data$V2 > quantile(data$V2,prob=1-n/100),]
  
  quantile(datain_mn2, probs = mx/100)##how is this bigger than max datain_mn2
  max(datain_mn2)
  
  mx <- 90
  datain_mx <- NA
  datain_mx[datain_mn2 > quantile(datain_mn2,prob=1-mx/100),]
  
  test3b_mm2 <- test3b_mm/(max(test3b_mm))
  display(test3b_mm2)
  
  showme(datain = test3b_mm2, start_offset=.05, end_offset=.15, interval = .002, count = 209)
  
  test3b_mm2_th <- thresh(test3b_mm2, w=20,h=20, offset = .01)
  display(combine(test3b_mm2, test3b_mm2_th), all=T)
  
  test3b_mm2_th_op <- opening(test3b_mm2_th, makeBrush(7, shape='disc'))
  display(combine(test3b_mm2, test3b_mm2_th, test3b_mm2_th_op), all=T) #just opening not good
  
   w = makeBrush(size = 11, shape = 'gaussian', sigma = )  # makes the blurring brush
   test3b_mm2_bl <- filter2(test3b_mm2, w) # apply the blurring filter
   
   display(combine(test3b_mm2, test3b_mm2_th, test3b_mm2_th_op, test3b_mm2_bl), all=T) #just opening not good
   
   test3b_mm2_bl_th <- thresh(test3b_mm2_bl, w=10,h=10, offset = .01)
  
  display(test3b_mm2_bl_th)  
  
  #opening before thresholding as in retinal microglia quant paper
  test3b_mm2_op <- opening(cel>0.1, test3b_mm2, makeBrush(25, shape = 'disc'))
  display(test3b_mm2_op, title='test3b_mm2_op')
  
  display(test3b_mm2_op, title='test3b_mm2_op')
  
  
    test <- bwlabel(test3b_mm2_op)
    display(test)
    writeImage(test3b_mm2, "test3b_mm2.tiff") #writing out the scaled cropped file
    
    }