#!/usr/bin/env Rscript
###
# Author: Theo, Tyler
# Date 9/28/2021
# This file creates the directories inside of each stage of the pipeline for
# each classifier. Resulting in a number of classifiers equal to the number of
# subdirectories in each of the output directories.
###

##generating classifiers must be done before this step 

# Test Tyler area version of program
CLASS_ORIGIN <- "../tyler_test_area/Classifiers/"

# Normal use of where classifiers is
#CLASS_ORIGIN <- "../Data/Validation_files/Classifiers/"

# For the normal test area
#CLASS_ORIGIN <- "../test_area/Classifiers/"

##this looks a mess, but it just moves back a folder from the CLASS_ORIGIN
ORIGIN <- paste(c(((strsplit(CLASS_ORIGIN, split = "/")[[1]][-length(strsplit(CLASS_ORIGIN, split = "/")[[1]])])), ""),collapse = "/")

#the class number MUST go at the end of the file name with nothing after it for BSH script to order correctly

#getting the name of the folder from the classifier.model files in folder with ONLY classifier.model files
class_list_pre_trim <- dir(CLASS_ORIGIN)
class_list <- unlist(strsplit(class_list_pre_trim, ".model"))

# Folders to generate subfolders for
OUTPUT_thresh <- paste(c(ORIGIN, "Weka_Output_Thresholded/"), collapse = "")
OUTPUT_project <- paste(c(ORIGIN, "Weka_Output_Projected/"), collapse = "")
OUTPUT_count <- paste(c(ORIGIN, "Weka_Output_Counted/"), collapse = "")
INPUT_val_roi <- paste(c(ORIGIN, "Validation_Hand_Counts/"), collapse = "")

# Generate subfolders
for (i in class_list){
  dir.create(paste(ORIGIN, "Weka_Output","/",i,sep = ""))
  dir.create(paste(OUTPUT_thresh,"/",i,sep = ""))
  dir.create(paste(OUTPUT_project,"/",i,sep = ""))
  dir.create(paste(OUTPUT_count,"/",i,sep = ""))
}



