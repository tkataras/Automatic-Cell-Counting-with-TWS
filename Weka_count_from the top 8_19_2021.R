#there is a significant time requirement to create the feature stack

##trainng has been done. all val images in 1 folder, all classifiers in another
#training images must have same bit depth (eg 8 bit, 16 bit)!!!!

#Reqs
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



##making folders ####

##set wd to where you want folders, later this should be like THE ORIGIN
getwd()
CLASS_ORIGIN <- "C:/Users/19099/Documents/Kaul_Lab/AutoCellCount/Automatic-Cell-counting-with-TWS"
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
OUTPUT_thresh <- paste(c(ORIGIN, "Weka_output_thresh/"), collapse = "")
dir.create(paste(OUTPUT_thresh, sep = ""))
OUTPUT_project <- paste(c(ORIGIN, "Weka_output_thresh_project/"), collapse = "")
dir.create(paste(OUTPUT_project, sep = ""))
OUTPUT_count <- paste(c(ORIGIN, "counted/"), collapse = "")
dir.create(paste(OUTPUT_count, sep = ""))
for (i in nums){
  dir.create(paste(ORIGIN, "Weka_output","/",nm,i,sep = ""))
  dir.create(paste(OUTPUT_thresh,"/",nm,i,sep = ""))
  dir.create(paste(OUTPUT_project,"/",nm,i,sep = ""))
  dir.create(paste(OUTPUT_count,"/",nm,i,sep = ""))
}



              ###now we need to apply each classifier to all val images and output segmentations in all class folders
## we do this with a BeanShell script interfacting with Weka without GUI
##F:\Theo\iba_7_2020_autocount\Hina_IFNBKO_pair\working_images\new_val_train_etc\test\BS_class_test.bsh

###need to threshold Weka imge outputs for this next step!!!
:q
#now need to process the multi plane validation images
#will do this in R, but will need to regularize image names to project pairs and trios correctly.
#if you do not need this sort of image processing, this step in not neccessary

##getting images names, can pick any folder with all images in question to do this

inputdir_all1 <-"C:/Users/19099/Documents/Kaul_Lab/AutoCellCount/Automatic-Cell-counting-with-TWS/Data/" 
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





############################## now we have binary projected images to work with and need to compare to roi for each classifier
your_boat <- "tru_count_over_dir_correct_8_13.ijm"

##we use tru_count_over_dir_correct.ijm

  
###################now need to proces the results files


#iterate through results folders, will save final output within
#setting working dir, needs to contain all counted output folders

### adding in the results of the hand_count_from_roi.ijm, this will not change by folder
hand_ini <- read.csv("C:/Users/19099/Documents/Kaul_Lab/AutoCellCount/Automatic-Cell-counting-with-TWS/Results_hand_roi_8_3_2021.csv")

##processing hand count roi to get count per image
lv_h <- levels(as.factor(hand_ini$Label))

count_h <- NA
for (i in 1:length(lv_h)){
  count_h[i]<- sum(hand_ini$Label == lv_h[i])
  
}
hand_final <- data.frame(cbind(lv_h, count_h))
hand_final$count_h <- as.numeric(hand_final$count_h)


counted_folder_dir <- COUNTED
setwd(counted_folder_dir)



