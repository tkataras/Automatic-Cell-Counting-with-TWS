library("EBImage")
#install.packages("OpenImageR")
library("OpenImageR")

getwd()
#setwd("E:/Theo/from_deepika/map2_neun_40x/") #need to specify directory each time
setwd("E:/Deepika NeuN/map2 male cortex/")
all_files <- as.data.frame(unlist(strsplit(list.files(), "/t"))) #creats a 1 dim data frame variable with all file names as string
#some_files <- all_files[all_files == "Results1666s76F2true pos.cs."] # need to specify the defining characteristic of unprcessed image file names
# 
# #separating files by image name*********???????
# str(all_files)
# test <- strsplit(all_files, )


head(all_files)



neun_imgs <- grep("*_C1.tiff$",all_files[,1])
selected_img_files <- as.data.frame(all_files[neun_imgs,])

i = 1



paste("E:/Deepika NeuN/neun_only/", fname, sep = "")

file.copy(from = "E:/Deepika NeuN/map2 male cortex/HPC332 MAP2_NeuN_01042019_s45_C_F2.crop.L57_XY1546623305_Z0_T0_C1.tiff", to = "E:/Deepika NeuN/nuen_only_male_cortex/")

path <- paste("E:/Deepika NeuN/map2 male cortex/", fname, sep = "")
#path <- "E:/Deepika NeuN/map2 male cortex/HPC332 MAP2_NeuN_01042019_s45_C_F2.crop.L57_XY1546623305_Z0_T0_C1.tiff"
file.copy(from = path, to = "E:/Deepika NeuN/nuen_only_male_cortex/")

file.c

file.copy(from = "E:\Deepika NeuN\neun_only\HPC332 MAP2_NeuN_01042019_s45_C_F2.crop.L57_XY1546623305_Z0_T0_C1.tiff", to = "E:/Deepika NeuN/nuen_only_male_cortex/")


selected_img_files[2,]


setwd("E:/Deepika NeuN/map2 male cortex/")
all_files <- as.data.frame(unlist(strsplit(list.files(), "/t"))) #creats a 1 dim data frame variable with all file names as string
neun_imgs <- grep("*_C1.tiff$",all_files[,1])
selected_img_files <- as.data.frame(all_files[neun_imgs,])
i = 4

for(i in 1:dim(selected_img_files)[1]){
fname <- as.character(selected_img_files[i,])
path <- paste("E:/Deepika NeuN/map2 male cortex/", fname, sep = "")
file.copy(from = path, to = "E:/Deepika NeuN/nuen_only_male_cortex/")
}


