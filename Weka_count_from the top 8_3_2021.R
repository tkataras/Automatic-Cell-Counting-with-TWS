#there is a significant time requirement to create the feature stack

##trainng has been done. all val images in 1 folder, all classifiers in another
#training images must have same bit depth (eg 8 bit, 16 bit)!!!!

#Reqs
#BiocManager::install("EBImage")
library("EBImage")
#install.packages("OpenImageR") ##dotn know if one or both is neccesary yet
library("OpenImageR")




##making folders ####

##set wd to where you want folders, later this should be like THE ORIGIN
getwd()
setwd("F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/working_images/new_val_train_etc/class_8bit_thresh_projected_counted/")

#the class number MUST go at the end of the file name with nothing after it for BSH script to order correctly

#getting the number of needed folder from # classifier.model files in folder with ONLY classifier.model files
n= length(dir("F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/working_images/new_val_train_etc/class_8bit/")) 
nm = "count_proj_thresh_masks_class"
for (i in 1:n){
  dir.create(paste(getwd(),"/",nm,i,sep = ""))
}



###now we need to apply each classifier to all val images and output segmentations in all class folders
## we do this with a BeanShell script interfacting with Weka without GUI
##F:\Theo\iba_7_2020_autocount\Hina_IFNBKO_pair\working_images\new_val_train_etc\test\BS_class_test.bsh

###need to threshold Weka imge outputs for this next step!!!

#now need to process the multi plane validation images
#will do this in R, but will need to regularize image names to project pairs and trios correctly.
#if you do not need this sort of image processing, this step in not neccessary

##getting images names

inputdir_all1 <-"F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/working_images/new_val_train_etc/validation/" 
inputdir_all <- dir(inputdir_all1)
id1 <- inputdir_all

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


newsid1 <- trim_names(id1)


id1_df_sep <- sep_slidebook(x = newsid1)


id1_df_squish <- squish(input_df = id1_df_sep)


big_df <- cbind(inputdir_all, id1_df_squish,id1_df_sep) ##specify: original file names, info columns, squished ID
colnames(big_df) <- c("file_name", "img_ID", "a_num","S_num", "F_num")
big_df <- data.frame(big_df) #this df gives us access to varibles based on the images in several forms

##now need to gather and project all items with matching img_ID 

##need to be working in images directory
id_for_dir <- "F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/working_images/new_val_train_etc/class_output_thresh/"
id_for_dir2 <- "F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/working_images/new_val_train_etc/class_8bit_thresh_projected/"
class_list_test <- dir(id_for_dir2)

class_list <- dir(id_for_dir)

length(class_list)

#class_list is in the wrong order compared to class order

prenums <- (strsplit(class_list,split = "class"))

nums <- unlist(lapply(prenums, function(x) x[2]))
nums <- as.numeric(nums)

u_img <- unique(big_df$img_ID)
length(u_img)

dim(big_df)



for (j in 1:length(class_list)){
  setwd(paste(id_for_dir,class_list[j], sep = ""))
  getwd()
  img_file_names <- list.files()
  
  out_loc <- "F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/working_images/new_val_train_etc/class_8bit_thresh_projected/"
  dir.create(paste(out_loc,"proj_thresh_masks_class",nums[j], sep = ""))


  
for (i in 1: length(u_img)){
  all_current_ID <- grep(u_img[i],big_df$img_ID)
  this_group <- img_file_names[all_current_ID]
  
  
  
  
  if (length(this_group) == 2){
    datain1 <- readImage(as.character(this_group[1]))
    datain2 <- readImage(as.character(this_group[2]))
    
    projected <- datain1 + datain2
    projected[projected >255] = 255
    
    file_out_loc <- paste(paste(out_loc,"proj_thresh_masks_class",nums[j], sep = ""),"/",this_group[1], sep = "")
    writeImage(projected,file_out_loc)
    
  } else if (length(this_group) == 3){
    datain1 <- readImage(as.character(this_group[1]))
    datain2 <- readImage(as.character(this_group[2]))
    datain3 <- readImage(as.character(this_group[3]))
    
    projected <- datain1 + datain2 +datain3
    projected[projected >255] = 255
    file_out_loc <- paste(paste(out_loc,"proj_thresh_masks_class",nums[j], sep = ""),"/",this_group[1], sep = "")
    writeImage(projected,file_out_loc)
    
    
  }else (print("we have a problem, this group had neither 2 nor 3 images"))
  
  
}
}




