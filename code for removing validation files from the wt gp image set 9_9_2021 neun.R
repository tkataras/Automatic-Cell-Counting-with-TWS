
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

remove <- get_match_id_2(val_squish,count_squish)

setwd("F:/Theo/full_backup_3_23_2021/Kaul_lab_work/bin_general/Data/Full_dataset/Weka_Output_Counted/class19/")
getwd()
for (j in match_id){
  file.remove(count_dir[remove])
}

####moving over only the NON validation hand counts
roi_dir <- dir("F:/Theo/full_backup_3_23_2021/Kaul_lab_work/bin_general/Data/Full_dataset/Hand_ROI/")
roi_sep <- sep_slidebook(roi_dir)
roi_squish <- squish(roi_sep)

rem <- get_match_id(val_squish,roi_squish)

for (j in match_id){
  file.remove(roi_dir[rem])
}





####working on the Neun set, taking just wt and gp images
trim_names <- function(file_names, split = " - ", half = "front"){
  id1 <- file_names
  sid1 <- strsplit(id1, split)
  
  
  newsid1 <- NA
  for (i in 1:length(sid1)){
    if(half == "front") {newsid1 <- c(newsid1, head(sid1[[i]],1))} 
    else if(half == "back") { newsid1 <- c(newsid1, tail(sid1[[i]],1))} 
    else{print("half = front or back, please")
      break}
    
  }
  newsid1 <- newsid1[-1]
  
}



neun_dir <- dir("F:/Deepika NeuN/nuen_only_male_cortex/")
head(neun_dir)
neun_trim <- trim_names(neun_dir, split = ".crop.", half = "front")
head(neun_trim)




##having to do new sep slideboook for new naming convention

sep_slidebook <- function(x, sep = c(  "\\D+") ){
  
  newsid1 <- x
  newsid1_s <- strsplit(newsid1, sep)
  
  
  #look at what elements you are working with
  head(newsid1_s,3)
  head(newsid1,3)
  
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
  newsid1_snum <- parseit(x = newsid1_s, object_num = 5)
  newsid1_fnum <- parseit(x = newsid1_s, object_num = max_l)
  # 
  # fnumsid1_s <- strsplit(newsid1_fnum, "") #### sometimes another seperation step is required
  # 
  # 
  # 
  # newsid1_fnum1 <- parseit(x = fnumsid1_s, object_num = 1)
  # newsid1_fnum2 <- parseit(x = fnumsid1_s, object_num = 2)
  # newsid1_fnum3 <- paste(newsid1_fnum1,newsid1_fnum2, sep = "") # for clarity, seperated objects can be recombined in order with paste()
  # 
  # 
  
  ####making the data frames-----------
  
  
  id1_df <- cbind(newsid1_anum, newsid1_snum, newsid1_fnum3)
  head(id1_df)
  
  
  
  
  
  #return(id1_df_squish)
  return(id1_df)
}



neun_sep <- sep_slidebook(neun_trim)
head(neun_sep)
#########
WT <- c("332","345","357")
GP <- c("343","344","348")


 #geno here, trying not to bias self, havnet hand counted yet
########
WT

sum(newsid1_anum == WT)
sum(newsid1_anum == WT[1] | newsid1_anum == WT[2] | newsid1_anum == WT[3])

sum(newsid1_anum == GP)
sum(newsid1_anum == GP[1] | newsid1_anum == GP[2] | newsid1_anum == GP[3])

sum(newsid1_anum == GP | newsid1_anum == WT)
sum(newsid1_anum == GP | newsid1_anum == WT)

sum(newsid1_anum[i] == GP | newsid1_anum[i] == WT)

sum(sum(newsid1_anum == GP | newsid1_anum == WT) == 1)

length(newsid1_anum)
length(neun_dir)

holder <- NA
for(i in 1:length(neun_dir)){holder[i] <- sum(newsid1_anum[i] == GP | newsid1_anum[i] == WT) }
sum(holder)


for (i in 1:length(neun_dir)){
  if(sum(newsid1_anum[i] == GP | newsid1_anum[i] == WT) == 1){file.copy(neun_dir[i], "F:/Deepika NeuN/neun_only_male_cortex_wtgp/", copy.date = T)}
  else(print("nope"))
}

#now need to remove the validation images and put on thier own

neun_wtgp <- dir("F:/Theo/full_backup_3_23_2021/Kaul_lab_work/bin_general/Deepika_Neun/processed images//")
neun_wtgp_trim <- trim_names(neun_wtgp, split = ".crop.")
neun_wtgp_sep <- sep_slidebook(neun_wtgp_trim)



wt_imgs <- neun_wtgp[as.character(neun_wtgp_sep[,1]) %in% as.character(WT)]
length(wt_imgs)
length(na.omit(wt_imgs))
wt_imgs <- na.omit(wt_imgs)

gp_imgs <- NA
gp_imgs <- neun_wtgp[neun_wtgp_sep[,1] %in% GP]
length(gp_imgs)
gp_imgs <- na.omit(gp_imgs)

chosenwt <- sample(wt_imgs, 5)
chosengp <- sample(gp_imgs, 5)
chosen <- c(chosenwt, chosengp)

setwd("F:/Theo/full_backup_3_23_2021/Kaul_lab_work/bin_general/Deepika_Neun/processed images/")
for (d in chosen){
  file.copy(d, "F:/Theo/full_backup_3_23_2021/Kaul_lab_work/bin_general/Deepika_Neun/Validation_imgs/")
  file.remove(d)
}

#doing this again for training images

neun_wtgp <- dir("F:/Theo/full_backup_3_23_2021/Kaul_lab_work/bin_general/Deepika_Neun/processed images/")
neun_wtgp_trim <- trim_names(neun_wtgp, split = ".crop.")
neun_wtgp_sep <- sep_slidebook(neun_wtgp_trim)



wt_imgs <- neun_wtgp[as.character(neun_wtgp_sep[,1]) %in% as.character(WT)]
length(wt_imgs)
length(na.omit(wt_imgs))
wt_imgs <- na.omit(wt_imgs)

gp_imgs <- NA
gp_imgs <- neun_wtgp[neun_wtgp_sep[,1] %in% GP]
length(gp_imgs)
gp_imgs <- na.omit(gp_imgs)

chosenwt <- sample(wt_imgs, 5)
chosengp <- sample(gp_imgs, 5)
chosen <- c(chosenwt, chosengp)

setwd("F:/Theo/full_backup_3_23_2021/Kaul_lab_work/bin_general/Deepika_Neun/processed images/")
for (d in chosen){
  file.copy(d, "F:/Theo/full_backup_3_23_2021/Kaul_lab_work/bin_general/Deepika_Neun/training images/")
  file.remove(d)
}