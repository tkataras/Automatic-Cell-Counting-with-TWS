##takes huge long Results file into counts per image

fname <- "F:/Theo/iba_7_2020_autocount/working images/substack32_37/new training/random_quarters/training_6_16_2021/class9_all_wt_gp_count_masks/Results.csv"
big_r <- read.csv(fname)
head(big_r)
lv <- levels(as.factor(big_r$Label))
# lv == "test count 1.roi"

count <- NA
for (i in 1:length(lv)){
  count[i]<- sum(big_r$Label == lv[i])
  
}
 final <- data.frame(cbind(lv, count))
 
 final$count <- as.numeric(final$count)
 str(final$count)
 
genof <- c("gp","gp","gp","gp","gp","gp","gp", "wt", "wt","wt", "wt","wt", "wt","wt", "wt")
final2 <- cbind(final,genof)

t.test(final2$count ~ final2$genof)
boxplot(final2$count ~ final2$genof)

setwd("F:/Theo/iba_7_2020_autocount/working images/substack32_37/substack sub max project 32_37 roi blobs too/") 
##splitting off the .csv and adding annotation to name
fname2 <- strsplit(fname, "/")
fname3 <- tail(fname2[[1]], 1)
fname4 <- strsplit(fname3, "\\.")
fname5 <- fname4[[1]][1]
fname6 <- paste(fname5, sep = "_","summed.csv")
##setwd("F:/Theo/iba_7_2020_autocount/working images/Theo_hand_count_extra/")
write.csv(final, fname6) 
getwd()



####looking at the numbers by genoype/sex(need to assign geno in excel currently)###

df <- read.csv("F:/Theo/iba_7_2020_autocount/working images/substack32_37/substack sub max project 32_37 roi blobs too results/Results_full_dataset_6_21_2021_summed.csv")

df2 <- df[df$geno == "wt" | df$geno == "gp",]

t.test(df2$count ~ df2$geno)
t.test(df2$count ~ df2$sex)
#t.test(df$count[df$geno == "wt"] ~ df$count[df$geno == "gp"])

#reordering the gonotypes for the boxplot
df$geno <- factor(df$geno , levels=c("wt", "gp"))


X11()
boxplot(df$count ~ df$geno)
stripchart(df$count ~ df$geno, vertical = TRUE, 
           method = "jitter", add = TRUE, pch = 20, col = 'blue')
X11()
boxplot(df$count ~ df$sex)
stripchart(df$count ~ df$sex, vertical = TRUE, 
           method = "jitter", add = TRUE, pch = 20, col = 'blue')


test <- aov(df$count ~ df$geno)
summary(test)


sum(c(as.numeric(df$count)))


#trying averaging across mult fields from the same slice
df3 <- data.frame(id1_df_squish_for_stats)
cbind(df3$id1_df_squish, df$lv)

df3_as <- NA
for (i in 1:length(sid1)) {
  df3_as[i] <- paste0(c(df3$newsid1_anum[i], df3$newsid1_snum[i]), sep = "_", collapse = "")  
}
length(df3_as)


count_as <- NA
i = 7
lv2 <- levels(as.factor(df3_as))
for (i in 1:length(lv2)){
  count_as[i]<- sum(df$count[df3_as == levels(as.factor(df3_as))[i]])/sum(df3_as == levels(as.factor(df3_as))[i])
  
}

count_by_as <- data.frame(cbind(lv2, count_as))

i = 5
for (i in 1:length(lv2)) {
  count_by_as$geno[i] = as.character(df$geno[df3_as == lv2[i]][1])
}
head(count_by_as)

### count_by_as = the count avered across slices 
X11()
count_by_as$geno <- factor(count_by_as$geno , levels=c("wt", "gp", "ko", "kogp"))
boxplot(as.numeric(count_by_as$count_as) ~ count_by_as$geno)
stripchart(as.numeric(count_by_as$count_as) ~ count_by_as$geno, vertical = TRUE, 
           method = "jitter", add = TRUE, pch = 20, col = 'blue')
test <- aov(df$count ~ df$geno)
summary(test)

t.test(as.numeric(count_by_as$count_as[count_by_as$geno == "gp"]),as.numeric(count_by_as$count_as[count_by_as$geno == "kogp"]))

### now going to average slices across animal



count_a <- NA
i = 7
lv3 <- levels(as.factor(df3$newsid1_anum))
for (i in 1:length(lv3)){
  count_a[i]<- sum(df$count[df3$newsid1_anum == levels(as.factor(df3$newsid1_anum))[i]])/sum(df3$newsid1_anum == levels(as.factor(df3$newsid1_anum))[i])
  
}

