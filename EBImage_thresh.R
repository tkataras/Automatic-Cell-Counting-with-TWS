library("EBImage")
library("OpenImageR")

#test <- readImage(("C:/Users/User/Desktop/Kaul_lab_work/6_6/HPC 382-s74-Iba1_SYN-04062018-C-10X F3b_XY1523048841_Z0_T0_C174F3b.tiff"))
test <- readImage(("C:/Users/User/Desktop/Kaul_lab_work/6_6/HPC360-s59-Iba1-05232018-10X-C-F1a 1280X1280_XY1527116341_Z0_T0_C1.tiff"))

test_min <- test - mean(test)
test_min_hlf <- test - mean(test)*0.5

w = makeBrush(size = 11, shape = 'gaussian', sigma = 5)  # makes the blurring brush
blur_test = filter2(test, w) # apply the blurring filter
blur_test_min = filter2(test_min, w)
blur_test_min_hlf = filter2(test_min_hlf, w)

display(combine(blur_test,blur_test_min, blur_test_min_hlf), all = T) # display the blurred image - brighter for display only. 


#########dialation and erosion can be used to filter out small particle noise
kern = makeBrush(5, shape='diamond')
erode_test <- erode(blur_test, kern)

display(combine(blur_test,erode_test), all = T)


dilate_test = dilate(erode_test, kern)##dialate seems to return eroded noise

display(combine(blur_test,erode_test,dilate_test), all = T)

nmasktest15 = thresh(dilate_test, w=10, h=10, offset=0.015) # not blurred, lots of tiny, non count bits
nmasktest20 = thresh(dilate_test, w=10, h=10, offset=0.020)
nmasktest25 = thresh(dilate_test, w=10, h=10, offset=0.025)

display(combine(nmasktest15,nmasktest20,nmasktest25), all = T)
dkern2 <- makeBrush(2, shape = 'diamond')
erode2_test <- erode(nmasktest15, kern2)
display(combine(test,nmasktest15,erode2_test), all = T)


dil2_test <- dilate(erode2_test, kern2)
display(dil2_test)



###############code below tests a range of sequences and then counts connected object


offsets <- c(seq(0,0.5,.001))
length(offsets)
counter <- 1
cellcount <- NA
for (i in offsets){
  nmasktest = thresh(dilate_test, w=10, h=10, offset=i) # not blurred, lots of tiny, non count bits
  cellcount[counter] <- max(bwlabel(nmasktest))
  counter <- counter+1
}
hist(cellcount[1:60])
hist(c(2,2,2,2,3))

graph <- data.frame(offsets, cellcount)
scatter.smooth(graph[1:60,])


######trying different brush sizes

brushsize <- c(seq(1,20,1))
length(brushsize)
counter <- 1
cellcount <- NA
for (i in brushsize){
  nmasktest = thresh(dilate_test, w=i, h=i, offset=0.025) 
  cellcount[counter] <- max(bwlabel(nmasktest))
  counter <- counter+1
}
hist(cellcount[1:60])
hist(c(2,2,2,2,3))

graph <- data.frame(brushsize, cellcount)
scatter.smooth(graph[1:60,])

#testing what various brushsizes look like
nmasktest1 = thresh(dilate_test, w=8, h=8, offset=0.025) 
cellcount1 <- max(bwlabel(nmasktest1))

nmasktest2 = thresh(dilate_test, w=10, h=10, offset=0.025) 
cellcount2 <- max(bwlabel(nmasktest2))

nmasktest3 = thresh(dilate_test, w=12, h=12, offset=0.025) 
cellcount3 <- max(bwlabel(nmasktest1))

display(combine(nmasktest1, nmasktest2, nmasktest3), all=T)


#testing "opening" it combines erode and then dialate
opening_test <- opening(nmasktest2, makeBrush(5, shape='disc'))
display(combine(test, nmasktest2, opening_test), all=T)


#####testing different blur brush sigmas

#w = makeBrush(size = 11, shape = 'gaussian', sigma = 5)  # makes the blurring brush
#blur_test = filter2(test, w) # apply the blurring filter


sigma <- c(seq(1,10,.05))
length(brushsize)
counter <- 1
cellcount <- NA
for (i in brushsize){
  
  w = makeBrush(size = 11, shape = 'gaussian', sigma = i)  # makes the blurring brush
  blur_test = filter2(test, w) # apply the blurring filter
  
  nmasktest = thresh(blur_test, w=10, h=10, offset=0.025) 
  cellcount[counter] <- max(bwlabel(nmasktest))
  counter <- counter+1
}
hist(cellcount[1:60])

graph <- data.frame(sigma, cellcount)
scatter.smooth(graph[,])

#for display, sigma 4, 5, 6
w = makeBrush(size = 11, shape = 'gaussian', sigma = 3)  # makes the blurring brush
blur_test0 = filter2(test, w) # apply the blurring filter
blur_test_tresh0 = thresh(blur_test0, w=10, h=10, offset=0.025) 


w = makeBrush(size = 11, shape = 'gaussian', sigma = 4)  # makes the blurring brush
blur_test1 = filter2(test, w) # apply the blurring filter
blur_test_tresh1 = thresh(blur_test1, w=10, h=10, offset=0.025) 

w = makeBrush(size = 11, shape = 'gaussian', sigma = 5)  # makes the blurring brush
blur_test2 = filter2(test, w) # apply the blurring filter
blur_test_tresh2 = thresh(blur_test2, w=10, h=10, offset=0.025) 

w = makeBrush(size = 11, shape = 'gaussian', sigma = 6)  # makes the blurring brush
blur_test3 = filter2(test, w) # apply the blurring filter
blur_test_tresh3 = thresh(blur_test3, w=10, h=10, offset=0.025) 

test_thresh = thresh(test, w=10, h=10, offset=0.025)

display(combine(test,test_thresh, blur_test0,blur_test_tresh0,blur_test1,blur_test_tresh1,  blur_test2,blur_test_tresh2, blur_test3,blur_test_tresh3), all=T)


test_thresh_opening <- opening(test_thresh, makeBrush(5, shape='disc'))
test_thresh_opening_g <- opening(test_thresh, makeBrush(5, shape='gaussian'))#gauss brushes remove more small points, creates right angles on cell bodies,not ideal?

display(combine(test, test_thresh,test_thresh_opening,test_thresh_opening_g), all=T)
