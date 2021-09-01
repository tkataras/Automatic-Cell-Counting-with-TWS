###Full data set process loop


hand_ini <- read.csv("F:/Theo/full_backup_3_23_2021/Kaul_lab_work/bin_general/Data/Full_dataset/Results_hand_roi_full_dataset_no_val_8_30_2021.csv")

##processing hand count roi to get count per image
lv_h <- levels(as.factor(hand_ini$Label))

count_h <- NA
for (i in 1:length(lv_h)){
  count_h[i]<- sum(hand_ini$Label == lv_h[i])
  
}
hand_final <- data.frame(cbind(lv_h, count_h))
hand_final$count_h <- as.numeric(hand_final$count_h)


counted_folder_dir <-"F:/Theo/full_backup_3_23_2021/Kaul_lab_work/bin_general/Data/Full_dataset/counted_no_min_size/"
setwd(counted_folder_dir)
class_list <- list.files()



prenums <- (strsplit(class_list,split = "class"))
# 
# nums <- unlist(lapply(prenums, function(x) x[2]))
# nums <- as.numeric(nums)

#for (f in 1:length(class_list)){
#f = 1 
class_loc <- paste(counted_folder_dir,class_list,"/Results.csv",sep = "")
class_results <- read.csv(class_loc)
class <- class_list



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



current_loc <- paste(counted_folder_dir,class,sep = "")
file_out_name <- paste(current_loc,"/",class,"_Final.csv",sep = "")
# write.csv(final_blah, file_out_name )

final_blah <- read.csv("F:/Theo/full_backup_3_23_2021/Kaul_lab_work/bin_general/Data/Full_dataset/counted2/class19/class19_Final.csv")



#need to add geno again
#going to do from file this time
##need to adapt this to command line


dim(final_blah)
geno <- read.csv("F:/Theo/full_backup_3_23_2021/Kaul_lab_work/bin_general/Data/Full_dataset/geno_full.csv")
final_blah$geno <- geno$x


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


stat_info <- cbind(prec,reca,F1,F1_g_tt_p, mean_F1_gp,mean_F1_wt, p_g_tt_p,r_g_tt_p)
rownames(stat_info) <-class
colnames(stat_info)<- c("Precision", "Recall", "F1", "F1_t.test_p_val.","Mean_F1_gp", "Mean_F1_wt", "Precision_geno_t.test", "Recall_geno_t.test")

write.csv(stat_info, paste0("Data/Full_dataset/stat_info_", class, ".csv"))



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



###doing the counts/mean density analysis
final_blah$hand_count <- hand_final$count_h

final_blah$auto_count <- final_blah$tp + final_blah$fp


file_out_name2 <- paste(current_loc,"/",class,"_Final_Full.csv",sep = "")

write.csv(final_blah, file_out_name2)

#read back in the file after area norm***
final_blah <- read.csv("F:/Theo/full_backup_3_23_2021/Kaul_lab_work/bin_general/Data/Full_dataset/Weka_Output_Counted/class19/class19_Final_Full.csv")



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


#count analysis

#*#*#*# now doing all stats from an updated superdf file located in new new train
superdf <- read.csv("F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/working_images/new_val_train_etc/superdf_no_val_area_adj_8_12.csv")
dim(superdf)
head(superdf)


superdf$count_new_auto <- final_blah$auto_count



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
t.test(superdf$count_theo_hand[superdf$geno == "gp"] , superdf$count_new_auto[superdf$geno == "gp"])# NS 0.5858


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