count_by_a <- data.frame(cbind(lv3, count_a))

for (i in 1:length(lv3)) {
  count_by_a$geno[i] = as.character(df$geno[df3$newsid1_anum == lv3[i]][1])
}
count_by_a$geno <- factor(count_by_a$geno , levels=c("wt", "gp", "ko", "kogp"))

X11()
boxplot(as.numeric(count_by_a$count_a) ~ count_by_a$geno)
stripchart(as.numeric(count_by_a$count_a) ~ count_by_a$geno, vertical = TRUE, 
           method = "jitter", add = TRUE, pch = 20, col = 'blue')






### doing the results process from the true count

##adding in the results of the true count from classifier data
input <- "F:/Theo/iba_7_2020_autocount/working images/substack32_37/new training/random_quarters/new_male_only_6_24/classifiers wt/class4_ful_dataset_counted/Results.csv"
dftc_ini <- read.csv(input)
### adding in the results of the hand count from roi and processing data from hand roi to count
hand_ini <- read.csv("F:/Theo/iba_7_2020_autocount/working images/substack32_37/new training/random_quarters/new_male_only_6_24/Results hand full roi 7_6_2021.csv")
#extra <- read.csv("F:/Theo/iba_7_2020_autocount/working images/substack32_37/holder_folder/Results.csv")
class <- "class4"


dim(dftc_ini)
dim(hand_ini)

lv <- levels(as.factor(hand_ini$Label))
count <- NA
for (i in 1:length(lv)){
  count[i]<- sum(hand_ini$Label == lv[i])
  
}
final <- data.frame(cbind(lv, count))
final$count <- as.numeric(final$count)
# 
# # write.csv(final, "F:/Theo/iba_7_2020_autocount/working images/substack32_37/substack sub max project 32_37 roi blobs too results/Results_full_dataset_6_21_2021_summed.csv")
# # 
# lucky2 <- read.csv( "F:/Theo/iba_7_2020_autocount/working images/substack32_37/substack sub max project 32_37 roi blobs too results/Results_full_dataset_6_21_2021_summed.csv")
# # lucky
# t.test(lucky2$count ~ lucky2$geno)
# t.test(lucky2$count ~ lucky2$sex)

# final <- rbind(final, extra)
#
# final <- read.csv("C:/Users/User/Downloads/final_extra_4.csv")
# final
#t.test(final$count ~ final$sex)
# final_m <- final[final$sex == "f",]
# t.test(final_m$count ~ final_m$geno)


# ### finding size range of fp cells, blobs without markers
# 
#  miss <- dftc_ini$Area[dftc_ini$points == 0]
#  sum(dftc_ini$points == 0)
#  
#  hit <- dftc_ini$Area[dftc_ini$points == 1]
#  sum(dftc_ini$points == 1)
# mean(miss)
# sd(miss)
# mean(hit)
# sd(hit)
# boxplot(cbind(hit,miss))
# 
# sum(dftc_ini$points[dftc_ini$Area > 75])
# sum(dftc_ini$points == 0 & dftc_ini$Area > 75)
# 
# 
# 
# dftc_ini <- dftc_ini[dftc_ini$Area > 75,]
# 
# 






##biig if else loop baby!

##from levels present in the calssifier results output
img_names <- levels(as.factor(dftc_ini$Label))
#have to initialize, i think
final_blah <- data.frame(name = NA, tp = NA, fp = NA, fn= NA)
######SIZE RESCTRICTING
print(min(dftc_ini$Area))
dftc_ini <



for (i in 1:length(img_names)) {

current_img <- img_names[i]
dftc<- NA
dftc <- dftc_ini[dftc_ini$Label == current_img,]


  

fp = 0
tp = 0
fn = 0
#i = 5
for (j in 1:length(dftc$points)) {
  if (dftc$points[j] == 0){fp = fp +1}
  else if (dftc$points[j] == 1){tp = tp +1}
  else {
  tp = tp+1
  fn = fn + dftc$points[j] - 1
  }
}
#for each image add total number hand count - sum(dftc$points), the sum points must always be less than final$count b/c points =
##only the markers that fall within cell objects, final$counts is the sum of all points in total. 
#when this is not true(eg there are negative values) check the image names of the hand count!!
missed <- final$count[i] - sum(dftc$points)
fn <- fn + missed
name <- img_names[i]
this_row <- cbind(name, tp, fp, fn) 
final_blah <-rbind(final_blah, this_row)

}
final_blah <- final_blah[-1,]
##need to calculate Precision and recall

