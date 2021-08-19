##hand cound vs auto count on Hina 2 image work for SFN
datain_hva <- read.csv("C:/Users/User/Desktop/Kaul_lab_work/crop_hc_vs_ac.csv")
X11()
plot(datain_hva$cropped_hand_count[datain_hva$geno == "WT"] ~ datain_hva$auto_count[datain_hva$geno == "WT"])



X11()
plot(datain_hva$cropped_hand_count[datain_hva$geno == "WT"] ~ datain_hva$auto_count[datain_hva$geno == "WT"])
lm1 <- lm(datain_hva$cropped_hand_count[datain_hva$geno == "WT"] ~ datain_hva$auto_count[datain_hva$geno == "WT"])
summary(lm1)


X11()
plot(datain_hva$cropped_hand_count[datain_hva$geno == "GP"] ~ datain_hva$auto_count[datain_hva$geno == "GP"])
lm1 <- lm(datain_hva$cropped_hand_count[datain_hva$geno == "GP"] ~ datain_hva$auto_count[datain_hva$geno == "GP"])
summary(lm1)

vt1 <- var.test(datain_hva$cropped_hand_count[datain_hva$geno == "WT"], datain_hva$cropped_hand_count[datain_hva$geno == "GP"])
vt2 <- var.test(datain_hva$auto_count[datain_hva$geno == "WT"], datain_hva$auto_count[datain_hva$geno == "GP"])


tt1 <- t.test(datain_hva$cropped_hand_count[datain_hva$geno == "WT"], datain_hva$cropped_hand_count[datain_hva$geno == "GP"])
tt1

tt2 <- t.test(datain_hva$auto_count[datain_hva$geno == "WT"], datain_hva$auto_count[datain_hva$geno == "GP"])
tt2



mean_hc <- mean(datain_hva$cropped_hand_count)
sd_hc <- sd(datain_hva$cropped_hand_count)

up_bound <- mean_hc + 2*sd_hc
low_bound <- mean_hc - 2*sd_hc
datain2 <- datain_hva[datain_hva$cropped_hand_count <= up_bound & datain_hva$cropped_hand_count >= low_bound,]

dim(datain_hva)
dim(datain2)

sum()


X11()
plot(datain2$cropped_hand_count[datain_hva$geno == "WT"] ~ datain2$auto_count[datain_hva$geno == "WT"])
lm1 <- lm(datain2$cropped_hand_count[datain_hva$geno == "WT"] ~ datain2$auto_count[datain_hva$geno == "WT"])
summary(lm1)

X11()
plot(datain2$cropped_hand_count[datain_hva$geno == "GP"] ~ datain2$auto_count[datain_hva$geno == "GP"])
lm1 <- lm(datain2$cropped_hand_count[datain_hva$geno == "GP"] ~ datain2$auto_count[datain_hva$geno == "GP"])
summary(lm1)



mean_ac <- mean(datain2$auto_count)
sd_ac <- sd(datain2$auto_count)

up_bound2 <- mean_ac + 2*sd_hc
low_bound2 <- mean_ac - 2*sd_hc
datain3 <- datain2[datain2$auto_count <= up_bound2 & datain2$auto_count >= low_bound2,]

dim(datain2)
dim(datain3)

X11()
plot(datain3$cropped_hand_count[datain_hva$geno == "WT"] ~ datain3$auto_count[datain_hva$geno == "WT"])
lm1 <- lm(datain3$cropped_hand_count[datain_hva$geno == "WT"] ~ datain3$auto_count[datain_hva$geno == "WT"])
summary(lm1)

X11()
plot(datain3$cropped_hand_count[datain_hva$geno == "GP"] ~ datain3$auto_count[datain_hva$geno == "GP"])
lm1 <- lm(datain3$cropped_hand_count[datain_hva$geno == "GP"] ~ datain3$auto_count[datain_hva$geno == "GP"])
summary(lm1)

####remocing the outliers from the auto count = very bad



###remove just the highest GP auto count

datain_hva[datain_hva$auto_count == max(datain_hva$auto_count) & datain_hva$geno == "GP",]
dataincheese1 <-  datain_hva[-35,]


max(datain_hva$auto_count)
max(dataincheese1$auto_count)
dim(datain_hva)
dim(dataincheese1)

X11()
plot(dataincheese1$cropped_hand_count[dataincheese1$geno == "WT"] ~ dataincheese1$auto_count[dataincheese1$geno == "WT"])
lm1 <- lm(dataincheese1$cropped_hand_count[dataincheese1$geno == "WT"] ~ dataincheese1$auto_count[dataincheese1$geno == "WT"])
summary(lm1)


X11()
plot(dataincheese1$cropped_hand_count[dataincheese1$geno == "GP"] ~ dataincheese1$auto_count[dataincheese1$geno == "GP"])
lm1 <- lm(dataincheese1$cropped_hand_count[dataincheese1$geno == "GP"] ~ dataincheese1$auto_count[dataincheese1$geno == "GP"])
summary(lm1)


###averging within samples

#37    GP Image: IFNBKO-428-S42-Iba-Syn-Cortex-10x-F4b  356.8805        357                150        114



datain3 <- datain_hva[-37,]
datain3 <- head(datain3)

indx <- ceiling(dim(datain3)[1]/3)
test<-NA
j = 1
for (i in 1:indx)
{
  test[i]<- mean(c(datain3$auto_count[j:(j+2)])) 
  j = j+2
}
test
mean(c(137, 118, 121))
datain3$cropped_hand_count[1:3]

avg_chc <- test
avg_ac <- test

X11()
plot(avg_chc ~ avg_ac)

lm_avg_all <- lm(avg_chc ~ avg_ac)
summary(lm_avg_all)



datain_all <- read.csv("C:/Users/User/Desktop/Kaul_lab_work/crop_hc_vs_ac.csv")
all <- lm(datain_all$cropped_hand_count ~ datain_all$auto_count)
summary(all)


difwt <- datain_hva$cropped_hand_count[datain_hva$geno == "WT"] - datain_hva$auto_count[datain_hva$geno == "WT"]
mean(difwt)
x11()
hist(difwt)

difgp <- datain_hva$cropped_hand_count[datain_hva$geno == "GP"] - datain_hva$auto_count[datain_hva$geno == "GP"]
mean(difgp)

x11()
hist(difgp)