############################## now we have binary projected images to work with and need to compare to roi for each classifier
your_boat <- NA

##we use tru_count_over_dir_correct.ijm

  
###################now need to proces the results files

##need to run results_from_rio.ijm on the folder with the hand counts
### adding in the results of the hand count from roi, this will not change by folder
hand_ini <- read.csv("F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/working_images/Results_roi_after_Npt3_7_16_2021.csv")


#iterate through results folders, will save final output within
#setting working dir, needs to contain all counted output folders

### adding in the results of the hand_count_from_roi.ijm, this will not change by folder
hand_ini <- read.csv("F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/working_images/new_val_train_etc/Results_hand_roi_8_3_2021.csv")

##processing hand count roi to get count per image
lv_h <- levels(as.factor(hand_ini$Label))

count_h <- NA
for (i in 1:length(lv_h)){
  count_h[i]<- sum(hand_ini$Label == lv_h[i])
  
}
hand_final <- data.frame(cbind(lv_h, count_h))
hand_final$count_h <- as.numeric(hand_final$count_h)


counted_folder_dir <-"F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/working_images/new_val_train_etc/class_8bit_thresh_projected_counted/"
setwd(counted_folder_dir)
class_list <- list.files()


prenums <- (strsplit(class_list,split = "class"))

nums <- unlist(lapply(prenums, function(x) x[2]))
nums <- as.numeric(nums)

for (f in 1:length(folders_list)){
  class_loc <- paste(counted_folder_dir,folders_list[f],"/Results.csv",sep = "")
  class_results <- read.csv(class_loc)
  class <- paste("class",nums[f], sep = "")
  
  
  # 
  # lv <- levels(as.factor(class_results$Label))
  # 
  # count <- NA
  # for (i in 1:length(lv)){
  #   count[i]<- sum(class_results$Label == lv[i])
  #   
  # }
  # final <- data.frame(cbind(lv, count))
  # final$count <- as.numeric(final$count)
  # 
  # 
  # 
  
  ##biig if else loop baby!
  
  ##from levels present in the classifier results output, this should be the same each time
  img_names <- levels(as.factor(class_results$Label))
  #initialize data frame
  final_blah <- data.frame(name = NA, tp = NA, fp = NA, fn= NA)
  
  ###### can use this to check size restriction 
  #print(min(class_results$Area))
 
    
    
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

  
  
  current_loc <- paste(counted_folder_dir,folders_list[f],sep = "")
  file_out_name <- paste(current_loc,"/",class,"_Final.csv",sep = "")
  write.csv(final_blah, file_out_name )
  
  
  
  
  
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
  
  # 
  # 
  # 
  # wt_prec_m <- mean(final_blah$prec2[final_blah$geno == "wt"])
  # wt_prec_sd <-sd(final_blah$prec2[final_blah$geno == "wt"])
  # 
  # wt_reca_m <- mean(final_blah$reca2[final_blah$geno == "wt"])
  # wt_reca_sd <-sd(final_blah$reca2[final_blah$geno == "wt"])
  # 
  # 
  # 
  # 
  # 
  # gp_prec_m <- mean(final_blah$prec2[final_blah$geno == "gp"])
  # gp_prec_sd <- sd(final_blah$prec2[final_blah$geno == "gp"])
  # 
  # gp_reca_m <- mean(final_blah$reca2[final_blah$geno == "gp"])
  # gp_reca_sd <-sd(final_blah$reca2[final_blah$geno == "gp"])
  # 
  mean_F1_gp <-(F1_g_tt$estimate[1])
  mean_F1_wt <-(F1_g_tt$estimate[2])
  
  p_g_tt_p <- p_g_tt$p.value
  r_g_tt_p <- r_g_tt$p.value
  
  
  row_row <- cbind(class,prec,reca,F1,F1_g_tt_p, mean_F1_gp,mean_F1_wt, p_g_tt_p,r_g_tt_p)#F1_s_tt_p,mean_F1_m, mean_F1_f
  your_boat <- rbind(your_boat, row_row)
  
    
  
  
}#this is the bottom bracket of iterating through all the class folders




