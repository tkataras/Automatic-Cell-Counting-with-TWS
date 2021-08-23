##making folders ####

##set wd to where you want folders, later this should be like THE ORIGIN
getwd()
CLASS_ORIGIN <- "F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/working_images/new_val_train_etc/new_new_train/class_8bit/"
setwd(CLASS_ORIGIN)


class_list <- dir(CLASS_ORIGIN)


prenums <- (strsplit(class_list,split = "classifier"))

prenums2 <- unlist(lapply(prenums, function(x) x[2]))

prenums3 <- lapply(strsplit(prenums2, split = ".model"), function(x) x[1])

nums <- as.numeric(unlist(prenums3))



##this looks a mess, but it just moves back a folder from the CLASS_ORIGIN
ORIGIN <- paste(c(((strsplit(CLASS_ORIGIN, split = "/")[[1]][-length(strsplit(CLASS_ORIGIN, split = "/")[[1]])])), ""),collapse = "/")
dir.create(paste(ORIGIN, "Weka_output", sep = ""))

#the class number MUST go at the end of the file name with nothing after it for BSH script to order correctly

#getting the number of needed folder from # classifier.model files in folder with ONLY classifier.model files

nm = "masks_class"
for (i in nums){
  dir.create(paste(ORIGIN, "Weka_output","/",nm,i,sep = ""))
}

OUTPUT_thresh <- paste(c(ORIGIN, "Weka_output_thresh/"), collapse = "")
dir.create(paste(OUTPUT_thresh, sep = ""))

for (i in nums){
  dir.create(paste(OUTPUT_thresh,"/",nm,i,sep = ""))
}

OUTPUT_project <- paste(c(ORIGIN, "Weka_output_thresh_project/"), collapse = "")
dir.create(paste(OUTPUT_project, sep = ""))

for (i in nums){
  dir.create(paste(OUTPUT_project,"/",nm,i,sep = ""))
}

OUTPUT_count <- paste(c(ORIGIN, "counted/"), collapse = "")
dir.create(paste(OUTPUT_count, sep = ""))

for (i in nums){
  dir.create(paste(OUTPUT_count,"/",nm,i,sep = ""))
}

