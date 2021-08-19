
datain <- read.csv("E:/Theo/from_deepika/map2_neun_40x/343/counts_for_presentation.csv")
head(datain)
model1 <- lm(datain$hand_count ~ datain$true_pos)
summary(model1)
plot(datain$true_pos ~ datain$hand_count)
model2 <- lm(datain$hand_count ~ datain$auto_count_gb_hess_var_1_16)
summary(model2)
plot(datain$auto_count_gb_hess_var_1_16 ~ datain$hand_count)


datain2 <- read.csv("E:/Theo/from_deepika/map2_neun_40x/343/images/gb_hess_sobel_var_8bit/segment/bw/test/Summary counts.csv")
head(datain2)
plot(datain2$handcount ~ datain2$Count)
datain2$diff <- abs(datain2$handcount - datain2$Count)
plot(datain2$diff ~ datain2$Average.Size)
hist(datain2$diff)

datain3 <- read.csv("E:/Theo/from_deepika/map2_neun_40x/343/images/gb_hess_sobel_var_8bit/segment/bw/test/Results counts.csv")
head(datain3)
dim(datain3)
hist(datain3$Area,xlim=c(1000,3000), breaks = 100)
plot(datain3$Area)


datain <- read.csv("E:/Theo/from_deepika/map2_neun_40x/343/images/gb_hess_sobel_var_8bit/segment/bw/test/Results test all objects.csv")

#need to establish order consistantly for all variables, use the names eg"labels" "slice" 
fullautocount_order <- datain[order(datain$Label),]
head(datain_order)

#computes the counts based on the counts of each row of a certain label
#can manipulate parameters here, eg min size to 2000
cts <- summary(fullautocount_order)

cts_min_2000 <- summary(fullautocount_order$Label[fullautocount_order$Area >= 2000])
sum(test)
head(cts)
head(cts_min_2000)
as.numeric(cts - cts_min_2000)

cts_min_1500 <- summary(fullautocount_order$Label[fullautocount_order$Area >= 1500])


fullcount_h <- datain2[order(datain2$Slice),]
head(fullcount_h)
dim(fullautocount_order)

as.numeric(cts)


handfull <- cbind(fullcount_h, as.numeric(cts))
dim(handfull)

head(handfull)
handfull$Count - handfull$`as.numeric(cts)`

test <- rbind(cts_min_2000, fullcount_h$handcount)

handfull <- cbind(handfull, as.numeric(cts_min_2000))

plot(handfull$handcount ~ handfull$`as.numeric(cts)`)

plot(handfull$handcount ~ handfull$`as.numeric(cts_min_2000)`)

handfull <- cbind(handfull, as.numeric(cts_min_1500))

plot(handfull$handcount ~ handfull$`as.numeric(cts)`)
handfull$handcount - handfull$`as.numeric(cts)`
sum(abs(handfull$handcount - handfull$`as.numeric(cts)`))
plot(handfull$handcount ~ handfull$`as.numeric(cts_min_1500)`)
handfull$handcount - handfull$`as.numeric(cts_min_1500)`
sum(abs(handfull$handcount - handfull$`as.numeric(cts_min_1500)`))
handfull$handcount - handfull$`as.numeric(cts_min_2000)`
sum(abs(handfull$handcount - handfull$`as.numeric(cts_min_2000)`))
hist(handfull$handcount - handfull$`as.numeric(cts)`, main = "min size 1000", breaks = 7)
hist(handfull$handcount - handfull$`as.numeric(cts_min_1500)`, main = "min size 1500")
hist(handfull$handcount, main = "hand counts")


min_1000 <- handfull$handcount - handfull$`as.numeric(cts)`
min_1500 <- handfull$handcount - handfull$`as.numeric(cts_min_1500)`
min_2000 <- handfull$handcount - handfull$`as.numeric(cts_min_2000)`


frame1 <- rbind(min_1000, min_1500, min_2000)
row.names(frame1) <- c("min_1000", "min_1500", "min_2000")
dim(frame1)
frame1

