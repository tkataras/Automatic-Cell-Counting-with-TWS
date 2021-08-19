
test1 <- readImage(("C:/Users/User/Desktop/Kaul_lab_work/Rohan/LAV2378-s75-051116-Iba-PSD95-10x-cortex-F1_XY1525225408_Z0_T0_C1test.tiff"))
test2 <- readImage(("C:/Users/User/Desktop/Kaul_lab_work/Rohan/LAV2378-s75-051116-Iba-PSD95-10x-cortex-F2_XY1525225431_Z0_T0_C1test.tiff"))
test3 <- readImage(("C:/Users/User/Desktop/Kaul_lab_work/Rohan/LAV2378-s75-051116-Iba-PSD95-10x-cortex-F3_XY1525225462_Z0_T0_C1test.tiff"))

test4 <- readImage(("C:/Users/User/Desktop/Kaul_lab_work/Rohan/LAV2493-s75-051116-Iba-PSD95-10x-cortex-F1_XY1525224050_Z0_T0_C1test6_20.tiff"))

#test5 is PROJECTION form Deepika
test5 <- readImage(("C:/Users/User/Desktop/Kaul_lab_work/Deepika_z_projection_6_28/HPC360-s59-Iba1-05232018-10X-C-F1_SS1um_1280X1280.NearN.Project_Maximum_Z.tif"))

test5lap <- readImage(("C:/Users/User/Desktop/Kaul_lab_work/Deepika_z_projection_6_28/test5.tiff Laplacian4.png"))
test5lap2 <- readImage(("C:/Users/User/Desktop/Kaul_lab_work/Deepika_z_projection_6_28/test5.tiff Laplacian7_12.tif"))


test5exp <- test5 - test5lap
display(combine(test5, test5lap, test5exp), all=T)

test4nrm <- normalize(test4)
display(combine(test4, test4nrm), all=T)

writeImage(imgcol, "sample.jpeg", quality = 85)
hist(test4nrm)


display(combine(test5lap2), all=T)
test5lab2_neg = max(test5lap2) - test5lap2
display(combine(test5lap2, test5lab2_neg), all=T)
hist(test5lab2_neg)

threshitOP(test5lab2_neg, start_offset = 0.05, end_offset = 0.6, interval = .02, title = "testing laplacian with op")

nmasktest = thresh(test5lab2_neg, w=14, h=14, offset=0.2) 
opening_test <- opening(nmasktest, makeBrush(3, shape='disc'))#the opening step, 3 = pixel radius? of mask??
cellcountt5 <- max(bwlabel(opening_test))
cellcountt5

display(combine(test5,nmasktest,test5lab2_neg,opening_test), all=T)

dim(test5lab2_neg)

#test 5 blur -> hessian
test5bh <- readImage(("C:/Users/User/Desktop/Kaul_lab_work/Deepika_z_projection_6_28/test5.tiff largest Hessian eigenvalues2.tif"))
display(test5bh)
test5bh_neg = max(test5bh) - test5bh
display(test5bh_neg)
threshitOP(test5bh_neg, start_offset = 0.1, end_offset = 0.25, interval = .005, title = "testing blur -> hess with op")




#testing opening
opening_test2 <- opening(nmasktest>, makeBrush(3, shape='disc'))#added an opening step, 3 = pixel radius of mask??






fd### cropping as paint is unsitable and imageJ has stopped cropping the selected areas for some reason
dim(test1)
test1crop <- test1[150:1280,1:1280]
display(test1crop)
test1 <- test1crop
display(test1)
#counted 177 microglia on test1 cropped


test2crop <- test2[150:1280,1:1280]
display(combine(test2crop ), all = T)
test2 <- test2crop

test3crop <- test3[120:1280,1:1280]
display(combine(test3crop ), all = T)
  test3 <- test3crop
  
test4crop <- test4[120:1280,1:1280]
  display(combine(test4crop ), all = T)
  test4 <- test4crop

  
#test 5 WORKING WITH PROJECTION, found 3 layers, all EXACTLY the same image
test5L1 <- test5[1:640,1:640, 1]
test5L2 <- test5[1:640,1:640, 2]
test5L3 <- test5[1:640,1:640, 3]
display(combine(test5L1, test5L2, test5L3), all=T)

test5crop <- test5[40:640,1:640, 1]
  display(combine(test5crop ), all = T)
  test5 <- test5crop
  
