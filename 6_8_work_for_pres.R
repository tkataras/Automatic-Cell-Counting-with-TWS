library("EBImage")
library("OpenImageR")

test <- readImage(("C:/Users/User/Desktop/Kaul_lab_work/6_6/HPC 382-s74-Iba1_SYN-04062018-C-10X F3b_XY1523048841_Z0_T0_C174F3b.tiff"))
test2 <- readImage(("C:/Users/User/Desktop/Kaul_lab_work/6_6/HPC360-s59-Iba1-05232018-10X-C-F1a 1280X1280_XY1527116341_Z0_T0_C1.tiff"))

test1minusmean <- test - mean(test)

####First step is to blur the initial image to reduce the intensity gradients of the processes
w = makeBrush(size = 11, shape = 'gaussian', sigma = 5)  # makes the blurring brush
blur_test = filter2(test, w) # apply the blurring filter
blur_test2 = filter2(test2, w) 
blur_test1minusmean = filter2(test1minusmean, w)



#writeImage(blur_test, "sample.jpeg", quality = 85)




display(combine(test, blur_test, test2, blur_test2), all = T)


#######thresholding on test
offsets <- c(seq(0,0.5,.001))
length(offsets)
counter <- 1
cellcount <- NA
for (i in offsets){
  nmasktest = thresh(blur_test, w=10, h=10, offset=i) # not blurred, lots of tiny, non count bits
  cellcount[counter] <- max(bwlabel(nmasktest))
  counter <- counter+1
}
hist(cellcount[1:60])

graph <- data.frame(offsets, cellcount)
scatter.smooth(graph[,], xlab = "test counts, varying theshold offset")
pdf("test_counts.pdf")
dev.off()


###shorter range of thresh values
offsets2 <- c(seq(0.01,0.05,0.001))
pdf("test_counts_01_03.pdf")
length(offsets2)
counter <- 1
cellcount <- NA
for (i in offsets2){
  nmasktest = thresh(blur_test, w=10, h=10, offset=i) # not blurred, lots of tiny, non count bits
  cellcount[counter] <- max(bwlabel(nmasktest))
  counter <- counter+1
}
graph <- data.frame(offsets2, cellcount)
plot(x= graph$offsets2,y=graph$cellcount, xlab = "test counts, varying theshold offset .01 to .03")
tail(graph)

pdf("test_counts_01_03.pdf")
dev.off()


######with opening, 

  counter <- 1
cellcount2 <- NA
for (i in offsets2){
  nmasktest = thresh(blur_test, w=10, h=10, offset=i) 
  opening_test <- opening(nmasktest, makeBrush(5, shape='disc'))
  cellcount2[counter] <- max(bwlabel(opening_test))
  counter <- counter+1
}

graph2 <- data.frame(offsets2, cellcount2)
plot(graph2, xlab = "blur_test counts, varying theshold offset with opening")









###################varying opening 

######with opening, 
size <- seq(1, 21, 2)
counter <- 1
cellcount2 <- NA
for (i in size){
  nmasktest = thresh(blur_test, w=10, h=10, offset=.005) 
  opening_test <- opening(nmasktest, makeBrush(i, shape='disc'))
  cellcount2[counter] <- max(bwlabel(opening_test))
  counter <- counter+1
}

graph_op <- data.frame(size, cellcount2)
plot(graph_op, xlab = "blur_test_thresh counts, varying opening brush size", xlim=range(size))


opening_test1 <- opening(nmasktest, makeBrush(1, shape='disc'))

opening_test3 <- opening(nmasktest, makeBrush(3, shape='disc'))

opening_test5 <- opening(nmasktest, makeBrush(5, shape='disc'))

opening_test7 <- opening(nmasktest, makeBrush(7, shape='disc'))
display(combine(opening_test1,opening_test3, opening_test5, opening_test7),all=T)

hist(c(1,2,2,2,2))

###need to get reperentative images and then write out
nmasktest005 = thresh(blur_test, w=10, h=10, offset=.005)
nmasktest005noblur = thresh(test, w=10, h=10, offset=.005)

opening_test <- opening(nmasktest005noblur, makeBrush(5, shape='disc'))
opening_test2 <- opening(opening_test, makeBrush(6, shape='disc'))

display(combine(test,nmasktest005noblur,opening_test,opening_test2), all=T)


nmasktest01 = thresh(blur_test, w=10, h=10, offset=.01)
nmasktest015 = thresh(blur_test, w=10, h=10, offset=.015)
nmasktest018 = thresh(blur_test, w=10, h=10, offset=.018)
nmasktest02 = thresh(blur_test, w=10, h=10, offset=.02)
nmasktest021 = thresh(blur_test, w=10, h=10, offset=.021)
nmasktest022 = thresh(blur_test, w=10, h=10, offset=.022)

display(combine(test,nmasktest005noblur,opening_test,nmasktest005,nmasktest01, nmasktest015, nmasktest018, nmasktest02, nmasktest021, nmasktest022),all=T)
nmasktest01 = thresh(blur_test, w=10, h=10, offset=.01)
display(combine(nmasktest018,nmasktest02,nmasktest022), all=T)

###########################################################################

writeImage(test, "test.jpeg", quality = 85)
writeImage(blur_test, "blur_test.jpeg", quality = 85)
nmasktest1 = thresh(blur_test, w=10, h=10, offset=0.005)
display(nmasktest1)
writeImage(nmasktest1, "threshold_005.jpeg", quality = 85)
opening_test1 <- opening(nmasktest1, makeBrush(5, shape='disc'))
display(opening_test1)
writeImage(opening_test1, "opening_5.jpeg", quality = 85)
opening_test1b <- opening(nmasktest1, makeBrush(10, shape='disc'))
writeImage(opening_test1b, "opening_10.jpeg", quality = 85)
  
nmasktest005noblur = thresh(test, w=10, h=10, offset=.005) ##no blur
writeImage(nmasktest005noblur, "noblur_threshold_005.jpeg", quality = 85)
display(nmasktest005noblur)

opening10_noblur005thresh <- opening(nmasktest005noblur, makeBrush(5, shape='disc'))## thersholding on unblurred
writeImage(opening10_noblur005thresh, "noblur_threshold_005_opening_5.jpeg", quality = 85)
display(combine(nmasktest005noblur,opening10_noblur005thresh), all=T)



####gblur !!!

gblur_test =gblur(test, sigma = 5) 

w = makeBrush(size = 5, shape = 'gaussian', sigma = 5)  # should match exactly the effects of the above gblur if gblur uses size = sigma
gblur_test2 =filter2(test, w) 

display(combine(test, blur_test,gblur_test,gblur_test2),all=T)  

display(combine(test,blur_test, blur_test1minusmean), all=T)


nmasktest_gblur <- thresh(gblur_test, w=10, h=10, offset=0.005)
nmasktest_gblur2 <- thresh(gblur_test2, w=10, h=10, offset=0.005)

display(combine(nmasktest_gblur,nmasktest_gblur2), all=T)