avg_1000 <- mean(abs(min_1000))
avg_1500 <- mean(abs(min_1500))
avg_2000 <- mean(abs(min_2000))

total_hand_count <- handfull$handcount

miss_ratio <- sweep(frame1, 2, total_hand_count, `/`)
mean(abs(miss_ratio[1,]))
mean(abs(miss_ratio[2,]))
mean(abs(miss_ratio[3,]))

miss_ratio_abs <- sweep(abs(frame1), 2, total_hand_count, `/`)
mean(abs(miss_ratio_abs[1,]))
mean(abs(miss_ratio_abs[2,]))
mean(abs(miss_ratio_abs[3,]))

signif(miss_ratio_abs, 2)
boxplot(t(miss_ratio_abs))
boxplot(t(miss_ratio_abs[2:3,]))

test <- matrix(c(1,2,3,4,5,6), nrow = 2)
tes2 <- c(2,3,4)
test/tes2
sweep(test, 2, tes2, `/`)


cts_min_2000 <- summary(fullautocount_order$Label[fullautocount_order$Area >= 2000])

model_min_2000 <- lm( handfull$handcount ~ handfull$`as.numeric(cts_min_2000)`)
summary(model_min_2000)
plot(handfull$handcount ~ handfull$`as.numeric(cts_min_2000)`)




datain4 <- read.csv("E:/Theo/from_deepika/map2_neun_40x/new markers 5_21/Results for new markers 5_21.csv")

newhc_fullautocount_order <- datain4[order(datain4$Label),]
newhc_cts_min_2000 <- summary(newhc_fullautocount_order$Label[newhc_fullautocount_order$Area >= 2000])
summary(newhc_fullautocount_order$Label)

newhc <- read.csv("E:/Theo/from_deepika/map2_neun_40x/new markers 5_21/handcounts.csv")
names(newhc)
newhc_trim <- newhc[1:14,1:2]
newhc_trim_order <- newhc_trim[order(newhc_trim$image),]

newhc_trim_order[,2] - as.numeric(newhc_cts_min_2000[1:14])
lm_newhc <- lm(newhc_trim_order[,2] ~ as.numeric(newhc_cts_min_2000[1:14]))
summary(lm_newhc)
plot(newhc_trim_order[,2] ~ as.numeric(newhc_cts_min_2000[1:14]))


totalnew <- c(cts_min_2000,newhc_cts_min_2000[1:14])

hand_new <- c(handfull$handcount, newhc_trim_order$handcount)

length(totalnew)
length(hand_new)

hist(as.numeric(hand_new - totalnew))
boxplot(hand_new - totalnew)

new_total_lm <- lm(hand_new ~ totalnew)
summary(new_total_lm)
plot(totalnew ~hand_new)



handfull[handfull$Slice == "*HPC343 MAP2_NeuN_01042019_s45_C_F4 - C=1 z51*"]
handfull[as.character(handfull$Slice) == ".*"]

mean(abs(hand_new - totalnew)/hand_new)


datain5 <- read.csv("E:/Theo/from_deepika/map2_neun_40x/new markers 5_21/Results_combined_5_22.csv")

datain5_order <- datain5[order(datain5$Label),]

datain5_order_cts_min_2000 <- summary(datain5_order$Label[datain5_order$Area >= 2000])
length(datain5_order_cts_min_2000)

#hand_new <- c(handfull$handcount, newhc_trim_order$handcount)

hand_new2 <- handfull$handcount
names(hand_new2) <- handfull$Slice
hand_new22 <- hand_new2[order(names(hand_new2))]

hand_new3 <- newhc_trim_order$handcount
names(hand_new3) <- newhc_trim_order$image
hand_new33 <- hand_new3[order(names(hand_new3))]

hand_all31 <- c(hand_new22, hand_new33)
hand_all31_o <- hand_all31[order(names(hand_all31))]