for (f in 1:length(class_list)){
  class_res_loc <- paste(counted_folder_dir,"/",dir(OUTPUT_count)[f],"/Results.csv",sep = "")
  class_results <- read.csv(class_res_loc)
  class <- paste("class",nums[f], sep = "")
  
  
  
  ##biig if else loop baby!
  
  ##from levels present in the classifier results output, this should be the same each time, BUT IT WoNT BE IF ONE IMAGE HAS NO CELL OBJECtS
  #need to go into the counted folder and pull out all image names, meaning ignorming the Restuls.csv files. images from tru_count with be .png
   folder_loc <- paste(counted_folder_dir,"/",class_list[f], collapse = "", sep = "")
  files <- list.files(path =  folder_loc, pattern = "\\.png$")
  
  img_names <- files
  #img_names <- levels(as.factor(class_results$Label))
  
  #initialize data frame
  final_blah <- data.frame(name = NA, tp = NA, fp = NA, fn= NA)
  
  ###### can use this to check size restriction 
  #print(min(class_results$Area))
 
    
    
    ##this next part does the collecting of tp, fp and fp and turns it into precision and recall
    for (i in 1:length(img_names)) {
      
      ##this ".png" at the end of file name cames from saving by the tru_count imagej macro. needs to be removed to match the image names in the results file
      current_img_plus_png <- img_names[i]
      current_img_plus_png_split <- unlist(strsplit(current_img_plus_png, split = ""))
      new_length <-length(current_img_plus_png_split) - 4
      current_img <- paste(current_img_plus_png_split[1:new_length], sep = "", collapse = "")
      
      dftc<- NA
      dftc <- class_results[class_results$Label == current_img,]  ###pulls out just the rows in results with the image name of the current image
      
      dftc <- class_results[class_results$Label == current_img_plus_png,]
      
      dftc
      
      if (dim(dftc)[1] == 0){
        #here is where we handle empty images
        name <- img_names[i]
        tp = 0
        fp = 0
        fn = as.numeric(hand_final$count_h[i])
        this_row <- cbind(name,tp, fp, fn) 
        
      }else {
      
      
      fp = 0
      tp = 0
      fn = 0
      #i = 5
      for (j in 1:length(dftc$points)) {
        if (dftc$points[j] == 0){fp = fp +1} #auto count objects with no hand markers
        else if (dftc$points[j] == 1){tp = tp +1} #auto count objects with exactly 1 marker
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
      
      
      }#this is the closeing bracket for if there were no cell objects so dftc is empty
      
      final_blah <-rbind(final_blah, this_row)
      
    }
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
  #write.csv(final_blah, file_out_name )
  
  
  
  #*#*#*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!this is where the problem comes in with 9 image name levels via img_names!!!!!!!!!!!!!!!!
  
  ###need to add the genotype info, also the final auto count from tp+fp, i do so in excell
  #this next variable will contain  the genotype designation for images, could also build this in exell and laod in as csv
  #final_blah$name
  geno <- c("gp","gp","gp", "wt","gp", "gp", "wt", "wt", "wt", "wt")
  #important to double check
  ##cbind(final_blah$name, geno)

  final_blah$geno <- geno 
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
  
  class_numb <- nums[f]
  
  row_row <- cbind(class,prec,reca,F1,F1_g_tt_p, mean_F1_gp,mean_F1_wt, p_g_tt_p,r_g_tt_p, class_numb)#F1_s_tt_p,mean_F1_m, mean_F1_f
  your_boat <- rbind(your_boat, row_row)
    
    
  
}#this is the bottom bracket of iterating through all the class folders




write.csv(your_boat, paste(counted_folder_dir,"/All_classifier_comparison_inc_missing_8_11.csv", sep = ""))

  







#chose best classifier and applied it over full dataset ###########################################################################################
#used variable image projection 2 or 3.R to project the thresholded images
#used The tru count on projected iamges
#need to redo the accuracy analysis (for my data, normal use of this protocol will only use the audit set for this)


hand_ini <- read.csv("F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/working_images/Results_roi_after_Npt3_7_16_2021.csv")

##processing hand count roi to get count per image
lv_h <- levels(as.factor(hand_ini$Label))

count_h <- NA
for (i in 1:length(lv_h)){
  count_h[i]<- sum(hand_ini$Label == lv_h[i])
  
}
hand_final <- data.frame(cbind(lv_h, count_h))
hand_final$count_h <- as.numeric(hand_final$count_h)


counted_folder_dir <-"F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/working_images/new_val_train_etc/new_new_train/full_data/counted/"
setwd(counted_folder_dir)
class_list <- list.files()



prenums <- (strsplit(class_list,split = "class"))

nums <- unlist(lapply(prenums, function(x) x[2]))
nums <- as.numeric(nums)

#for (f in 1:length(class_list)){
f = 1 
 class_loc <- paste(counted_folder_dir,class_list[f],"/Results.csv",sep = "")
  class_results <- read.csv(class_loc)
  class <- paste("class",nums[f], sep = "")
  
  
  
  ##biig if else loop baby!
  
  ##from levels present in the classifier results output, this should be the same each time
  img_names <- levels(as.factor(class_results$Label))
  #initialize data frame
  final_blah <- data.frame(name = NA, tp = NA, fp = NA, fn= NA)

  
  
  ##this next part does the collecting of tp, fp and fp and turns it into precision and recall
  for (i in 1:length(img_names)) {
    
    current_img <- img_names[i]
    dftc<- NA
    dftc <- class_results[class_results$Label == current_img,]  ###pulls out just the rows in results with the image name of the current image
    
    
    
    
    fp = 0
    tp = 0
    fn = 0
    #i = 5
    for (j in 1:length(dftc$points)) {
      if (dftc$points[j] == 0){fp = fp +1} #auto count objects with no hand markers
      else if (dftc$points[j] == 1){tp = tp +1} #auto count objects with exactly 1 marker
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
    final_blah <-rbind(final_blah, this_row)
    
  }
  final_blah <- final_blah[-1,]
  final_blah$tp <- as.numeric(final_blah$tp)
  final_blah$fp <- as.numeric(final_blah$fp)
  final_blah$fn <- as.numeric(final_blah$fn)
  
 
  
  
  
  ###***#*#*#*#*# HAVE TO remOVE the VALIDATION FILES FROM HAND AND AUTO COUNTS; WILL NEED TO DO THIS TO SUPERDF MUCH LAter TOO any time my count is used
  
  
  valid_files <- dir("F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/working_images/new_val_train_etc/validation_roi/")
  a2 <- trim_names(valid_files)
  b2 <- sep_slidebook(a2)
  c2 <- squish(b2)
  
  a <- trim_names(final_blah$name)
  b <- sep_slidebook(a)
  c <- squish(b)
  length(c)
  d <- cbind(final_blah$name,c,b) ##specify: original file names, info columns, squished ID
  colnames(d) <- c("file_name", "img_ID", "a_num","S_num", "F_num")
  d <- data.frame(d)
  
  
  val <- get_match_id(c2,c)
  length(val)
  dim(final_blah)
  final_blah <- final_blah[-val,]
  dim(final_blah)
  # 
  # hand_final <- hand_final[-val,]
  # head(hand_final)
  
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
  
  
  
  current_loc <- paste(counted_folder_dir,class_list[f],sep = "")
  file_out_name <- paste(current_loc,"/",class,"_Final.csv",sep = "")
  write.csv(final_blah, file_out_name )
  
  
  
  #need to add geno again
  #going to do automatically this time
  
  
  wtn = c(442, 460, 462,878, 899, 898)
  gpn = c(426, 428, 443, 306, 307, 319)
  
  wt_imgs <- final_blah[d$a_num %in% wtn, ]
  dim(wt_imgs)
  gp_imgs <- final_blah[d$a_num %in% gpn, ]
  dim(gp_imgs)
  
  final_blah$geno[d$a_num %in% wtn] = "wt"
  final_blah$geno[d$a_num %in% gpn] = "gp"
  
  
  
  
  
  
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
  
  
  row_row <- cbind(class,prec,reca,F1,F1_g_tt_p, mean_F1_gp,mean_F1_wt, p_g_tt_p,r_g_tt_p)
  
  
  wt_prec_sd <-sd(final_blah$prec2[final_blah$geno == "wt"])
  gp_prec_sd <-sd(final_blah$prec2[final_blah$geno == "gp"])
  
  wt_reca_sd <-sd(final_blah$reca2[final_blah$geno == "wt"])
  gp_reca_sd <-sd(final_blah$reca2[final_blah$geno == "gp"])
  
  
  
  df2 <-  cbind(c("wt","wt", "gp", "gp"), c("precision", "recall", "precision", "recall"), as.numeric(c(p_g_tt$estimate[2], r_g_tt$estimate[2], p_g_tt$estimate[1],r_g_tt$estimate[1])), 
                  as.numeric(c(wt_prec_sd,wt_reca_sd,gp_prec_sd,gp_reca_sd)) )
  
  
  df2 <- data.frame(df2)
  names(df2) <-c("Genotype", "measurement", "mean", "sd")
  df2$mean <-as.numeric(df2$mean)
  df2$sd <-as.numeric(df2$sd)
  df2  
  
  
  df2$Genotype <- factor(df2$Genotype, levels = c("wt", "gp"))
  
   library(ggplot2)
  X11()
  ggplot(df2, aes(x=as.factor(Genotype), y=mean, fill=measurement)) +
    geom_bar(position=position_dodge(), stat="identity", colour='black') +
    geom_errorbar(aes(ymin=mean-sd, ymax=mean+sd), width=.2,position=position_dodge(.9)) +
    scale_fill_brewer(palette="Paired") +
    theme(axis.text.y = element_text(size = 15))
  
  
  
  
  ###**#*#*#* stop here and use geting all the dfs to watch was correct first time.R to trim down the hand count to the images in final_blah
  #(should b eonly wt/gp and exclude validaiton files)
  
  ###doing the counts/mean density analysis
  final_blah$hand_count <- hand_final$count_h
  
  final_blah$auto_count <- final_blah$tp + final_blah$fp
  
  
  t.test(final_blah$auto_count ~ final_blah$geno)
  t.test(final_blah$hand_count ~ final_blah$geno)
  
  t.test(final_blah$hand_count[final_blah$geno == "wt"],final_blah$auto_count[final_blah$geno == "wt"])
  t.test(final_blah$hand_count[final_blah$geno == "gp"],final_blah$auto_count[final_blah$geno == "gp"])
  
  var.test(final_blah$hand_count[final_blah$geno == "wt"], final_blah$auto_count[final_blah$geno == "wt"])
  var.test(final_blah$hand_count[final_blah$geno == "gp"], final_blah$auto_count[final_blah$geno == "gp"])
  
  
  
  me_h_wt <- mean(final_blah$hand_count[final_blah$geno == "wt"])
  sd_h_wt <- sd(final_blah$hand_count[final_blah$geno == "wt"])
  
  me_h_gp <- mean(final_blah$hand_count[final_blah$geno == "gp"])
  sd_h_gp <- sd(final_blah$hand_count[final_blah$geno == "gp"])
  
  me_a_wt <- mean(final_blah$auto_count[final_blah$geno == "wt"])
  sd_a_wt <- sd(final_blah$auto_count[final_blah$geno == "wt"])
  
  me_a_gp <- mean(final_blah$auto_count[final_blah$geno == "gp"])
  sd_a_gp <- sd(final_blah$auto_count[final_blah$geno == "gp"])
  
  
  
  
  df1 <- cbind(c("wt","wt", "gp", "gp"), c("hand", "auto", "hand", "auto"), as.numeric(c(me_h_wt,me_a_wt,me_h_gp,me_a_gp)), as.numeric(c(sd_h_wt,sd_a_wt,sd_h_gp,sd_a_gp)) )
  df1 <- data.frame(df1)
  names(df1) <-c("Genotype", "Count", "mean", "sd")
  df1
  str(df1)
  df1$mean <-as.numeric(df1$mean)
  df1$sd <-as.numeric(df1$sd)
  
  df1$Genotype <- factor(df1$Genotype, levels = c("wt", "gp"))
  
  #library(ggplot2)
  X11()
  ggplot(df1, aes(x=as.factor(Genotype), y=mean, fill=Count)) +
    geom_bar(position=position_dodge(), stat="identity", colour='black') +
    geom_errorbar(aes(ymin=mean-sd, ymax=mean+sd), width=.2,position=position_dodge(.9)) +
    scale_fill_brewer(palette="Paired") +
    theme(axis.text.y = element_text(size = 15)) +
    ylim(c(0,200))
  
  
  
  
  write.csv(superdf, "F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/working_images/new_val_train_etc/superdf_no_val_area_adj_8_12")
  ##huge graph??

  # ####getting in Hinas (and my ) area adj count
  # superdf <- read.csv("F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/working_images/superdf_run1_area_adj.csv")
  # superdf <- superdf[,]
  # #*#*#*#*# still need to remove the val images from the super DF, use other .R script now
  dim(superdf)
  
  #*#*#*# now doing all stats from an updated superdf file located in new new train
  superdf <- read.csv("F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/working_images/new_val_train_etc/superdf_no_val_area_adj_8_12.csv")
  dim(superdf)
  head(superdf)
  
  
  
  
  
  #overwriting with area adjusted values, (2 total values changed slightly)
  final_blah$auto_count <- superdf$count_new_auto
  final_blah$hand_count <- superdf$count_theo_hand
  
  
  
  me_ha_wt <- mean(superdf$count_Hina_hand[superdf$geno == "wt"])
  sd_ha_wt <- sd(superdf$count_Hina_hand[superdf$geno == "wt"])
  
  me_ha_gp <- mean(superdf$count_Hina_hand[superdf$geno == "gp"])
  sd_ha_gp <- sd(superdf$count_Hina_hand[superdf$geno == "gp"])
  
  #hand count b
  me_hb_wt <- mean(superdf$count_theo_hand[superdf$geno == "wt"])
  sd_hb_wt <- sd(superdf$count_theo_hand[superdf$geno == "wt"])
  
  me_hb_gp <- mean(superdf$count_theo_hand[superdf$geno == "gp"])
  sd_hb_gp <- sd(superdf$count_theo_hand[superdf$geno == "gp"])
  
  #auto count
  me_a_wt <- mean(superdf$count_new_auto[superdf$geno == "wt"])
  sd_a_wt <- sd(superdf$count_new_auto[superdf$geno == "wt"])
  
  me_a_gp <- mean(superdf$count_new_auto[superdf$geno == "gp"])
  sd_a_gp <- sd(superdf$count_new_auto[superdf$geno == "gp"])
  
  
  

  
  df1 <- cbind(c("wt","wt","wt", "gp", "gp", "gp"), c("hand_A","hand_B", "auto", "hand_A","hand_B", "auto"), 
               as.numeric(c(me_ha_wt,me_hb_wt,me_a_wt,me_ha_gp,me_hb_gp,me_a_gp)), 
               as.numeric(c(sd_ha_wt,sd_hb_wt,sd_a_wt,sd_ha_gp,sd_hb_gp,sd_a_gp)) 
  )
  
  
  df1 <- data.frame(df1)
  names(df1) <-c("Genotype", "Count", "mean", "sd")
  df1
  str(df1)
  df1$mean <-as.numeric(df1$mean)
  df1$sd <-as.numeric(df1$sd)
  
  
  df1$Genotype <- factor(df1$Genotype, levels = c("wt", "gp"))
  
  #library(ggplot2)
  X11()
  ggplot(df1, aes(x=as.factor(Genotype), y=mean, fill=Count)) +
    geom_bar(position=position_dodge(), stat="identity", colour='black') +
    geom_errorbar(aes(ymin=mean-sd, ymax=mean+sd), width=.2,position=position_dodge(.9)) +
    scale_fill_brewer(palette="Paired") +
    theme(axis.text.y = element_text(size = 15)) +
    ylim(c(0,200))
  
  
  
  
  
  
  ###trying another chart organization
  
  df2 <- cbind(c("wt", "gp","wt", "gp","wt", "gp" ), c("hand_A","hand_A","hand_B","hand_B", "auto","auto"), 
               as.numeric(c(me_ha_wt,me_ha_gp, me_hb_wt,me_hb_gp,me_a_wt,me_a_gp)),
               as.numeric(c(sd_ha_wt,sd_ha_gp, sd_hb_wt,sd_hb_gp,sd_a_wt,sd_a_gp)) 
  )
  
  df2 <- data.frame(df2)
  names(df2) <-c("Genotype", "Count", "mean", "sd")
  df2$mean <-as.numeric(df2$mean)
  df2$sd <-as.numeric(df2$sd)
  #library(ggplot2)
  X11()
  ggplot(df2, aes(x=as.factor(Count), y=mean, fill=Genotype)) +
    geom_bar(position=position_dodge(), stat="identity", colour='black') +
    geom_errorbar(aes(ymin=mean-sd, ymax=mean+sd), width=.2,position=position_dodge(.9)) +
    scale_fill_brewer(palette="Paired") +
    theme(axis.text.y = element_text(size = 15)) +
    ylim(c(0,200))
  
  
  ##relevant t tests for above chart
  
  #a vs b
  t.test(superdf$count_theo_hand[superdf$geno == "wt"] , superdf$count_Hina_hand[superdf$geno == "wt"])#NS
  t.test(superdf$count_theo_hand[superdf$geno == "gp"] , superdf$count_Hina_hand[superdf$geno == "gp"])#NS
  
  
  #a vs auto
  t.test(superdf$count_Hina_hand[superdf$geno == "wt"] , superdf$count_new_auto[superdf$geno == "wt"])#S 4.574e-05
  t.test(superdf$count_Hina_hand[superdf$geno == "gp"] , superdf$count_new_auto[superdf$geno == "gp"])#NS 0.128
  
  
  #b vs auto
  t.test(superdf$count_theo_hand[superdf$geno == "wt"] , superdf$count_new_auto[superdf$geno == "wt"])# S 0.00028
  t.test(superdf$count_theo_hand[superdf$geno == "gp"] , superdf$count_new_auto[superdf$geno == "gp"])# NS 0.58
  
  
  ## wt vs gp
  t.test(superdf$count_Hina_hand ~ superdf$geno)
  t.test(superdf$count_theo_hand ~ superdf$geno)
  t.test(superdf$count_new_auto ~ superdf$geno)
  
  
  
  
  
  ####corr graphs with my hand count
  
  WT = lm(final_blah$hand_count[final_blah$geno == "wt"] ~final_blah$auto_count[final_blah$geno == "wt"])
  summary(WT)
  X11()
  plot((final_blah$hand_count[final_blah$geno == "wt"] ~final_blah$auto_count[final_blah$geno == "wt"]),  pch = 20, col = "gray" , cex = 2)#,ylim = c(50,250), xlim = c(50,250))
  abline(lm(WT), lwd=2)
  
  GP = lm(final_blah$hand_count[final_blah$geno == "gp"] ~final_blah$auto_count[final_blah$geno == "gp"])
  summary(GP)
  X11()
  plot((final_blah$hand_count[final_blah$geno == "gp"]~final_blah$auto_count[final_blah$geno == "gp"]),  pch = 20, col = "gray" , cex = 2)#,ylim = c(50,250), xlim = c(50,250))
  abline(lm(GP), lwd=2)
  
  #corr with Hina
  WT = lm(superdf$count_Hina_hand[final_blah$geno == "wt"] ~final_blah$auto_count[final_blah$geno == "wt"])
  summary(WT)
  X11()
  plot((superdf$count_Hina_hand[final_blah$geno == "wt"] ~final_blah$auto_count[final_blah$geno == "wt"]),  pch = 20, col = "gray" , cex = 2)#,ylim = c(50,250), xlim = c(50,250))
  abline(lm(WT), lwd=2)
  
  GP = lm(superdf$count_Hina_hand[final_blah$geno == "gp"] ~final_blah$auto_count[final_blah$geno == "gp"])
  summary(GP)
  X11()
  plot((superdf$count_Hina_hand[final_blah$geno == "gp"]~final_blah$auto_count[final_blah$geno == "gp"]),  pch = 20, col = "gray" , cex = 2)#,ylim = c(50,250), xlim = c(50,250))
  abline(lm(GP), lwd=2)
  
  ##Corr hina vs my hadn count
  WT = lm(superdf$count_Hina_hand[final_blah$geno == "wt"] ~final_blah$hand_count[final_blah$geno == "wt"])
  summary(WT)
  X11()
  plot((superdf$count_Hina_hand[final_blah$geno == "wt"] ~final_blah$hand_count[final_blah$geno == "wt"]),  pch = 20, col = "gray" , cex = 2)#,ylim = c(50,250), xlim = c(50,250))
  abline(lm(WT), lwd=2)
  
  GP = lm(superdf$count_Hina_hand[final_blah$geno == "gp"] ~final_blah$hand_count[final_blah$geno == "gp"])
  summary(GP)
  X11()
  plot((superdf$count_Hina_hand[final_blah$geno == "gp"]~final_blah$hand_count[final_blah$geno == "gp"]),  pch = 20, col = "gray" , cex = 2)#,ylim = c(50,250), xlim = c(50,250))
  abline(lm(GP), lwd=2)
  
#}



### doing the audit set this will require image selection and counting for others, but for us since all images are counted, we just need to pull a random sample
# of 5 wt and 5 gp from final_blah

fb_wt <- final_blah[final_blah$geno == "wt",]
fb_gp <- final_blah[final_blah$geno == "gp",]

audit_set <- rbind(fb_wt[sample(1:length(fb_wt$name),5),],fb_gp[sample(1:length(fb_gp$name),5),] )




tot_tp <- sum(as.numeric(audit_set$tp))
tot_fp <- sum(as.numeric(audit_set$fp))
tot_fn <- sum(as.numeric(audit_set$fn))


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



#precision and recall per image
prec2 <- audit_set$tp/(audit_set$tp + audit_set$fp)

reca2 <-audit_set$tp/(audit_set$tp + audit_set$fn)
F1_2 <- 2*(prec2*reca2/(prec2 + reca2))

audit_set$prec2 <- prec2
audit_set$reca2 <- reca2
audit_set$F1_2 <-  F1_2


p_g_tt <- t.test(audit_set$prec2 ~ audit_set$geno)
p_g_tt_p <- p_g_tt$p.value

r_g_tt <- t.test(audit_set$reca2 ~ audit_set$geno)
r_g_tt_p <- r_g_tt$p.value

F1_g_tt <- t.test(audit_set$F1_2 ~ audit_set$geno)
F1_g_tt_p <- F1_g_tt$p.value

mean_F1_gp <-(F1_g_tt$estimate[1])
mean_F1_wt <-(F1_g_tt$estimate[2])

p_g_tt_p <- p_g_tt$p.value
r_g_tt_p <- r_g_tt$p.value


row_row <- cbind(class,prec,reca,F1,F1_g_tt_p, mean_F1_gp,mean_F1_wt, p_g_tt_p,r_g_tt_p)




sample(1:length(fb_wt$name),5)

##################################### # # # # # # # # # 3 #  # # # #




##############################################################################################





#chose best classifier and applied it over full dataset

##doing total count stuff
total_count_new_auto <- sum(superdf$count_new_auto)
total_count_theo <- sum(superdf$count_theo_hand)
total_count_hina <- sum(superdf$count_Hina_hand)

sum(final_blah$tp)
sum(final_blah$fp)
sum(sum(final_blah$tp) + sum(final_blah$fp))
sum(final_blah$fn)