write.csv(your_boat, paste(counted_folder_dir,"/All_classifier_comparison.csv", sep = ""))






##################################### # # # # # # # # # 3 #  # # # #




##############################################################################################



# 
##all of this is to add geno to the validation data without using
# geno1 <- as.factor(c("gp","gp","gp","gp","gp", "wt","wt","wt","wt","wt"))
# geno <- geno1
# sex1 <- c("m","m","m","m","m","m","m","m", "m", "m")
# sex <- sex1
# #final_blah
# 
# 
#
# geno1 <- as.factor(c("gp","gp","gp","wt","wt","wt","gp","gp","gp","wt"))
# sex1 <- as.factor(c("m","m","m","m","m","m","f","f","f","f"))

#final_blah3 <- cbind(final_blah2,geno1, sex1)
#final_blah3 <- cbind(final_blah2,geno, sex)
final_blah3$tp <- as.numeric(final_blah3$tp)
final_blah3$fp <- as.numeric(final_blah3$fp)
final_blah3$fn <- as.numeric(final_blah3$fn)

#generating the full, summed accuracy measures
tot_tp <- sum(as.numeric(final_blah3$tp))
tot_fp <- sum(as.numeric(final_blah3$fp))
tot_fn <- sum(as.numeric(final_blah3$fn))

####looking at prec and recall for geno
#WT
tot_tp_wt <- sum(as.numeric(final_blah3$tp[final_blah3$geno == "wt"]))
tot_fp_wt <- sum(as.numeric(final_blah3$fp[final_blah3$geno == "wt"]))
tot_fn_wt <- sum(as.numeric(final_blah3$fn[final_blah3$geno == "wt"]))

#GP
tot_tp_gp <- sum(as.numeric(final_blah3$tp[final_blah3$geno == "gp"]))
tot_fp_gp <- sum(as.numeric(final_blah3$fp[final_blah3$geno == "gp"]))
tot_fn_gp <- sum(as.numeric(final_blah3$fn[final_blah3$geno == "gp"]))



#precision is tp/(tp + fp)

prec <- tot_tp/(tot_tp + tot_fp)
#recall is tp/(tp + fn)
reca <- tot_tp/(tot_tp + tot_fn)

F1 <- 2*(prec*reca/(prec + reca))

prec1 <- round(prec, 4)
reca1 <- round(reca, 4)
F1_1 <- round(F1, 4)

print(paste("precision = ", prec1 ))
print(paste("recall = ", reca1 ))
print(paste("F1 = ", F1_1 ))


# #just male/female
# final_blah3_m <- final_blah3[final_blah3$sex1 == "m",]
# dim(final_blah3_m)
# final_blah3_f <- final_blah3[final_blah3$sex1 == "f",]
# dim(final_blah3_f)

# prec2_m <- final_blah3_m$tp/(final_blah3_m$tp + final_blah3_m$fp)
# 
# reca2_m <-final_blah3_m$tp/(final_blah3_m$tp + final_blah3_m$fn)
# F1_2_m <- 2*(prec2_m*reca2_m/(prec2_m + reca2_m))

# t.test(final_blah2_m$auto_count ~ final_blah2_m$geno)
# t.test(final_blah2_m$hand_count ~ final_blah2_m$geno)
# sum(final_blah2_m$hand_count)
# t.test(final_blah2_m$prec2 ~ final_blah2_m$geno)
###final blah2 has geno and sex info later???????