write.csv(hand_all31_o, "comb_hand.csv")
write.csv(datain5_order_cts_min_2000, "comb_auto.csv")


datain_comb <- read.csv("C:/Users/User/Documents/comb_auto.csv")
lm_comb <- lm(datain_comb$auto ~ datain_comb$hand)
summary(lm_comb)
plot(datain_comb$auto ~ datain_comb$hand)
hist(datain_comb$auto - datain_comb$hand)
mean(abs(datain_comb$auto - datain_comb$hand)/hand_new)
mean(datain_comb$auto - datain_comb$hand)
mean(abs(datain_comb$auto - datain_comb$hand))





gb_hes_mp_sob_var_lap_ent_1_10 <- read.csv("E:/Theo/from_deepika/map2_neun_40x/all_marker_sets/gb_hes_mp_sob_var_lap_ent_1_10_seg/seg2_count/comb_hand_and_auto_count.csv")
head(gb_hes_mp_sob_var_lap_ent_1_10)

lm_recent <- lm(gb_hes_mp_sob_var_lap_ent_1_10$hand ~ gb_hes_mp_sob_var_lap_ent_1_10$gb_hes_mp_sob_var_lap_ent_1_10)
summary(lm_recent)

gb_hes_mp_sob_var_lap_ent_1_10$hand - gb_hes_mp_sob_var_lap_ent_1_10$gb_hes_mp_sob_var_lap_ent_1_10
plot(gb_hes_mp_sob_var_lap_ent_1_10$hand ~ gb_hes_mp_sob_var_lap_ent_1_10$gb_hes_mp_sob_var_lap_ent_1_10)

mean(abs(gb_hes_mp_sob_var_lap_ent_1_10$hand - gb_hes_mp_sob_var_lap_ent_1_10$gb_hes_mp_sob_var_lap_ent_1_10)/gb_hes_mp_sob_var_lap_ent_1_10$hand)

lm_recent2 <- lm(gb_hes_mp_sob_var_lap_ent_1_10$hand ~ gb_hes_mp_sob_var_lap_ent_1_10$GB_HESS_SOB_VAR)
summary(lm_recent2)




plot(gb_hes_mp_sob_var_lap_ent_1_10$hand ~ gb_hes_mp_sob_var_lap_ent_1_10$GB_HESS_SOB_VAR)



lm_recent3 <- lm(gb_hes_mp_sob_var_lap_ent_1_10$hand ~ gb_hes_mp_sob_var_lap_ent_1_10$first_gb_hess_var_sob_new_WS)
summary(lm_recent3)


gb_hes_mp_sob_var_lap_ent_1_10$diff_new_gb_hess <- as.numeric(gb_hes_mp_sob_var_lap_ent_1_10$hand - gb_hes_mp_sob_var_lap_ent_1_10$GB_HESS_SOB_VAR)

head(gb_hes_mp_sob_var_lap_ent_1_10)
gb_hes_mp_sob_var_lap_ent_1_10
levels(gb_hes_mp_sob_var_lap_ent_1_10$geno)

diff <- cbind(gb_hes_mp_sob
              _var_lap_ent_1_10$diff_new_gb_hess,
as.factor(gb_hes_mp_sob_var_lap_ent_1_10$geno))


test <- anova(as.factor(gb_hes_mp_sob_var_lap_ent_1_10$geno) ~ gb_hes_mp_sob_var_lap_ent_1_10$diff_new_gb_hess)
summary(test)

gb_hes_mp_sob_var_lap_ent_1_10$diff_gb_hes_mp_sob_var_lap_ent <- as.numeric(gb_hes_mp_sob_var_lap_ent_1_10$hand - gb_hes_mp_sob_var_lap_ent_1_10$gb_hes_mp_sob_var_lap_ent_1_10)

gb_hes_mp_sob_var_lap_ent_1_10$diff_gb_hes_mp_sob_var_lap_ent

