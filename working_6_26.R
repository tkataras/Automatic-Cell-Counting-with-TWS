#######Indira count data


#hand counts by daniel
dan <- read.csv("E:/Theo/from_indira/J20_NeuN_count_for_csv.csv")

my_count <- read.csv("E:/Theo/from_indira/mintrainingSummary.csv")
head(dan)
head(my_count)

head(dan[order(dan$Slide_Slide2),])
dan_order <- dan[order(dan$Slide_Slide2),]

tail(my_count)
tail(dan_order)


dan_diff <- dan_order$NeuN - my_count$Count
plot(dan_order$NeuN ~ my_count$Count)

dim(na.omit(dan_order))

dan_names <- strsplit(as.character(dan_order$Slide_Slide2), split = " - ")
names <- dan_names
znames <- NA
zpos <- NA
for (i in 1:length(names)) {
  znames[i] <- names[[i]][1]
  #zpos[i] <- as.numeric(paste(strsplit(znames[i], split="")[[1]][6], strsplit(znames[i], split="")[[1]][7], sep = ""))
}

names <- my_count
znames2 <- NA
zpos2 <- NA
for (i in 1:length(names)) {
  znames2[i] <- names[i,]
  #zpos[i] <- as.numeric(paste(strsplit(znames[i], split="")[[1]][6], strsplit(znames[i], split="")[[1]][7], sep = ""))
}

for (i in 1:length(names)){
znames2c <- as.character(znames2[[i]])
}
test <- strsplit(znames2[[1]], split = " - ")






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



write.csv(dan_order, "./dan_order.csv")
getwd()


##full count with dan and my first auto count, one still missing from the auto count, but 
dan_with_min <- read.csv("E:/Theo/from_indira/J20_NeuN_count_for_csv_with_min_auto.csv")
head(dan_with_min)
lm_with_min <- lm(NeuN ~ Count, data = dan_with_min)
summary(lm_with_min)

dan_with_min[5,]

summary(dan_with_min$Count[dan_with_min$X.1 == "A"])
summary(dan_with_min$Count[dan_with_min$X.1 == "B"])


dan_no_na <- na.omit(dan_with_min[2:6])
lm(dan_no_na$Count[dan_with_min$X.1 == "A"] ~ dan_no_na$Count[dan_with_min$X.1 == "B"])

dan_with_min <- read.csv("E:/Theo/from_indira/J20_NeuN_count_for_csv_with_min_auto.csv")
model_min <- lm(dan_no_na$Count[dan_with_min$geno == "A"] ~ dan_no_na$Count[dan_with_min$geno == "B"])
summary(model_min)

plot(dan_no_na$Count[dan_with_min$geno == "A"] ~ dan_no_na$Count[dan_with_min$geno == "B"])


boxplot(mpg~cyl,data=mtcars, main="Car Milage Data", 
        xlab="Number of Cylinders", ylab="Miles Per Gallon")
]
library("ggpubr")
ggline(dan_with_min, x = "geno", y = "Count", point.color = "blue",
       add = c("mean_sd", "jitter", point.color = "blue"), 
       #order = c("ctrl", "trt1", "trt2"),
       ylab = "Count", xlab = "genotype")

t.test(dan_no_na$Count ~ dan_no_na$X.1)

t.test(dan_no_na$NeuN ~ dan_no_na$X.1)

ggline(dan_with_min, x = "geno", y = "NeuN", point.color = "blue",
       add = c("mean_sd", "jitter", point.color = "blue"), 
       #order = c("ctrl", "trt1", "trt2"),
       ylab = "Count", xlab = "genotype")

##########################6 27 2019
#dan first
t.test(dan_with_min$NeuN ~ dan_with_min$geno)
library("ggpubr")
ggline(dan_with_min, x = "geno", y = "NeuN", point.color = "blue",
       add = c("mean_sd", "jitter", point.color = "blue"), 
       #order = c("ctrl", "trt1", "trt2"),
       ylab = "Count", xlab = "genotype")

#now mine
t.test(dan_with_min$Count ~ dan_with_min$geno)
library("ggpubr")
ggline(dan_with_min, x = "geno", y = "Count", point.color = "blue",
       add = c("mean_sd", "jitter", point.color = "blue"), 
       #order = c("ctrl", "trt1", "trt2"),
       ylab = "Count", xlab = "genotype")


test <- aov(dan_with_min$NeuN ~ dan_with_min$geno)
summary(test)
tail(dan_with_min)

dan_diff <- dan_with_min$NeuN - dan_with_min$Count

dan_with_min[,6] <- dan_diff

t.test(dan_with_min$V6 ~ dan_with_min$geno)
plot()

ggline(dan_with_min, x = "geno", y = "V6", point.color = "blue",
       add = c("mean_sd", "jitter", point.color = "blue"), 
       #order = c("ctrl", "trt1", "trt2"),
       ylab = "Count_diff", xlab = "genotype")


