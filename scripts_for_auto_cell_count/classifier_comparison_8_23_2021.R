#!/usr/bin/env Rscript
###
# Author: Theo
# Date 8/26/2021
# This file is the pipeline.....
#

###
# Method: trim_names 
# Input: file names
# Output: bisected file names based on split
# Description:useful if information in automatic file name from microscope is repetitive
###
trim_names <- function(file_names, split = " - ", half = "front"){
  id1 <- file_names
  sid1 <- strsplit(id1, split)
  
  
  newsid1 <- NA
  for (i in 1:length(sid1)){
    if(half == "back") {newsid1 <- c(newsid1, tail(sid1[[i]],1))} 
    else if(half == "front") { newsid1 <- c(newsid1, head(sid1[[i]],1))} 
    else{print("half = front or back, please")
      break}
    
  }
  newsid1 <- newsid1[-1]
  
}

###
# Method: Sep_slidebook 
# Input: file names containng all relevant image info (animal #, slice #, field #)
# Output: data frame with each type of info as it own column
# Description: parses out individual grouping variables
###
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

###
# Method: squish 
# Input: data from of grouping variables
# Output: list of unique image IDs contining specific grouping information
# Description: creates one grouping object for each image that can be compared across other iterations of the images with slightly different file names
###
squish <- function(input_df){
  
  id1_df_squish <- NA
  for (i in 1:dim(input_df)[1]) {
    id1_df_squish[i] <- paste0(input_df[i,], sep = "_", collapse = "")  
  }
  return(id1_df_squish)
}

###
# Method: get_match_id 
# Input: 
# Output:
# Description: simple function to combine rows of the df with info
###
get_match_id <- function(sub_inv,full_inv){
  match_id <- NA
  
  for (i in 1: length(sub_inv) ){
    pineapple <- grep(sub_inv[i],full_inv)
    if (sum(pineapple) == 0) {print("not found")}
    else match_id[i] <- pineapple
  }
  match_id <- match_id[complete.cases(match_id)]
}

# class_list <- dir(CLASS_ORIGIN)
# 
# 
# prenums <- (strsplit(class_list,split = "classifier"))
# 
# prenums2 <- unlist(lapply(prenums, function(x) x[2]))
# 
# prenums3 <- lapply(strsplit(prenums2, split = ".model"), function(x) x[1])
# 
# nums <- as.numeric(unlist(prenums3))
# 
# 
# 
# ##this looks a mess, but it just moves back a folder from the CLASS_ORIGIN
# ORIGIN <- paste(c(((strsplit(CLASS_ORIGIN, split = "/")[[1]][-length(strsplit(CLASS_ORIGIN, split = "/")[[1]])])), ""),collapse = "/")
# 
# 
# 
# OUTPUT_count <- paste(c(ORIGIN, "counted/"), collapse = "")
# dir(OUTPUT_count)
# 


# Start of main

# Remove results file if it already exists #**** need to change in long term
unlink('Data/Validation_files/Weka_Output_Counted/All_classifier_comparison_inc_missing_8_11.csv')

# Input the genotype data as .txt file
geno_file <- scan(file="Data/genotype.txt", what='character')


# File output location
OUTPUT_count <- "Data/Validation_files/Weka_Output_Counted/"

class_list <- dir(OUTPUT_count)
#setwd("C:/Users/19099/Documents/Kaul_Lab/AutoCellCount/Automatic-Cell-counting-with-TWS")

############################## now we have binary projected images to work with and need to compare to roi for each classifier
your_boat <- NA




###################now need to proces the results files


#iterate through results folders, will save final output within
#setting working dir, needs to contain all counted output folders

### adding in the results of the hand_count_from_roi.ijm, this will not change by folder
#hand_ini <- read.csv("C:/Users/19099/Documents/Kaul_Lab/AutoCellCount/Automatic-Cell-counting-with-TWS/Data/Corrected_files/Results/Results_hand_roi_8_3_2021.csv")
hand_ini <- read.csv("Data/Validation_files/Results/Results_hand_roi_8_3_2021.csv")