tot_tp <- sum(as.numeric(final_blah$tp))
tot_fp <- sum(as.numeric(final_blah$fp))
tot_fn <- sum(as.numeric(final_blah$fn))
# 
# 
# # 
# #####looking at prec and recall for geno
#  #WT
# tot_tp <- sum(as.numeric(final_blah2$tp[final_blah2$geno == "wt"]))
# tot_fp <- sum(as.numeric(final_blah2$fp[final_blah2$geno == "wt"]))
# tot_fn <- sum(as.numeric(final_blah2$fn[final_blah2$geno == "wt"]))
# 
# #GP
# tot_tp <- sum(as.numeric(final_blah2$tp[final_blah2$geno == "gp"]))
# tot_fp <- sum(as.numeric(final_blah2$fp[final_blah2$geno == "gp"]))
# tot_fn <- sum(as.numeric(final_blah2$fn[final_blah2$geno == "gp"]))

#precision is tp/(tp + fp)

prec <- tot_tp/(tot_tp + tot_fp)
#recall is tp/(tp + fn)
reca <- tot_tp/(tot_tp + tot_fn)

F1 <- 2*(prec*reca/(prec + reca))


prec <- round(prec, 4)
reca <- round(reca, 4)
F1 <- round(F1, 4)

print(paste("precision = ", prec ))
print(paste("recall = ", reca ))
print(paste("F1 = ", F1 ))

ip <- strsplit(input,"/")

ip2 <- ip[[1]][-length(ip[[1]])]
ip3 <- paste(ip2, collapse = "/")
ip4 <- paste(c(ip3,"/",class,"final.csv"), collapse = "")


write.csv(final_blah, ip4 )


##############################################################################################

#out <- paste(input,"final_blah",class, ".csv")
#write.csv(final_blah,out)

# 
# table <- cbind(class,prec,reca,F1)
# #full_table <- c(NA,NA,NA,NA)
# full_table <- rbind(full_table,table)




