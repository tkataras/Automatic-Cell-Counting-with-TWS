library("EBImage")
#install.packages("OpenImageR")
library("OpenImageR")

getwd()
setwd("D:/LAV 6M Calbindin Parvalbumin/cortex calb") #need to specify directory each time
all_files <- as.data.frame(unlist(strsplit(list.files(), "/t"))) #creats a 1 dim data frame variable with all file names as string
#some_files <- all_files[all_files == "Results1666s76F2true pos.cs."] # need to specify the defining characteristic of unprcessed image file names


#removing non image file names (accepts only "tif" currently)
all_img_num <- grep("*.tif$",all_files[,1])
all_img_files <- as.data.frame(all_files[all_img_num,])

# picking the relevant imgaes via text at beginning of name
row_num_images <- grep("^LAV",all_img_files[,1]) # need to specify the defining characteristic of unprcessed image file names


img_files <- as.data.frame(all_img_files[row_num_images,])

#df[grep("^Andy",rownames(df)),]

num_draws <- 16#use input desired number of images to be randomly selected with nonrepeating integers
random_ints <- sample.int(dim(img_files)[1],num_draws, replace = F) 


the_chosen <- as.data.frame(img_files[random_ints,])
  
  
### select one image at a time and save number of subsections
num_subsection <- 5
dim_subsection <- 200 #this will currently give 80 subsections

for(i in 1:num_draws){
  rm(tiles)
  rm(datain)
  datain <- readImage(as.character(the_chosen[i,]))
  
  
  # #writeImage(datain, "testing1.tiff") testing checked out, *****NEED TO FIND WHAT TO INTRODUCE RANDOM OFFSET!!!!!!!!!********
  # #tile image
  tiles <- untile(datain, nim=c(floor(dim(datain)[1]/dim_subsection),floor(dim(datain)[1]/dim_subsection)), lwd=0)
  # dim(tiles)
  # str(tiles) 
 #writeImage(tiles[,,20], "testing1.tiff") #testing checked out again
  chosen_patch_num <- sample.int(dim(tiles)[3],num_subsection, replace = F)
  for (j in chosen_patch_num){
      current_name <- paste(as.character(the_chosen[i,]),"_",j,  ".tiff", sep = "")
      writeImage(tiles[,,j], current_name)
      #rm(tiles)
      }
  
  }








