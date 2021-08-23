#BiocManager::install("EBImage")
library("EBImage")
#install.packages("OpenImageR") ##dotn know if one or both is neccesary yet
library("OpenImageR")


trim_names <- function(file_names, split = " - ", half = "front"){
  id1 <- file_names
  sid1 <- strsplit(id1, split)
  
  
  newsid1 <- NA
  for (i in 1:length(sid1)){
    if(half == "front") {newsid1 <- c(newsid1, tail(sid1[[i]],1))} 
    else if(half == "back") { newsid1 <- c(newsid1, head(sid1[[i]],1))} 
    else{print("half = front or back, please")
      break}
    
  }
  newsid1 <- newsid1[-1]
  
}
sep_slidebook <- function(x, sep = "-"){
  
  newsid1 <- x
  newsid1_s <- strsplit(newsid1, sep)
  
  
  #look at what elements you are working with
  head(newsid1_s,3)
  
  max_l <- length(newsid1_s[[1]])
  
  
  
  ##parseit takes a list of seperated relevent name elements from every image
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
get_match_id <- function(sub_inv,full_inv){
  match_id <- NA
  
  
  
  for (i in 1: length(sub_inv) ){
    pineapple <- grep(sub_inv[i],full_inv)
    if (sum(pineapple) == 0) {print("not found")} else match_id[i] <- pineapple
  }
  match_id <- match_id[complete.cases(match_id)]
}



###all the file locations
id_for_in_dir <-"F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/working_images/new_val_train_etc/new_new_train/Auto_thresh_output/" 
in_dir_list <- dir(id_for_in_dir)

file_list <- dir(paste(id_for_in_dir,"/", in_dir_list[1],"/", sep = ""))


id_for_out_dir <-"F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/working_images/new_val_train_etc/new_new_train/Auto_thresh_output_counted/"

out_dir_list <- dir(id_for_out_dir)




##getting images names, can pick any folder with all images in question to do this

id1 <- file_list

newsid1 <- trim_names(id1)


id1_df_sep <- sep_slidebook(x = newsid1)


id1_df_squish <- squish(input_df = id1_df_sep)


big_df <- cbind(newsid1, id1_df_squish,id1_df_sep) ##specify: original file names, info columns, squished ID
colnames(big_df) <- c("file_name", "img_ID", "a_num","S_num", "F_num")
big_df <- data.frame(big_df) #this df gives us access to varibles based on the images in several forms

##now need to gather and project all items with matching img_ID 
##need to start working in directory that holds all image folders

length(file_list)


u_img <- unique(big_df$img_ID)


length(u_img)

dim(big_df)



for (j in 1:length(in_dir_list)){
  #setwd(paste(id_for_dir,"/",nm,j, sep = ""))
  setwd(paste(id_for_in_dir,"/",in_dir_list[j], sep = ""))
  
  
  getwd()
  img_file_names <- list.files()
  
  out_loc <- out_dir_list[j]
  
  
  
  for (i in 1: length(u_img)){
    
    all_current_ID <- grep(u_img[i],big_df$img_ID)
    this_group <- img_file_names[all_current_ID]
    
    
    
    
    if (length(this_group) == 2){
      datain1 <- readImage(as.character(this_group[1]))
      datain2 <- readImage(as.character(this_group[2]))
      
      projected <- datain1 + datain2
      projected[projected >255] = 255
      
      
      
      
    } else if (length(this_group) == 3){
      datain1 <- readImage(as.character(this_group[1]))
      datain2 <- readImage(as.character(this_group[2]))
      datain3 <- readImage(as.character(this_group[3]))
      
      projected <- datain1 + datain2 +datain3
      projected[projected >255] = 255
    }
    
    # ##it turns out names get very long when working with image processing steps and you cant save a file with more than 97 charcters in the name
    # fn = this_group[1]
    # if (length(unlist(strsplit(this_group[1], split = ""))) >= 93){
    #   fn <- paste(unlist(strsplit(this_group[1], split = ""))[1:93], sep = "", collapse = "")
    #   
    #   #cant have 2 . in a row before png
    #   if (tail(unlist(strsplit(fn,split = "")),1) == "."){
    #     fn <- paste(unlist(strsplit(fn,split = ""))[1:length(unlist(strsplit(fn,split = ""))) - 1], sep = "", collapse = "")
    #   }
    # }
    # 
    
    file_out_loc <- paste(paste(id_for_out_dir,out_dir_list[j], sep = ""),"/",this_group[1], sep = "")
    writeImage(projected,file_out_loc)
    
    # }else (print("we have a problem, ", as.character(this_group[1])," had neither 2 nor 3 images"))
    # 
    
  }
}