diff2 <- cbind((gb_hes_mp_sob_var_lap_ent_1_10$geno), as.numeric(gb_hes_mp_sob_var_lap_ent_1_10$diff_gb_hes_mp_sob_var_lap_ent))
boxplot((diff2))

diffagain <- gb_hes_mp_sob_var_lap_ent_1_10$diff_gb_hes_mp_sob_var_lap_ent
names(diffagain) <- gb_hes_mp_sob_var_lap_ent_1_10$geno
boxplot(diffagain ~ gb_hes_mp_sob_var_lap_ent_1_10$geno)
plot(diffagain ~ gb_hes_mp_sob_var_lap_ent_1_10$geno) #for the fancy classifier
plot(gb_hes_mp_sob_var_lap_ent_1_10$diff_new_gb_hess ~ gb_hes_mp_sob_var_lap_ent_1_10$geno)

fancy <- lm(diffagain ~ gb_hes_mp_sob_var_lap_ent_1_10$geno)
summary(fancy)


#cool bar plot
install.packages("ggpubr")
library("ggpubr")
my_data <- gb_hes_mp_sob_var_lap_ent_1_10 
ggline(my_data, x = "geno", y = "diff_gb_hes_mp_sob_var_lap_ent", 
       add = c("mean_se", "jitter"), 
       #order = c("ctrl", "trt1", "trt2"),
       ylab = "diff_gb_hes_mp_sob_var_lap_ent", xlab = "genotype")

ggline(my_data, x = "geno", y = "diff_new_gb_hess", 
       add = c("mean_se", "jitter"), 
       #order = c("ctrl", "trt1", "trt2"),
       ylab = "diff_new_gb_hess", xlab = "genotype")



#trying to do anova with fancy
fancy_aov <- aov(diff_gb_hes_mp_sob_var_lap_ent ~ geno,data =  gb_hes_mp_sob_var_lap_ent_1_10)
summary(fancy_aov)

new_simple_aov <- aov(diff_new_gb_hess ~ geno,data =  gb_hes_mp_sob_var_lap_ent_1_10)
summary(new_simple_aov)

#compare 2 hand counts
handy <- lm(gb_hes_mp_sob_var_lap_ent_1_10$hand ~ gb_hes_mp_sob_var_lap_ent_1_10$hand2)
summary(handy)

gb_hes_mp_sob_var_lap_ent_1_10$diff_hand <- gb_hes_mp_sob_var_lap_ent_1_10$hand - gb_hes_mp_sob_var_lap_ent_1_10$hand2
my_data <- gb_hes_mp_sob_var_lap_ent_1_10 

ggline(my_data, x = "geno", y = "diff_hand", 
       add = c("mean_se", "jitter"), 
       #order = c("ctrl", "trt1", "trt2"),
       ylab = "diff_hand", xlab = "genotype")

handy_aov <- aov(hand2 ~ geno, data = gb_hes_mp_sob_var_lap_ent_1_10)
summary(handy_aov)


datain_full1 <- read.csv("E:/Theo/from_deepika/map2_neun_40x/GB_HESS_SOB_VAR_all_images/GB_HESS_SOB_VAR_Summary.csv")
head(datain_full1)

dim(datain_full1)

datain_full1[1,] <- as.character(datain_full1[1,]) 
### separating out the animals
only332 <- grep("*332",datain_full1[,1])
only345 <- grep("*345",datain_full1[,1])
only357 <- grep("*357",datain_full1[,1])
only343 <- grep("*343",datain_full1[,1])
only344 <- grep("*344",datain_full1[,1])
only348 <- grep("*348",datain_full1[,1])
only353 <- grep("*353",datain_full1[,1])
only382 <- grep("*382",datain_full1[,1])
only383 <- grep("*383",datain_full1[,1])
only338 <- grep("*338",datain_full1[,1])
only355 <- grep("*355",datain_full1[,1])
only358 <- grep("*358",datain_full1[,1])

#grouping animals into genotypes

