##getting images names, can pick any folder with all images in question to do this

inputdir_all1 <-"F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/working_images/new_val_train_etc/new_new_train/validation/" 
inputdir_all <- dir(inputdir_all1)
id1 <- inputdir_all

newsid1 <- trim_names(id1)


id1_df_sep <- sep_slidebook(x = newsid1)


id1_df_squish <- squish(input_df = id1_df_sep)


big_df <- cbind(inputdir_all, id1_df_squish,id1_df_sep) ##specify: original file names, info columns, squished ID
colnames(big_df) <- c("file_name", "img_ID", "a_num","S_num", "F_num")
big_df <- data.frame(big_df) #this df gives us access to varibles based on the images in several forms

##now need to gather and project all items with matching img_ID 
##need to be working in images directory???****
id_for_dir <- paste(ORIGIN, "/Weka_output_thresh/", sep = "")



length(class_list)


u_img <- unique(big_df$img_ID)


length(u_img)

dim(big_df)



for (j in nums){
  setwd(paste(id_for_dir,"/",nm,j, sep = ""))
  getwd()
  img_file_names <- list.files()
  
  out_loc <- OUTPUT_project
  
  
  
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
    
    ##it turns out names get very long when working with image processing steps and you cant save a file with more than 97 charcters in the name
    fn = this_group[1]
    if (length(unlist(strsplit(this_group[1], split = ""))) >= 93){
      fn <- paste(unlist(strsplit(this_group[1], split = ""))[1:93], sep = "", collapse = "")
      
      #cant have 2 . in a row before png
      if (tail(unlist(strsplit(fn,split = "")),1) == "."){
        fn <- paste(unlist(strsplit(fn,split = ""))[1:length(unlist(strsplit(fn,split = ""))) - 1], sep = "", collapse = "")
      }
    }
    
    
    file_out_loc <- paste(paste(out_loc,nm,j, sep = ""),"/",fn,".png", sep = "")
    writeImage(projected,file_out_loc)
    
    # }else (print("we have a problem, ", as.character(this_group[1])," had neither 2 nor 3 images"))
    # 
    
  }
}



