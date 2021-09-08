##making folders ####


##generating classifiers must be done before this step 


#CLASS_ORIGIN <- "Data/Validation_files/Classifiers/"
CLASS_ORIGIN <- "test_area/Classifiers/"

##this looks a mess, but it just moves back a folder from the CLASS_ORIGIN
ORIGIN <- paste(c(((strsplit(CLASS_ORIGIN, split = "/")[[1]][-length(strsplit(CLASS_ORIGIN, split = "/")[[1]])])), ""),collapse = "/")
dir.create(paste(ORIGIN, "Weka_Output", sep = ""))

#the class number MUST go at the end of the file name with nothing after it for BSH script to order correctly

#getting the name of the folder from the classifier.model files in folder with ONLY classifier.model files
class_list_pre_trim <- dir(CLASS_ORIGIN)
class_list <- unlist(strsplit(class_list_pre_trim, ".model"))


OUTPUT_thresh <- paste(c(ORIGIN, "Weka_Output_Thresholded/"), collapse = "")
dir.create(paste(OUTPUT_thresh, sep = ""))
OUTPUT_project <- paste(c(ORIGIN, "Weka_Output_Projected/"), collapse = "")
dir.create(paste(OUTPUT_project, sep = ""))
OUTPUT_count <- paste(c(ORIGIN, "Weka_Output_Counted/"), collapse = "")
dir.create(paste(OUTPUT_count, sep = ""))
INPUT_val <- paste(c(ORIGIN, "Validation_data/"), collapse = "")
dir.create(paste(INPUT_val, sep = ""))
INPUT_val_roi <- paste(c(ORIGIN, "Validation_Hand_Counts/"), collapse = "")
dir.create(paste(INPUT_val_roi, sep = ""))
RESULTS <- paste(c(ORIGIN, "Results/"), collapse = "")
dir.create(paste(RESULTS, sep = ""))


for (i in class_list){
  dir.create(paste(ORIGIN, "Weka_Output","/",i,sep = ""))
  dir.create(paste(OUTPUT_thresh,"/",i,sep = ""))
  dir.create(paste(OUTPUT_project,"/",i,sep = ""))
  dir.create(paste(OUTPUT_count,"/",i,sep = ""))
}



