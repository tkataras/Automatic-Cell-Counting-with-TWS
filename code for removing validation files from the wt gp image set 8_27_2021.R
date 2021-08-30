
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
get_match_id <- function(sub_inv,full_inv){
  match_id <- NA
  
  
  
  for (i in 1: length(sub_inv) ){
    pineapple <- grep(sub_inv[i],full_inv)
    if (sum(pineapple) == 0) {print("not found")} else match_id[i] <- pineapple
  }
  match_id <- match_id[complete.cases(match_id)]
}



val_dir <- dir("F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/working_images/new_val_train_etc/new_new_train/validation_roi/")
#val_dir <- dir("F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/working_images/new_val_train_etc/new_new_train/validation/")


val_dir


val_sep <- sep_slidebook(val_dir)
val_squish  <- squish(val_sep)


#full_dir <- dir("F:/Theo/full_backup_3_23_2021/Kaul_lab_work/bin_general/Data/Full_dataset/Processed_Images/")
full_dir <- dir("F:/Theo/full_backup_3_23_2021/Kaul_lab_work/bin_general/Data/Full_dataset/Weka_Output/")

full_sep <- sep_slidebook(full_dir)
full_squish <- squish(full_sep)



get_match_id_2 <- function(sub_inv,full_inv){
  

###this is an updated loop to get match IDs in cases where there are multiple objects in the full list that match the squish info in the short list
match_id <- NA
#sub_inv <- val_squish
#full_inv <- full_squish

for (i in 1: length(sub_inv) ){
  pineapple <- grep(sub_inv[i],full_inv)
  if (sum(pineapple) == 0) {print("not found")} else match_id <- c(match_id,pineapple)
}
match_id <- match_id[complete.cases(match_id)]
}

length(match_id)
length(full_dir)



for (j in match_id){
  file.remove(full_dir[match_id])
}




full_dir2 <- dir("F:/Theo/full_backup_3_23_2021/Kaul_lab_work/bin_general/Data/Full_dataset/Processed_Images/")
full2_sep <- sep_slidebook(full_dir2)
full2_squish <- squish(full2_sep)


length(full_dir2)



#####moving on only the images from processed images 

fuller_dir <- dir("F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/working_images/new_val_train_etc/new_new_train/full_data/weka output/class19/")
length(fuller_dir)

fuller_sep <- sep_slidebook(fuller_dir)
fuller_squish <- squish(fuller_sep)

length(unique(full2_squish))

move_on <- get_match_id_2(unique(full2_squish),fuller_squish)

length(move_on)
i = 1
for (i in move_on){
  file.copy(fuller_dir[move_on], "F:/Theo/full_backup_3_23_2021/Kaul_lab_work/bin_general/Data/Full_dataset/Weka_Output/class19/")
}



####now moving over the thresholded images
fuller_dir <- dir("F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/working_images/new_val_train_etc/new_new_train/full_data/thresh/class19_thresh/")
length(fuller_dir)

fuller_sep <- sep_slidebook(fuller_dir)
fuller_squish <- squish(fuller_sep)

length(unique(full2_squish))

move_on <- get_match_id_2(unique(full2_squish),fuller_squish)

length(move_on)
i = 1
for (i in move_on){
  file.copy(fuller_dir[move_on], "F:/Theo/full_backup_3_23_2021/Kaul_lab_work/bin_general/Data/Full_dataset/Weka_Output_Thresholded/class19/")
}




##now doing the projected, will be doing this by removing the val images, since already wt gp restricted

proj_dir <- dir("F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/working_images/new_val_train_etc/new_new_train/full_data/projected_wt_gp/class19/")
proj_sep <- sep_slidebook(proj_dir)
proj_squish <- squish(proj_sep)

remove <- get_match_id_2(val_squish,proj_squish)

setwd("F:/Theo/full_backup_3_23_2021/Kaul_lab_work/bin_general/Data/Full_dataset/Weka_Output_Projected/class19/")
getwd()
for (j in match_id){
  file.remove(proj_dir[remove])
}


####doing this for the counted images, then need to rerun the count eventually??/

count_dir <- dir("F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/working_images/new_val_train_etc/new_new_train/full_data/counted/class19/")
count_sep <- sep_slidebook(count_dir)
count_squish <- squish(count_sep)





