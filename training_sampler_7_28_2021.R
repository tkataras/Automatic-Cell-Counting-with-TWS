#BiocManager::install("EBImage")
library("EBImage")
#install.packages("OpenImageR")
library("OpenImageR")

getwd()
#setwd("E:/Theo/from_deepika/map2_neun_40x/") #need to specify directory each time
setwd("F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/working_images/new_val_train_etc/training_fem_Npt3/")


#i think you could probably get same results with dir() in retrospect
all_files <- as.data.frame(unlist(strsplit(list.files(), "/t"))) #creats a 1 dim data frame variable with all file names as string


#removing non image file names (accepts only "png" currently)
all_img_num <- grep("*.png$",all_files[,1])
all_img_files <- as.data.frame(all_files[all_img_num,])

# picking the relevant imgaes via text at beginning of name, currently selects all
row_num_images <- grep("",all_img_files[,1]) # need to specify the defining characteristic of unprocessed image file names


img_files <- as.data.frame(all_img_files[row_num_images,])

#df[grep("^Andy",rownames(df)),]

num_draws <- 10#use input desired number of images to be randomly selected with nonrepeating integers
random_ints <- sample.int(dim(img_files)[1],num_draws, replace = F) 


the_chosen <- as.data.frame(img_files[random_ints,])


  
### select one image at a time and save number of subsections

dim_subsection <- 240 #this will currently give 4 subsections

i = 5

for(i in 1:num_draws){
  rm(tiles)
  rm(datain)
  datain <- readImage(as.character(the_chosen[i,]))
  
  
  # #writeImage(datain, "testing1.tiff") testing checked out, *****NEED TO FIND WHAT TO INTRODUCE RANDOM OFFSET!!!!!!!!!********
  # #tile image
  tiles <- untile(datain, nim=c(floor(dim(datain)[1]/dim_subsection),
                                floor(dim(datain)[1]/dim_subsection)), lwd=0)
   dim(tiles)
  # str(tiles) 
 #writeImage(tiles[,,20], "testing1.tiff") #testing checked out again
  
  #THIS WILL NOW PULL 1 RANDOM 
  chosen_patch_num <- sample.int(dim(tiles)[3],1, replace = F)
  for (j in chosen_patch_num){
      current_name <- paste(as.character(the_chosen[i,]),"_",j,  ".png", sep = "")
      writeImage(tiles[,,j], current_name)
      
      }
  
  }








###BUilding my own sobel feldman filter from https://stackoverflow.com/questions/17815687/image-processing-implementing-sobel-filter
#https://blog.saush.com/2011/04/20/edge-detection-with-the-sobel-operator-in-ruby/
gx <- c(-1,-2,-1,0,0,0,1,2,1) 
Gxmat <- matrix(gx, nrow = 3, ncol= 3)

gy <- c(-1,0,1,-2,0,2, -1,0,1)
Gymat <- matrix(gy, nrow = 3, ncol= 3)



img <- readImage("https://www.r-project.org/logo/Rlogo.png")
display(img)
img <- myimg

# get horizontal and vertical edges
imgH <- filter2(img, Gxmat)
imgV <- filter2(img, Gymat)
display(imgV)


# combine edge pixel data to get overall edge data
edata <- sqrt(imageData(imgH)^2 + imageData(imgV)^2)


# transform edge data to image
imgE <- Image(edata, colormode = 2)
print(display(combine(img, imgH, imgV, imgE), method = "raster", all = T))
display(imgE)

##back to my stuff
myimg <- readImage("C:/Users/User/Desktop/Kaul_lab_work/Rohan/testing_imagej/test1.tiff")
display(myimg)





#### making a figure
exm1 <- readImage("./MAX_HPC338 Map2_NeuN all (CI).sld - HPC338 MAP2_NeuN_01032019_s45_C_F1.CI - C=1 z3.tif")
exm2 <- readImage("./MAX_HPC338 Map2_NeuN all (CI).sld - HPC338 MAP2_NeuN_01032019_s45_C_F2 - C=1 z11.tif")
exm3 <- readImage("./MAX_HPC332 Map2_NeuN all (CI).sld - HPC332 MAP2_NeuN_01042019_s75_C_F3 - C=1 z45.tif")
exm4 <- readImage("./MAX_HPC332 Map2_NeuN all (CI).sld - HPC332 MAP2_NeuN_01042019_s60_C_F2 - C=1 z18.tif")

exm_comb <- combine(exm1, exm2, exm3, exm4)
display(exm_comb, all =T)
display(c(exm1,exm2))
X11()
par(mfrow=c(2,2))

#grid.arrange(exm1, exm2, exm3, exm4 nrow=2)
display(exm1)

tile()
#, exm2, exm3, exm4)

MAX_HPC338 Map2_NeuN all (CI).sld - HPC338 MAP2_NeuN_01032019_s45_C_F1.CI - C=1 z3
MAX_HPC338 Map2_NeuN all (CI).sld - HPC338 MAP2_NeuN_01032019_s45_C_F2 - C=1 z11
MAX_HPC332 Map2_NeuN all (CI).sld - HPC332 MAP2_NeuN_01042019_s75_C_F3 - C=1 z45
MAX_HPC332 Map2_NeuN all (CI).sld - HPC332 MAP2_NeuN_01042019_s60_C_F2 - C=1 z18