max(test5)
min(test5)
hist(test5)
otsu(test5) 



####calbinding with biovoxxel background subtraction
test6sb <- readImage(("C:/Users/User/Desktop/Kaul_lab_work/calbindin_7_18/LAVMeth2830-s74-Calbindin-Parvalbumin-101613-cortex-F1-1_sub_bkg.tif"))
display(test6sb)
threshitOP(test6sb, start_offset = 0.05, end_offset = 0.25, interval = .005, title = "testing calbindin with biovoxx")

nmasktest6 = thresh(test6sb, w=10, h=10, offset=0.075)
opening_test6 <- opening(nmasktest6, makeBrush(3, shape='disc'))
display(combine(test6sb, nmasktest6, opening_test6), all=T)
cellcount_test6 <- max(bwlabel(opening_test6))
print(cellcount_test6)


####writing out cropped images
writeImage(test1, "test1.tiff") #count 177 rohan = 215
writeImage(test2, "test2.tiff") #count 153 rohan = 224
writeImage(test3, "test3.tiff") #count 113?? microglia are less distinct rohan count 209???
writeImage(test4, "test4.tiff") # rohan = 179
writeImage(test5, "test5.tiff") # my count = 176, 197(after blur, less selective)

  
  
  
source("C:/Users/User/Desktop/Kaul_lab_work/work_6_19.R")
threshit(test3, start_offset = .08, end_offset = .2, interval = .005, title = "462 threshold offset")

hist(test3)



source("C:/Users/User/Desktop/Kaul_lab_work/threshitOP.R")

nmasktest = thresh(test1, w=10, h=10, offset=0.01)
opening_test <- opening(nmasktest, makeBrush(5, shape='disc'))
opening_test1 <- opening(nmasktest, makeBrush(1, shape='disc'))
opening_test3 <- opening(nmasktest, makeBrush(3, shape='disc'))



display(combine(test1, nmasktest, opening_test, opening_test1, opening_test3), all=T)

threshitOP(test1, start_offset = 0, end_offset = 1, interval = .05, title = "opening_1 threshold offset")

threshitOP(test4, start_offset = .02, end_offset = .2, interval = .005, title = "test4 OP_1 threshold offset .02-.2")

threshit(test4, start_offset = .08, end_offset = .2, interval = .005, title = "test4 threshold offset .08-.2")



source("C:/Users/User/Desktop/Kaul_lab_work/openit.R")
openit(test1, start_size = 1, end_size = 11, interval = 2, title = "thesh_.01 opening range")


library(ggplot2)
install.packages("ggplot2", dependencies = TRUE)
 length(x)
x=graph2[3:32,1]
y=graph2[3:32,2]

qplot(y= graph2[,2], x = graph2[,1],data = graph2, geom="point")
plot(graph1)

length((graph2[3:32,1]))


graph12 <- cbind(graph1, graph2$cellcount)
dim(graph12)
##line plot
#p <- ggplot(graph1, aes(Petal.Length, Petal.Width, group=Species, color=Species)) + geom_line() 
p <- ggplot(graph12) + geom_line() 
print(p)
# ggplot(test_data, aes(date)) + 
#   geom_line(aes(y = var0, colour = "var0")) + 
#   geom_line(aes(y = var1, colour = "var1"))

p <- ggplot(graph12, aes(graph12$offsets) + geom_line(y = graph12$cellcount) + geom_line(y = graph12$`graph2$cellcount`))

# p = ggplot() + 
#   geom_line(data = prescription1, aes(x = dates, y = Difference), color = "blue") +
#   geom_line(data = prescription2, aes(x = dates, y = Difference), color = "red")


library("EBImage")
library("OpenImageR")


#### code below compares the counts of one thresh range with and without opening ##################################################
datain <- test1
start_offset <- .01
end_offset <- .2
interval <- .005
  
  
  
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
graph123 <- cbind(graph1, graph2$cellcount, graph3$cellcount)# shows that blurring reduces the ridiculously high counts atound 0.04 thresholds
#names(graph123)
#line[1:length(offsets)] <- 113# hand count of cropped test1 gave 177 microglia