geno_a <- c(only338, only355, only358)
geno_b <- c(only353, only382, only383)
geno_C <- c(only343, only344, only348)
geno_d <- c(only332, only345, only357)


#putting a genotypes variable into the dataset
datain_full1$geno <- NA
head(datain_full1)
datain_full1$geno[geno_a] <- "a"
datain_full1$geno[geno_b] <- "b"
datain_full1$geno[geno_C] <- "c"
datain_full1$geno[geno_d] <- "d"


ggline(datain_full1, x = "geno", y = "Count", point.color = "blue",
       add = c("mean_sd", "jitter", point.color = "blue"), 
       #order = c("ctrl", "trt1", "trt2"),
       ylab = "Count", xlab = "genotype")


full_aov <- aov(Count ~ geno,data =  datain_full1)
summary(full_aov)
TukeyHSD(full_aov)


####
datain_full1 <- read.csv("E:/Theo/from_deepika/map2_neun_40x/gb_hes_mp_sob_var_lap_ent_1_10_all_images/gb_hess_mp_sob_var_lap_ent_Summary.csv")
head(datain_full1)

dim(datain_full1)

#datain_full1[1,] <- as.character(datain_full1[1,]) 
### separating out the animals
only332 <- grep("*332",datain_full1[,1])
only345 <- grep("*345",datain_full1[,1])
only357 <- grep("*357",datain_full1[,1])
only343 <- grep("*343",datain_full1[,1])
only344 <- grep("*344",datain_full1[,1])
only348 <- grep("*348",datain_full1[,1])
only353 <- grep("*353",datain_full1[,1])
only382 <- grep("*382",datain_full1[,1])
only383 <- grep("*383",datain_full1[,1])
only338 <- grep("*338",datain_full1[,1])
only355 <- grep("*355",datain_full1[,1])
only358 <- grep("*358",datain_full1[,1])

#grouping animals into genotypes

geno_a <- c(only338, only355, only358)
geno_b <- c(only353, only382, only383)
geno_C <- c(only343, only344, only348)
geno_d <- c(only332, only345, only357)


#putting a genotypes variable into the dataset
datain_full1$geno <- NA
head(datain_full1)
datain_full1$geno[geno_a] <- "a"
datain_full1$geno[geno_b] <- "b"
datain_full1$geno[geno_C] <- "c"
datain_full1$geno[geno_d] <- "d"


ggline(datain_full1, x = "geno", y = "Count", point.color = "blue",
       add = c("mean_sd", "jitter", point.color = "blue"), 
       #order = c("ctrl", "trt1", "trt2"),
       ylab = "Count", xlab = "genotype")


full_aov <- aov(Count ~ geno,data =  datain_full1)
summary(full_aov)
TukeyHSD(full_aov)

summary(datain_full1$Count[datain_full1$geno == "a"])
summary(datain_full1$Count[datain_full1$geno == "b"])
summary(datain_full1$Count[datain_full1$geno == "c"])
summary(datain_full1$Count[datain_full1$geno == "d"])

####breaking up the names to make it workable

names <- strsplit(as.character(datain_full1$Slice), split = " - ")

znames <- NA
zpos <- NA
for (i in 1:length(names)) {
  znames[i] <- names[[i]][3]
  zpos[i] <- as.numeric(paste(strsplit(znames[i], split="")[[1]][6], strsplit(znames[i], split="")[[1]][7], sep = ""))
}

grep("z", znames[1], value = TRUE)
test <- strsplit(znames[1], split="")[[1]][6:7]



strsplit(as.character(names[[41]][1]),split = "HPC")


##animal desigantion
org_name <- NA
org_num <- NA
org_num_long <- NA
org_num_long2 <- NA
org_num_long3 <- NA
org_num_full <- NA

for (i in 1:length(names)) {
  org_name[i] <- names[[i]][2]
  org_num_long[i] <- strsplit(org_name[i], split="HPC")[[1]][2]
  org_num_long2 <-paste((strsplit(org_num_long[i], split = ""))[[1]][1:3],sep="")
  org_num_long3 <- paste(org_num_long2[1], org_num_long2[2], sep = "")
  org_num_full[i] <- (paste(org_num_long3, org_num_long2[3], sep=""))
}

