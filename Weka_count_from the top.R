##trainng has been done. all val images in 1 folder, all classifiers in another


#Reqs
#BiocManager::install("EBImage")
library("EBImage")


#install.packages("OpenImageR") ##didnt load yet, dont know if use
library("OpenImageR")


##making folders ####

##set wd to where you want folders, later this should be like THE ORIGIN
getwd()
setwd("F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/working_images/new_val_train_etc/test/test_class_project/")

#getting the number of needed folder from # classifier.model files in folder with ONLY classifier.model files
n= length(dir("F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/working_images/new_val_train_etc/test/test_class/")) 
nm = "class"
nm2= "_projected"
for (i in 1:n){
  dir.create(paste(getwd(),"/",nm,i,nm2,sep = ""))
}



###now we need to apply each classifier to all val images and output segmentations in all class folders
## we do this with a BeanShell script interfacting with Weka without GUI
##F:\Theo\iba_7_2020_autocount\Hina_IFNBKO_pair\working_images\new_val_train_etc\test\BS_class_test.bsh

###need to threshold Weka imge outputs for this next step!!!

#now need to process the multi plane validation images
#will do this in R, but will need to regularize image names to project pairs and trios correctly.
#if you do not need this sort of image processing, this step in not neccessary

##getting images names

inputdir_all1 <-"F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/working_images/new_val_train_etc/validation/" 
inputdir_all <- dir(inputdir_all1)
id1 <- inputdir_all

trim_names <- function(file_names){
  id1 <- file_names
  sid1 <- strsplit(id1, " - ")
  
  
  newsid1 <- NA
  for (i in 1:length(sid1)){
    newsid1 <- c(newsid1, tail(sid1[[i]],1))
  }
  newsid1 <- newsid1[-1]
}
sep_slidebook <- function(x, sep = "-"){
  
  newsid1 <- x
  newsid1_s <- strsplit(newsid1, sep)
  
  
  #look at what elements you are working with
  head(newsid1_s,3)
  
  max_l <- length(newsid1_s[[1]])
  
  
  
  ##parseit takes a list of seperated relevent nam eelements from every image
  parseit <-function(x,object_num){
    newsid1_anum <- NA
    for (i in 1:length(x)){
      newsid1_anum <- c(newsid1_anum, x[[i]][object_num])
    }
    newsid1_anum <- newsid1_anum[-1]
    
  }
  ###these are what you need to adjust for different names of images!!!!####
  newsid1_anum <- parseit(x = newsid1_s, object_num = 2)
  newsid1_snum <- parseit(x = newsid1_s, object_num = 3)
  newsid1_fnum <- parseit(x = newsid1_s, object_num = max_l)
  
  fnumsid1_s <- strsplit(newsid1_fnum, "") #### sometimes another seperation step is required
  
  
  
  newsid1_fnum1 <- parseit(x = fnumsid1_s, object_num = 1)
  newsid1_fnum2 <- parseit(x = fnumsid1_s, object_num = 2)
  newsid1_fnum3 <- paste(newsid1_fnum1,newsid1_fnum2, sep = "") # for clarity, seperated objects can be recombined in order with paste()
  
  
  
  ####making the data frames-----------
  
  
  id1_df <- cbind(newsid1_anum, newsid1_snum, newsid1_fnum3)
  head(id1_df)
  
  
  
  
  
  #return(id1_df_squish)
  return(id1_df)
}
squish <- function(input_df){
  
  id1_df_squish <- NA
  for (i in 1:dim(input_df)[1]) {
    id1_df_squish[i] <- paste0(input_df[i,], sep = "_", collapse = "")  
  }
  return(id1_df_squish)
}##simple function to combine rows of the df with info


newsid1 <- trim_names(id1)


id1_df_sep <- sep_slidebook(x = newsid1)


id1_df_squish <- squish(input_df = id1_df_sep)


big_df <- cbind(inputdir_all, id1_df_squish,id1_df_sep) ##specify: original file names, info columns, squished ID
colnames(big_df) <- c("file_name", "img_ID", "a_num","S_num", "F_num")
big_df <- data.frame(big_df) #this df gives us access to varibles based on the images in several packages

##now need to gather and project all items with matching img_ID

##need to be working in images directory
id_for_dir <- "F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/working_images/new_val_train_etc/test/classes/"
class_list <- dir(id_for_dir)
u_img <- unique(big_df$img_ID)

for (j in 1:length(class_list)){
  setwd(paste(id_for_dir,class_list[j], sep = ""))



for (i in 1: length(u_img)){
  all_current_ID <- grep(u_img[i],big_df$img_ID)
  this_group <- big_df$file_name[all_current_ID]
  
  
  
  
  
  if (length(this_group) == 2){
    datain1 <- readImage(as.character(this_group[1]))
    datain2 <- readImage(as.character(this_group[2]))
    
    projected <- datain1 + datain2
    projected[projected <255] = 255
    
    file_out_loc <- paste("F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/working_images/new_val_train_etc/test/test_class_project/class",j,"_projected/",this_group[1], sep = "")
    writeImage(projected,file_out_loc)
    
  } else if (length(this_group) == 3){
    datain1 <- readImage(as.character(this_group[1]))
    datain2 <- readImage(as.character(this_group[2]))
    datain3 <- readImage(as.character(this_group[3]))
    
    projected <- datain1 + datain2 +datain3
    projected[projected <255] = 255
    file_out_loc <- paste("F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/working_images/new_val_train_etc/test/test_class_project/class",j,"_projected/",this_group[1], sep = "")
    writeImage(projected,file_out_loc)
    
    
  }else (print("we have a problem, this group had neither 2 nor 3 images"))
  
  
}
}




##############################
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