##processing hand count roi to get count per image
lv_h <- levels(as.factor(hand_ini$Label))

count_h <- NA
for (i in 1:length(lv_h)){
  count_h[i]<- sum(hand_ini$Label == lv_h[i])
  
}
hand_final <- data.frame(cbind(lv_h, count_h))
hand_final$count_h <- as.numeric(hand_final$count_h)


counted_folder_dir <- OUTPUT_count
#setwd(counted_folder_dir)

for (f in 1:length(class_list)){
  class_res_loc <- paste(counted_folder_dir,dir(OUTPUT_count)[f],"/Results.csv",sep = "")
  class_results <- read.csv(class_res_loc)
  class <- dir(OUTPUT_count)[f]
  
  ##if else loop for determining true positive, false positive and false negative cell counts
  
  ##from levels present in the classifier results output, this should be the same each time, BUT IT WoNT BE IF ONE IMAGE HAS NO CELL OBJECtS
  #need to go into the counted folder and pull out all image names, meaning ignorming the Restuls.csv files. images from tru_count with be .png
  folder_loc <- paste(counted_folder_dir,"/",dir(OUTPUT_count)[f], collapse = "", sep = "")
  files <- list.files(path =  folder_loc, pattern = "\\.png$")
  
  img_names <- files
  #img_names <- levels(as.factor(class_results$Label))
  
  #initialize data frame
  final_blah <- data.frame(name = NA, tp = NA, fp = NA, fn= NA)
  
  ###### can use this to check size restriction 
  #print(min(class_results$Area))
  
  ##this next part does the collecting of tp, fp and fp and turns it into precision and recall
  for (i in 1:length(img_names)) {
    
    ##this .png cames from saving by the tru_count imagej macro. needs to be removed to match the image names in the results file
    current_img_plus_png <- img_names[i]
    current_img_plus_png_split <- unlist(strsplit(current_img_plus_png, split = ""))
    new_length <-length(current_img_plus_png_split) - 8 #this used to be 4, but now i have to remove "mask.png"
    current_img <- paste(current_img_plus_png_split[1:new_length], sep = "", collapse = "")
    # 
    dftc<- NA
    dftc <- class_results[class_results$Label == current_img,]  ###pulls out just the rows in results with the image name of the current image
    dftc
    
    if (dim(dftc)[1] == 0){
      #here is where we handle empty images
      name <- img_names[i]
      tp = 0
      fp = 0
      fn = as.numeric(hand_final$count_h[i])
      this_row <- cbind(name,tp, fp, fn) 
      
    } else {
      fp = 0
      tp = 0
      fn = 0
      for (j in 1:length(dftc$points)) {
        if (dftc$points[j] == 0) {
          fp = fp +1
        } #auto count objects with no hand markers
        else if (dftc$points[j] == 1) {
          tp = tp +1
        } #auto count objects with exactly 1 marker
        else {
          tp = tp+1 #adds one tp and requisite number of fn for objects with multiple markers
          fn = fn + dftc$points[j] - 1
        }
      }
      #for each image add total number hand count - sum(dftc$points), the sum points must always be less than hand_final$count 
      ## dtfc$points only counts the markers that fall within cell objects, hand_final$counts is the sum of all points in total. 
      #when this is not true(eg there are negative values) check the image names of the hand count!!
      missed <- as.numeric(hand_final$count_h[i]) - sum(dftc$points) 
      fn <- fn + missed
      name <- img_names[i]
      this_row <- cbind(name, tp, fp, fn) 
      
      
    } #this is the closing bracket for if there were no cell objects so dftc is empty
    
    final_blah <-rbind(final_blah, this_row)
    
  }
  
  # Set final_blah columns to be numeric
  final_blah <- final_blah[-1,]
  final_blah$tp <- as.numeric(final_blah$tp)
  final_blah$fp <- as.numeric(final_blah$fp)
  final_blah$fn <- as.numeric(final_blah$fn)
  
  ##need to calculate Precision and recall
  tot_tp <- sum(as.numeric(final_blah$tp))
  tot_fp <- sum(as.numeric(final_blah$fp))
  tot_fn <- sum(as.numeric(final_blah$fn))
  
  
  #precision is tp/(tp + fp)
  
  prec <- tot_tp/(tot_tp + tot_fp)
  #recall is tp/(tp + fn)
  reca <- tot_tp/(tot_tp + tot_fn)
  
  F1 <- 2*(prec*reca/(prec + reca))
  
  
  prec <- round(prec, 4)
  reca <- round(reca, 4)
  F1 <- round(F1, 4)
  
  print(paste(class," precision = ", prec ))
  print(paste(class," recall = ", reca ))
  print(paste(class," F1 = ", F1 ))
  
  current_loc <- paste(counted_folder_dir,"/",class_list[f],sep = "")
  file_out_name <- paste(current_loc,"/",class,"_Final.csv",sep = "")
  #writes out the final file to save the output
  write.csv(final_blah, file_out_name )
  
  # #need to add geno again
  # #going to do automatically this time
  # a <- trim_names(final_blah$name)
  # b <- sep_slidebook(a)
  # c <- squish(b)
  # length(c)
  # d <- cbind(final_blah$name,c,b) ##specify: original file names, info columns, squished ID
  # colnames(d) <- c("file_name", "img_ID", "a_num","S_num", "F_num")
  # d <- data.frame(d)
  # 
  # Why is this saved as a string theo?
  #geno <- c("gp", "gp", "gp", "wt", "gp", "gp", "wt", "wt", "wt", "wt")
  geno <- geno_file
  final_blah$geno <- geno
  final_blah$geno <- as.factor(final_blah$geno)
  
  #####this makes the table comparing all classifiers
  
  
  #precision and recall per image
  prec2 <- final_blah$tp/(final_blah$tp + final_blah$fp)
  
  reca2 <-final_blah$tp/(final_blah$tp + final_blah$fn)
  F1_2 <- 2*(prec2*reca2/(prec2 + reca2))
  
  final_blah$prec2 <- prec2
  final_blah$reca2 <- reca2
  final_blah$F1_2 <-  F1_2
  
  
  p_g_tt <- t.test(final_blah$prec2 ~ final_blah$geno)
  p_g_tt_p <- p_g_tt$p.value
  
  r_g_tt <- t.test(final_blah$reca2 ~ final_blah$geno)
  r_g_tt_p <- r_g_tt$p.value
  
  F1_g_tt <- t.test(final_blah$F1_2 ~ final_blah$geno)
  F1_g_tt_p <- F1_g_tt$p.value
  
  
  mean_F1_gp <-(F1_g_tt$estimate[1])
  mean_F1_wt <-(F1_g_tt$estimate[2])
  
  p_g_tt_p <- p_g_tt$p.value
  r_g_tt_p <- r_g_tt$p.value
  
  class
  
  row_row <- cbind(class,prec,reca,F1,F1_g_tt_p, mean_F1_gp,mean_F1_wt, p_g_tt_p,r_g_tt_p, class)#F1_s_tt_p,mean_F1_m, mean_F1_f
  your_boat <- rbind(your_boat, row_row)
  
  
  
}#this is the bottom bracket of iterating through all the class folders
format(Sys.time(),"%D")

#generating a unique file name based on time and date
date <- format(Sys.time(),"%D-%H_%M")
date2 <- gsub("/", "_", date)

out_name <- paste0("All_classifier_Comparison_", date2, ".csv") 

write.csv(your_boat, paste(counted_folder_dir,out_name, sep = ""))