p2 = ggplot() + 
  geom_line(data = graph123, aes(x = graph123$offsets, y = graph123$cellcount), color = "blue") +
  geom_line(data = graph123, aes(x = graph123$offsets, y = graph123$`graph2$cellcount`), color = "red") +
  geom_line(data = graph123, aes(x = graph123$offsets, y = graph123$`graph3$cellcount`), color = "green") +
  geom_hline(yintercept = 177 ) +
  geom_vline(xintercept=otsu(test1)) +
  ylim(low=1, high= 500) +
  labs(title = "blu = thresh,red = blur, grn = open blk = 177 hand count")

print(p2)
#hist(c(1,2,2,2,2))

####testing image manipulating 

display(test1)
display(test4)

###negative
test1_neg = max(test1) - test1
display(combine(test1, test1_neg), all=T)
max(test1_neg)
test1_neg_rev <- 1 - test1_neg#inverting negative
display(combine(test1, test1_neg,test1_neg_rev ), all=T)


#testing neg and neg rev
counter <- 1
cellcount <- NA
offsets <- c(seq(start_offset,end_offset,interval))
for (i in offsets){
  nmasktest = thresh(test1_neg, w=10, h=10, offset=i) 
  cellcount[counter] <- max(bwlabel(nmasktest))
  counter <- counter+1
  
}
graph1 <- data.frame(offsets, cellcount) #just thresholding


#looking at what thresholded neg looks like
test1_neg_th05 = thresh(test1_neg, w=10, h=10, offset=.05)
display(combine(test1_neg, test1_neg_th05), all=T)#doesnt work, shouldnt have been suprised

#looking at REVERSED Neg
test1_neg_rev_th05 = thresh(test1_neg_rev, w=10, h=10, offset=.05)
test1_th05 = thresh(test1, w=10, h=10, offset=.05)

display(combine(test1_neg, test1_neg_rev, test1_neg_rev_th05, test1_th05), all=T)#the last 2 are origional and rev_neg thresh. seem idential
display(combine(test1,test1_neg_rev,test1_th05,test1_neg_rev_th05), all= T)

## neg was a bust, testing reducing by avg

test1_ma <- test1 - mean(test1)
test1_ma_th05 <- thresh(test1_ma, w=10, h=10, offset=.05)
display(combine(test1_ma, test1_ma_th05), all=T)
display(combine(test1, test1_ma, test1_th05, test1_ma_th05), all=T)




###looking at neg of test3
test3_neg <- max(test3) - test3
test3_mm <- test3 - mean(test3)#minus mean
test3_mm_neg <- max(test3_mm) - test3_mm
 display(combine(test3, test3_neg, test3_mm, test3_mm_neg), all=T)

 
 
 
library(EBimage)
 
 
 
otsu(test1)
test1_t2 <- test1*2
hist(test1)
hist(test1_t2)

test1_ot <- test1 > (otsu(test1) + .03)
display(combine(test1,test1_t2,test1_ot ),all=T)
test1

w = makeBrush(size = 11, shape = 'gaussian', sigma = 3)  # makes the blurring brush
test1_bl = filter2(test1, w) # apply the blurring filter
otsu(test1_bl)# blurrin reduces otsu's by .0039

test1_bl_ot <- test1_bl > (otsu(test1_bl)+.03)

display(combine(test1,test1_bl,test1_bl_ot, test1_ot ),all=T)




source("C:/Users/User/Desktop/Kaul_lab_work/showme.R")

showme(datain = test3, start_offset=.01, end_offset=.2, interval = .005, count = 153)
hist(test3)
#TO DO:using otsus cutoff with thresh, which has varialbe brush size

display(test3)
t3 <- test3 -mean(test3)
display(t3)
t3 <- t3*2
t3_th <- thresh(t3, w=150, h=150, offset=.05)
display(combine(t3, t3_th), all=T)




####test5 work

showme(datain = test5, start_offset=.01, end_offset=.5, interval = .05, count = 0)

nmasktest5a = thresh(test5, w=10, h=10, offset=otsu(test5)+.02) 
display(nmasktest5a)


nmasktest5b = thresh(datain2, w=10, h=10, offset=otsu(test5)+.02) 
display(nmasktest5b)

opening_test5 <- opening(nmasktest5a, makeBrush(3, shape='disc'))
display(combine(test5, opening_test5),all=T)

cellcounttest5op <- max(bwlabel(opening_test5))
bwtest <- bwlabel(opening_test5)
display(bwtest)
