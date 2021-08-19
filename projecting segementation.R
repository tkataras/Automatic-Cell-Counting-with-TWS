###### projecting segmentations
library("EBImage")
library("OpenImageR")


setwd("E:/For Jeff/Microglia_Cropped/")

getwd()

list <- list.files()

#for testing
#list <- list[1:10]
split_list <- strsplit(list,split = "-")

#split_list[[3]][3]


znames <- NA
for (i in 1:length(split_list)) {
  znames[i] <- split_list[[i]][1]
  #zpos[i] <- as.numeric(paste(strsplit(znames[i], split="")[[1]][6], strsplit(znames[i], split="")[[1]][7], sep = ""))
}

znames2 <- NA
for (i in 1:length(split_list)) {
  znames2[i] <- split_list[[i]][2]
  #zpos[i] <- as.numeric(paste(strsplit(znames[i], split="")[[1]][6], strsplit(znames[i], split="")[[1]][7], sep = ""))
}

znames3 <- NA
for (i in 1:length(split_list)) {
  znames3[i] <- split_list[[i]][7]
  #zpos[i] <- as.numeric(paste(strsplit(znames[i], split="")[[1]][6], strsplit(znames[i], split="")[[1]][7], sep = ""))
}
znames3 <- substr(znames3, start = 1, stop = 3)


znames4 <- substr(znames3, start = 1, stop = 2)
znames5 <- substr(znames3, start = 3, stop = 3)

dft <- data.frame(cbind(znames, znames2, znames3, znames4, znames5))
dft <- na.omit(dft)




#levels(dft$znames)
# 
# test <- NA
# i = 1
# j = 1
# k = 2



for(i in 1:length(levels(dft$znames))){
for(j in 1:length(levels(dft$znames2))){
for(k in 1:length(levels(dft$znames4))){
dft2 <- dft[dft$znames == levels(dft$znames)[i] & dft$znames2 == levels(dft$znames2)[j] & dft$znames4 ==  levels(dft$znames4)[k],]


if(dim(dft2)[1] < 1){
 #do nothing, want to go back to top 
}
else {
#rownames(dft2)  
img1 <- readImage(paste("./", list[as.numeric(rownames(dft2)[1])],sep = ""))
img1 = max(img1) - img1

img2 <- readImage(paste("./", list[as.numeric(rownames(dft2)[2])],sep = ""))
img2 = max(img2) - img2

img3 <- img1 + img2
display(img3)

writeImage(img3, paste("projected", list[as.numeric(rownames(dft2)[1])], sep = ""))

}
}}}



