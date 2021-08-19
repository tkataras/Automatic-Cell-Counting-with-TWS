##takes huge long Results file into counts per image

fname <- "F:/Theo/iba_7_2020_autocount/working images/substack32_37/substack sub max project 32_37 roi blobs too/Results 5_21_2021.csv"
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

df <- read.csv("F:/Theo/iba_7_2020_autocount/working images/substack32_37/substack sub max project 32_37 roi blobs too/Results 5_21_2021_summed.csv")

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

##adding in the results of the true count
dftc_ini <- read.csv("F:/Theo/iba_7_2020_autocount/working images/substack32_37/validation/rand_quarters/roi_blobs_too/Results of true count on validation quarters with blobs.csv")
### adding in the results of the hand count from roi and processing data
hand_ini <- read.csv("F:/Theo/iba_7_2020_autocount/working images/substack32_37/new training/Results3.csv")
dim(dftc_ini)

lv <- levels(as.factor(hand_ini$Label))
count <- NA
for (i in 1:length(lv)){
  count[i]<- sum(hand_ini$Label == lv[i])
  
}
final <- data.frame(cbind(lv, count))
final$count <- as.numeric(final$count)


### finding size range of fp cells, blobs without markers

 miss <- dftc_ini$Area[dftc_ini$points == 0]
 sum(dftc_ini$points == 0)
 
 hit <- dftc_ini$Area[dftc_ini$points == 1]
 sum(dftc_ini$points == 1)
mean(miss)
sd(miss)
mean(hit)
sd(hit)
boxplot(cbind(hit,miss))

sum(dftc_ini$points[dftc_ini$Area > 75])
sum(dftc_ini$points == 0 & dftc_ini$Area > 75)



dftc_ini <- dftc_ini[dftc_ini$Area > 75,]



##biig if else loop baby!


img_names <- levels(as.factor(dftc_ini$Label))
#have to initialize, i think
final_blah <- data.frame(name = NA, tp = NA, fp = NA, fn= NA)

for (i in 1:length(img_names)) {

current_img <- img_names[i]
dftc <- dftc_ini[dftc_ini$Label == current_img,]


  

fp = 0
tp = 0
fn = 0

for (j in 1:length(dftc$points)) {
  if (dftc$points[j] == 0){fp = fp +1}
  else if (dftc$points[j] == 1){tp = tp +1}
  else {
  tp = tp+1
  fn = fn + dftc$points[j] - 1
  }
}
#for each image add total number hand count - sum(dftc$points)
missed <- final$count[i] - sum(dftc$points)
fn <- fn + missed
name <- img_names[i]
this_row <- cbind(name, tp, fp, fn) 
final_blah <-rbind( final_blah, this_row)

}
final_blah <- final_blah[-1,]
##need to calculate Precision and recall

tot_tp <- sum(as.numeric(final_blah$tp))
tot_fp <- sum(as.numeric(final_blah$fp))
tot_fn <- sum(as.numeric(final_blah$fn))

#precision is tp/(tp + fp)

prec <- tot_tp/(tot_tp + tot_fp)
prec <- round(prec, 4)
#recall is tp/(tp + fn)
reca <- tot_tp/(tot_tp + tot_fn)
reca <- round(reca, 4)

print(paste("precision = ", prec ))
print(paste("recall = ", reca ))