#precision and recall per image?? run after the count analysis below
prec2 <- final_blah3$tp/(final_blah3$tp + final_blah3$fp)

reca2 <-final_blah3$tp/(final_blah3$tp + final_blah3$fn)
F1_2 <- 2*(prec2*reca2/(prec2 + reca2))

final_blah3 <- cbind(final_blah3, prec2)
final_blah3 <- cbind(final_blah3, reca2)
final_blah3 <- cbind(final_blah3, F1_2)


p_g_tt <- t.test(final_blah3$prec2 ~ final_blah3$geno)
r_g_tt <- t.test(final_blah3$reca2 ~ final_blah3$geno)
F1_g_tt <- t.test(final_blah3$F1_2 ~ final_blah3$geno)

# t.test(final_blah3$prec2 ~ final_blah3$sex)
# t.test(final_blah3$reca2 ~ final_blah3$sex)
# F1_s_tt <- t.test(final_blah3$F1_2 ~ final_blah3$sex)


wt_prec_m <- mean(final_blah3$prec2[final_blah3$geno == "wt"])
wt_prec_sd <-sd(final_blah3$prec2[final_blah3$geno == "wt"])

wt_reca_m <- mean(final_blah3$reca2[final_blah3$geno == "wt"])
wt_reca_sd <-sd(final_blah3$reca2[final_blah3$geno == "wt"])





gp_prec_m <- mean(final_blah3$prec2[final_blah3$geno == "gp"])
gp_prec_sd <- sd(final_blah3$prec2[final_blah3$geno == "gp"])

gp_reca_m <- mean(final_blah3$reca2[final_blah3$geno == "gp"])
gp_reca_sd <-sd(final_blah3$reca2[final_blah3$geno == "gp"])



##making bar chart for precision and recall


df2 <-  cbind(c("wt","wt", "gp", "gp"), c("precision", "recall", "precision", "recall"), as.numeric(c(wt_prec_m, wt_reca_m, gp_prec_m,gp_reca_m)), as.numeric(c(wt_prec_sd,wt_reca_sd,gp_prec_sd,gp_reca_sd)) )
df2 <- data.frame(df2)
names(df2) <-c("Genotype", "measurement", "mean", "sd")
df2$mean <-as.numeric(df2$mean)
df2$sd <-as.numeric(df2$sd)
df2  


df2$Genotype <- factor(df2$Genotype, levels = c("wt", "gp"))

# library(ggplot2)
X11()
ggplot(df2, aes(x=as.factor(Genotype), y=mean, fill=measurement)) +
  geom_bar(position=position_dodge(), stat="identity", colour='black') +
  geom_errorbar(aes(ymin=mean-sd, ymax=mean+sd), width=.2,position=position_dodge(.9)) +
  scale_fill_brewer(palette="Paired") +
  theme(axis.text.y = element_text(size = 15))

#write.csv(final_blah2, "F:/Theo/iba_7_2020_autocount/working images/substack32_37/graphs etc for poster/final_blah2.csv" )



#making the table of the accuracies
F1_g_tt_p <- F1_g_tt$p.value
#F1_s_tt_p <- F1_s_tt$p.value

#mean_F1_f <-(F1_s_tt$estimate[1])
#mean_F1_m <-(F1_s_tt$estimate[2])

mean_F1_gp <-(F1_g_tt$estimate[1])
mean_F1_wt <-(F1_g_tt$estimate[2])

p_g_tt_p <- p_g_tt$p.value
r_g_tt_p <- r_g_tt$p.value


row_row <- cbind(i,prec,reca,F1,F1_g_tt_p, mean_F1_gp,mean_F1_wt, p_g_tt_p,r_g_tt_p)#F1_s_tt_p,mean_F1_m, mean_F1_f
your_boat <- rbind(your_boat, row_row)
}




write.csv(your_boat, "F:/Theo/iba_7_2020_autocount/working images/substack32_37/new training/random_quarters/new_male_only_6_24/classifiers/accuracy_table_7_2_2021.csv")






