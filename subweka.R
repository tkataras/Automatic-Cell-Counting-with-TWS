library("EBImage")
library("OpenImageR")

#test <- readImage(("C:/Users/User/Desktop/Kaul_lab_work/6_6/HPC 382-s74-Iba1_SYN-04062018-C-10X F3b_XY1523048841_Z0_T0_C174F3b.tiff"))
test <- readImage(("C:/Users/User/Desktop/Kaul_lab_work/6_6/HPC360-s59-Iba1-05232018-10X-C-F1a 1280X1280_XY1527116341_Z0_T0_C1.tiff"))
test
#setwd('E:/Deepika NeuN/subtraction_folder/')
setwd("D:/Images HMC3 daniel/subtract/")
list[list == list[1]]

list2 <- strsplit(list, split = " - ")
list2[[1]][2]

list2[list2[[1]][2] == list2[[1:length(list)]][2]]


search =list2[[1]][2]



for (i in 1:length(list)){


  
tapp  }

list[[1]]
blargh <- readImage(list[[6]])
display(img3e)



i = 1
setwd('E:/Theo/from_indira/subtract/')
setwd('E:/Deepika NeuN/subtraction_folder/')
getwd()

#actual code down here


list <- list.files()
half_length <- ceiling((length(list))/2)
for (i in 1:half_length){
img1 <- readImage(list[[i]])
#img1 = max(img1) - img1

img2 <- readImage(list[[i+half_length]])
#img2 = max(img2) - img2

#img3<- img2 - img1
img3<-  img1[,,1] - img2 


str(img3)
#img3[img3 << 0] = 0
name = as.character(list[[i]])
writeImage(img3,paste(name,"subtracted",".tiff"))
}