org_num_long3 <- paste(org_num_long2[1], org_num_long2[2], sep = "")
org_num_long4 <- (paste(org_num_long3, org_num_long2[3], sep=""))


####field of view, section
info_list <- NA
info_list_full <- NA
i = 5
for(i in 1:length(names)){
info_list <- strsplit(org_name[i], split = "_")
info_list_full[[1]][i] <- list(unlist(info_list))
}

slicenum <- NA
for(i in 1:length(names)){
holding <- info_list_full[[1]][i]
slicenum[i] <- holding[[1]][4]
}

Fnum <- NA
for(i in 1:length(names)){
holding2 <- info_list_full[[1]][i]
Fnum[i] <- holding2[[1]][6]
}
Fnum <- as.character(Fnum)
Fnum[which(Fnum == "F1.CI")] <- as.character("F1") ###this is not working!!! need to change F1.CI to F1
Fnum <- as.factor(Fnum)

datain_full1 <- read.csv("E:/Theo/from_deepika/map2_neun_40x/GB_HESS_SOB_VAR_all_images/GB_HESS_SOB_VAR_Summary.csv")
datain_full1 <- cbind(datain_full1,org_num_full,slicenum,Fnum ,zpos)
head(datain_full1)
datain_full1$Fnum
hold1 <- NA
hold2 <- NA
hold3 <- NA
avg <- NA
frame <- NA
frame2 <- NA
#frame2 <- matrix(NA, nrow = 1, ncol = 4)
counter <- 1
i = 2
for (i in 1:length(levels(datain_full1$org_num_full))){
  hold1 <- datain_full1[which(as.character(datain_full1$org_num_full) == as.character(levels(datain_full1$org_num_full)[i])),]
  hold1 <- droplevels(hold1)
  for (j in 1:length(levels(hold1$slicenum))){
    hold2 <- hold1[which(hold1$slicenum == levels(hold1$slicenum)[j]),]
    hold2 <- droplevels(hold2)
    
    for (k in 1:length(levels(hold2$Fnum))){
      hold3 <- hold2[which(hold2$Fnum == levels(hold2$Fnum)[k]),]
      hold3 <- droplevels(hold3)
      avg <- mean(hold3$Count)
      
      frame <- c(as.character(hold3$org_num_full[1]), as.character(hold3$slicenum[1]), as.character(hold3$Fnum[1]), avg)
      frame2 <- rbind(frame2, frame)
      
    
    }}}

frame3 <- data.frame(frame2)
frame3 <- frame3[-1,]
frame3$X4 <- as.character(frame3$X4) 
frame3$X4 <- as.numeric(frame3$X4) 



frame3$geno <- NA


frame3$geno[frame3$X1 == "338" | frame3$X1 == "355" | frame3$X1 == "358" ] <- "KO_gp"
frame3$geno[frame3$X1 == "353" | frame3$X1 == "382" | frame3$X1 == "383" ] <- "KO"
frame3$geno[frame3$X1 == "343" | frame3$X1 == "344" | frame3$X1 == "348" ] <- "gp"
frame3$geno[frame3$X1 == "332" | frame3$X1 == "345" | frame3$X1 == "357" ] <- "WT"

is.na(frame3$geno)
avg_aov <- aov(X4 ~ geno, data = frame3)
summary(avg_aov)
TukeyHSD(avg_aov)


ggline(frame3, x = "geno", y = "X4", point.color = "blue",
       add = c("mean_sd", "jitter", point.color = "blue"), 
       #order = c("ctrl", "trt1", "trt2"),
       ylab = "Count", xlab = "genotype")















geno_a <- c(only338, only355, only358)
geno_b <- c(only353, only382, only383)
geno_C <- c(only343, only344, only348)
geno_d <- c(only332, only345, only357)