###need to add the genotype and sex info, also the final auto count from tp+fp, i do so in excell
#####this makes the table comparing all classifiers
your_boat <- NA
for (i in 1:4){
# i = 4
class_dir <- ("F:/Theo/iba_7_2020_autocount/working images/substack32_37/new training/random_quarters/new_male_only_6_24/classifiers_wt/")
output_dir <- paste(c(class_dir,"class", i,"_counted/"), collapse = "")
input_file <- paste(c("class",i,"final.csv"), collapse = "")
combo <- paste(c(output_dir,input_file), collapse = "")

###the part above works for using a regular expression to iterate through all the folders with classifiers
#the important part here is for final+blah2 to be the final table with geno info added

#final_blah2 <- read.csv(combo)

final_blah2 <- read.csv("F:/Theo/iba_7_2020_autocount/working images/substack32_37/new training/random_quarters/new_male_only_6_24/output/class3_counted_minsize_20/class3final_geno.csv")
final_blah3 <- final_blah2

final_only_wt <- final_blah3[final_blah3$geno == "wt",]
final_only_gp <- final_blah_mgp3[final_blah_mgp3$geno == "gp",]

final_blah3 <- final_only_gp

# final_blah2$tp
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



F1_s_tt$estimate




###doing a test with two diff classifiers data, wt data from full traiing set, gp data from gp only
#final_blah#








## count analysis

##final itself is the hand counts
hand_count <- final$count
final_blah3 <- cbind(final_blah3,hand_count)
names(final_blah3)
#names(final_blah3)[11] <- "hand_count"  ###this will change based on the number of columns in the data*(currently assumes you added geno and sex)
auto_count <- final_blah3$tp + final_blah3$fp
final_blah3 <- cbind(final_blah3,  auto_count) 


me_h_wt <- mean(final_blah3$hand_count[final_blah3$geno == "wt"])
sd_h_wt <- sd(final_blah3$hand_count[final_blah3$geno == "wt"])

me_h_gp <- mean(final_blah3$hand_count[final_blah3$geno == "gp"])
sd_h_gp <- sd(final_blah3$hand_count[final_blah3$geno == "gp"])

me_a_wt <- mean(final_blah3$auto_count[final_blah3$geno == "wt"])
sd_a_wt <- sd(final_blah3$auto_count[final_blah3$geno == "wt"])

me_a_gp <- mean(final_blah3$auto_count[final_blah3$geno == "gp"])
sd_a_gp <- sd(final_blah3$auto_count[final_blah3$geno == "gp"])

t.test(final_blah3$auto_count ~ final_blah3$geno)
t.test(final_blah3$hand_count ~ final_blah3$geno)

t.test(final_blah3$hand_count[final_blah3$geno == "wt"],final_blah3$auto_count[final_blah3$geno == "wt"])
t.test(final_blah3$hand_count[final_blah3$geno == "gp"],final_blah3$auto_count[final_blah3$geno == "gp"])

var.test(final_blah3$hand_count[final_blah3$geno == "wt"], final_blah3$auto_count[final_blah3$geno == "wt"])
var.test(final_blah3$hand_count[final_blah3$geno == "gp"], final_blah3$auto_count[final_blah3$geno == "gp"])





###doing a test with two diff classifiers data, wt data from full traiing set, gp data from gp only
auto_wt_only <- final_blah3$auto_count[final_blah3$geno == "wt"]
auto_gp_only <- final_blah_mgp3$auto_count[final_blah_mgp3$geno == "gp"]
combo_auto <- c(auto_gp_only,auto_wt_only)
t.test(combo_auto ~ final_blah3$geno)
t.test(final_blah3$hand_count ~ final_blah3$geno)


boxplot(combo_auto ~ final_blah3$geno)
stripchart(as.numeric(combo_auto) ~ final_blah3$geno, vertical = TRUE,
           method = "jitter", add = TRUE, pch = 20, col = 'blue')




# ## doubl echakcing my overall auto count
# 
# lv <- levels(as.factor(dftc_ini$Label))
# # lv == "test count 1.roi"
# 
# a_count <- NA
# for (i in 1:length(lv)){
#   a_count[i]<- sum(dftc_ini$Label == lv[i])
#   
# }
# a_final <- data.frame(cbind(lv, a_count))
# final_blah2$auto_count
# a_final$a_count <- as.numeric(a_final$a_count)
# str(final$count)

#X11()
boxplot(final_blah3$auto_count ~ final_blah3$geno)
stripchart(as.numeric(final_blah3$auto_count) ~ final_blah3$geno, vertical = TRUE,
           method = "jitter", add = TRUE, pch = 20, col = 'blue')


stripchart(as.numeric(final_blah3$auto_count)[final_blah3$sex == "f"] ~ final_blah3$geno[final_blah3$sex == "f"], vertical = TRUE,
           method = "jitter", add = TRUE, pch = 20, col = 'blue')
stripchart(as.numeric(final_blah3$auto_count)[final_blah3$sex == "m"] ~ final_blah3$geno[final_blah3$sex == "m"], vertical = TRUE,
           method = "jitter", add = TRUE, pch = 20, col = 'red')


#X11()
boxplot(final_blah3$hand_count ~ final_blah3$geno)
stripchart(as.numeric(final_blah3$hand_count) ~ final_blah3$geno, vertical = TRUE,
           method = "jitter", add = TRUE, pch = 20, col = 'blue')


stripchart(as.numeric(final_blah3$hand_count)[final_blah3$sex == "f"] ~ final_blah3$geno[final_blah3$sex == "f"], vertical = TRUE,
           method = "jitter", add = TRUE, pch = 20, col = 'blue')
stripchart(as.numeric(final_blah3$hand_count)[final_blah3$sex == "m"] ~ final_blah3$geno[final_blah3$sex == "m"], vertical = TRUE,
           method = "jitter", add = TRUE, pch = 20, col = 'red')


###testing only
final
final_blah3$name

t.test(final$count ~final_blah3$geno)
t.test(final_blah3$auto_count ~final_blah3$geno)

####


boxplot(final_blah3$auto_count ~ final_blah3$sex)
stripchart(as.numeric(final_blah3$auto_count)[final_blah3$geno == "wt"] ~ final_blah3$sex[final_blah3$geno == "wt"], vertical = TRUE,
           method = "jitter", add = TRUE, pch = 20, col = 'blue')
stripchart(as.numeric(final_blah3$auto_count)[final_blah3$geno == "gp"] ~ final_blah3$sex[final_blah3$geno == "gp"], vertical = TRUE,
           method = "jitter", add = TRUE, pch = 20, col = 'red')

t.test(final_blah3$prec2 ~ final_blah3$sex)

boxplot(final_blah3$prec2 ~ final_blah3$sex)
stripchart(as.numeric(final_blah3$prec2) ~ final_blah3$sex, vertical = TRUE,
           method = "jitter", add = TRUE, pch = 20, col = 'blue')

boxplot(final_blah3$F1_2 ~ final_blah3$geno)
stripchart(as.numeric(final_blah3$F1_2)[final_blah3$sex == "f"] ~ final_blah3$geno[final_blah3$sex == "f"], vertical = TRUE,
           method = "jitter", add = TRUE, pch = 20, col = 'blue')
stripchart(as.numeric(final_blah3$F1_2)[final_blah3$sex == "m"] ~ final_blah3$geno[final_blah3$sex == "m"], vertical = TRUE,
           method = "jitter", add = TRUE, pch = 20, col = 'red')


####making the mean and sd plot




df1 <- cbind(c("wt","wt", "gp", "gp"), c("hand", "auto", "hand", "auto"), as.numeric(c(me_h_wt,me_a_wt,me_h_gp,me_a_gp)), as.numeric(c(sd_h_wt,sd_a_wt,sd_h_gp,sd_a_gp)) )
df1 <- data.frame(df1)
names(df1) <-c("Genotype", "Count", "mean", "sd")
df1
str(df1)
df1$mean <-as.numeric(df1$mean)
df1$sd <-as.numeric(df1$sd)

# df1$Genotype <- factor(df1$Genotype, levels = c("gp", "gp", "wt", "wt"))
#                        
# tips2$day <- factor(tips2$day,levels = c("Fri", "Sat", "Sun", "Thur"))


df1$Genotype <- factor(df1$Genotype, levels = c("wt", "gp"))

#library(ggplot2)
X11()
ggplot(df1, aes(x=as.factor(Genotype), y=mean, fill=Count)) +
  geom_bar(position=position_dodge(), stat="identity", colour='black') +
  geom_errorbar(aes(ymin=mean-sd, ymax=mean+sd), width=.2,position=position_dodge(.9)) +
  scale_fill_brewer(palette="Paired") +
  theme(axis.text.y = element_text(size = 15))









#library(ggplot2)
X11()
ggplot(df1, aes(x=as.factor(Genotype), y=mean, fill=Count)) +
  geom_bar(position=position_dodge(), stat="identity", colour='black') +
  geom_errorbar(aes(ymin=mean-sd, ymax=mean+sd), width=.2,position=position_dodge(.9))




###making the mead and sd count plot AGAIN



###making the prec and recall bar plot

df2 <-  cbind(c("wt","wt", "gp", "gp"), c("hand", "auto", "hand", "auto"), as.numeric(c(wt_prec_m, wt_reca_m, gp_prec_m,gp_reca_m)), as.numeric(c(wt_prec_sd,wt_reca_sd,gp_prec_sd,gp_reca_sd)) )
df2 <- data.frame(df2)
names(df2) <-c("Genotype", "measurement", "mean", "sd")
df2$mean <-as.numeric(df2$mean)
df2$sd <-as.numeric(df2$sd)
df2  


df2$Genotype <- factor(df2$Genotype, levels = c("wt", "gp"))

#library(ggplot2)
X11()
ggplot(df2, aes(x=as.factor(Genotype), y=mean, fill=measurement)) +
  geom_bar(position=position_dodge(), stat="identity", colour='black') +
  geom_errorbar(aes(ymin=mean-sd, ymax=mean+sd), width=.2,position=position_dodge(.9)) +
  scale_fill_brewer(palette="Paired") +
  theme(axis.text.y = element_text(size = 15))







###doing crossectioal analysis with geno and sex via anova

two.way <- aov(final_blah3$F1_2 ~ final_blah3$geno + final_blah3$sex)

summary(two.way)

two.way.int <- aov(final_blah3$F1_2 ~ final_blah3$geno * final_blah3$sex)

summary(two.way.int)








### making corr plots
X11()
plot(final_blah3$hand_count[final_blah3$geno == "wt"],final_blah3$auto_count[final_blah3$geno == "wt"])
X11()
plot(final_blah3$hand_count[final_blah3$geno == "gp"],final_blah3$auto_count[final_blah3$geno == "gp"])


WT = lm(final_blah3$hand_count[final_blah3$geno == "wt"] ~final_blah3$auto_count[final_blah3$geno == "wt"])
summary(WT)
X11()
plot((final_blah3$hand_count[final_blah3$geno == "wt"] ~final_blah3$auto_count[final_blah3$geno == "wt"]),  pch = 20, col = "gray" , cex = 2)#,ylim = c(50,250), xlim = c(50,250))
abline(lm(WT), lwd=2)

GP = lm(final_blah3$hand_count[final_blah3$geno == "gp"] ~final_blah3$auto_count[final_blah3$geno == "gp"])
summary(GP)
X11()
plot((final_blah3$hand_count[final_blah3$geno == "gp"]~final_blah3$auto_count[final_blah3$geno == "gp"]),  pch = 20, col = "gray" , cex = 2)#,ylim = c(50,250), xlim = c(50,250))
abline(lm(GP), lwd=2)



