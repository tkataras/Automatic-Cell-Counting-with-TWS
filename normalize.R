
#norm 1 file
library("EBImage")
library("OpenImageR")

img1 <- readImage(("C:/Users/User/Desktop/Kaul_lab_work/img analysis summary/1665s76img1subtract background 15.jpg"))
dim(img1)
mx <- max(img1)
mn <- min(img1)

img1_nrm <- normalize(img1, separate = T, ft= c(0,1), inputRange = c(mn, mx))
display(img1_nrm)
head(img1_nrm)
writeImage(img1_nrm, "C:/Users/User/Desktop/Kaul_lab_work/img analysis summary/1665s76img1subtract background 15norm.jpg")