aov()

frame3$X4 <- as.numeric(frame3$X4)

str(frame3$X4)




head(frame3)


      
frame3 <- na.omit(frame2)
dim(frame3)
head(frame3)
tail(frame3)

frame4 <- data.frame(frame3)

test <- levels(datain_full1$org_num_full)
levels(frame4$X1) <- c(test)

head(frame4)
aov(frame3[])

levels(hold3$org_num_full)

length(na.omit(avg))
test <- na.omit(avg)
test2 <- test[1:length(test)]

group_by(datain_full1, datain_full1$org_num_full)

gb_hes_mp_sob_var_lap_ent_1_10 <- read.csv("E:/Theo/from_deepika/map2_neun_40x/all_marker_sets/gb_hes_mp_sob_var_lap_ent_1_10_seg/seg2_count/comb_hand_and_auto_count.csv")

datain_full1_diff <- as.numeric(gb_hes_mp_sob_var_lap_ent_1_10$hand - datain_full1$Count)

datain_full1_diff <- as.numeric(gb_hes_mp_sob_var_lap_ent_1_10$refined_hand - gb_hes_mp_sob_var_lap_ent_1_10$GB_HESS_SOB_VAR)

  
refinedlm <- lm(gb_hes_mp_sob_var_lap_ent_1_10$refined_hand ~ gb_hes_mp_sob_var_lap_ent_1_10$GB_HESS_SOB_VAR)
summary(refinedlm)  
  


#compare 2 hand counts

gb_hes_mp_sob_var_lap_ent_1_10$diff_hand_refined <- gb_hes_mp_sob_var_lap_ent_1_10$hand - gb_hes_mp_sob_var_lap_ent_1_10$refined_hand
my_data <- gb_hes_mp_sob_var_lap_ent_1_10 


X11()
ggline(my_data, x = "geno", y = "diff_hand_refined", 
       add = c("mean_se", "jitter"), 
       #order = c("ctrl", "trt1", "trt2"),
       ylab = "diff_hand", xlab = "genotype")

refined_diff_aov <- aov(diff_hand_refined ~ geno, data = my_data)
summary(refined_diff_aov)

my_data$geno

####compare 2 step to previous, new daniel count and min auto count
twostepcsv <- read.csv("E:/Theo/from_indira/J20_NeuN_count_for_csv_with_min_auto_added_2step.csv")
head(twostepcsv)
hist(twostepcsv$NeuN)
hist(twostepcsv$Count2)
summary(twostepcsv$Count2)
twostepmodel <- lm(twostepcsv$NeuN ~ twostepcsv$Count2)
summary(twostepmodel)
onestepmodel <- lm(twostepcsv$NeuN ~ twostepcsv$Count)
summary(onestepmodel)
comparestepmodel <- lm(twostepcsv$Count ~ twostepcsv$Count2)
summary(comparestepmodel)

twostepcsv$tstepdiff <- twostepcsv$NeuN - twostepcsv$Count2 
twostepaov <- aov(Count2 ~ geno, data = twostepcsv)
summary(twostepaov)
t.test(twostepcsv$Count2 ~ twostepcsv$geno)


X11()
ggline(twostepcsv, x = "geno", y = "Count2", 
       add = c("mean_sd", "jitter"), 
       #order = c("ctrl", "trt1", "trt2"),
       ylab = "count_auto", xlab = "genotype")


#two step difference from dan hand count assesment
twostepcsv$tstepdiff
twostep_diff_aov <- aov(tstepdiff ~ geno, data = twostepcsv)
summary(twostep_diff_aov)
t.test(twostepcsv$tstepdiff ~ twostepcsv$geno)

X11()
ggline(twostepcsv, x = "geno", y = "tstepdiff", 
       add = c("mean_sd", "jitter"), 
       #order = c("ctrl", "trt1", "trt2"),
       ylab = "diff_hand_2step", xlab = "genotype")



