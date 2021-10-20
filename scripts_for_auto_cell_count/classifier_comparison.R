#!/usr/bin/env Rscript
###
# Author: Theo, Tyler
# Date 10/20/2021
# This file is the pipeline for comparing classifier accuracy on validation data
#
# Inputs: genotype file, hand count results file from Cout Roi, results of The Count.IJM in each classifier folder 
# Outputs: csv table with accuracy measurements for each classifier
###

# Start of main

# Input the genotype data as .csv file
geno_file <- read.csv("../training_area/genotype.csv")

# File output location
OUTPUT_count <- "../training_area/Weka_Output_Counted/"
result_out <- "../training_area/Results/"

class_list <- dir(OUTPUT_count)

############################## now we have binary projected images to work with and need to compare to roi for each classifier

#initialize variables
row_row <- NA #holds row of accuracy values for each classifier one at a time
your_boat <- NA #holds all accuracy values for classifiers
count_h <- NA# holds hand count number per image



###################now need to proces the results files


#iterate through the counted classifier folders folders, will save final output within each folder
#setting working dir, needs to contain all counted output folders


##processing hand count roi to get count per image

### adding in the results of the hand_count_from_roi.ijm, this will not change by folder, and is generated manually by saving results in Imagej from Count ROI
hand_ini <- read.csv("../training_area/Results/roi_counts.csv")

lv_h <- levels(as.factor(hand_ini$Label))
for (i in 1:length(lv_h)){
  count_h[i]<- sum(hand_ini$Label == lv_h[i])
  
}
hand_final <- data.frame(cbind(lv_h, count_h))
hand_final$count_h <- as.numeric(hand_final$count_h)

#location of folders holding The Count output
counted_folder_dir <- OUTPUT_count

#iterate through each classifier 
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
    dftc <- class_results[class_results$Label == current_img_plus_png,]  ###pulls out just the rows in results with the image name of the current image
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
  
  geno <- geno_file

  final_blah$geno <- geno[,1]
  final_blah$geno <- as.factor(final_blah$geno)
  
  #####this makes the table comparing all classifiers
  
  
  #precision and recall per image
  prec2 <- final_blah$tp/(final_blah$tp + final_blah$fp)
  
  reca2 <-final_blah$tp/(final_blah$tp + final_blah$fn)
  F1_2 <- 2*(prec2*reca2/(prec2 + reca2))
  
  final_blah$prec2 <- prec2
  final_blah$reca2 <- reca2
  final_blah$F1_2 <-  F1_2
  
  ##t test on geno, only works with 2 geno
  if(length(levels(as.factor(geno[,1]))) > 2){
    print("automatic analysis can only be done with 2 levels, for alterative analysis use _Final.csv files in classifier folders")
  }

  levels(as.factor(geno[,1]))
  
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

write.csv(your_boat, paste(result_out,out_name, sep = ""))


