#####morphology measrement from area rois

datainarea <- read.csv("F:/Theo/full_backup_3_23_2021/Kaul_lab_work/bin_general/Deepika_Neun/Results from val set area.csv")


head(datainarea$Label)

trim_names <- function(file_names, split = " - ", half = "front"){
  id1 <- file_names
  sid1 <- strsplit(id1, split)
  
  
  newsid1 <- NA
  for (i in 1:length(sid1)){
    if(half == "back") {newsid1 <- c(newsid1, tail(sid1[[i]],1))} 
    else if(half == "front") { newsid1 <- c(newsid1, head(sid1[[i]],1))} 
    else{print("half = front or back, please")
      break}
    
  }
  newsid1 <- newsid1[-1]
  
}
lab <- trim_names(datainarea$Label, split = "crop" ,half = "front" )
head(lab)
tail(lab)

head(datainarea)
dim(datainarea)

hist(datainarea$Area)
hist(datainarea$Mean)
hist(datainarea$StdDev)
hist(datainarea$Perim.)
hist(datainarea$Circ.)
hist(datainarea$AR)


chi

geno_a <- scan(file="F:/Theo/full_backup_3_23_2021/Kaul_lab_work/bin_general/Deepika_Neun/val_geno.txt", what='character')

geno_a1 <- paste0(geno_a, collapse = "")
geno_a2 <- strsplit(geno_a1, split = ",")
geno_a <- unlist(geno_a2)


lv_a <- levels(as.factor(lab))


cbind(lv_a, geno_a)
count_a <- NA
for (i in 1:length(lv_a)){
  count_a[i]<- sum(lab == lv_a[i])
  
}
hand_final_a <- data.frame(cbind(lv_a, count_a))
hand_final_a$count_a <- as.numeric(hand_final_a$count_a)


cbind(hand_final_a, geno_a)

# Vertical box plot
boxplot(as.numeric(hand_final_a$count_a) ~ as.character(geno_a))

# Points
stripchart(as.numeric(hand_final_a$count_a) ~ as.character(geno_a), vertical = T, add = T, pch = 19, method = "jitter")


##need to set object geno values 
geno_obj <- NA
for (i in 1:length(lab)){
geno_obj[i] <- geno_a[grep(lab[i], lv_a)]
}




# area
boxplot(as.numeric(datainarea$Area) ~ as.character(geno_obj))
stripchart(as.numeric(datainarea$Area) ~ as.character(geno_obj), vertical = T, add = T, pch = 19, method = "jitter")

t.test(as.numeric(datainarea$Area) ~ as.character(geno_obj))

#circ
boxplot(as.numeric(datainarea$Circ.) ~ as.character(geno_obj))
stripchart(as.numeric(datainarea$Circ.) ~ as.character(geno_obj), vertical = T, add = T, pch = 19, method = "jitter")

t.test(as.numeric(datainarea$Circ.) ~ as.character(geno_obj))



### the circ vs apsect ratio stat


#WT
plot(datainarea$AR[geno_obj == 'wt'] ~ datainarea$Circ.[geno_obj == 'wt'],ylim = c(0,8.5))
length(datainarea$AR[geno_obj == 'wt'])
sum(datainarea$AR[geno_obj == 'wt'] <= 1.5 & datainarea$Circ.[geno_obj == 'wt'] >= 0.9)
sum(datainarea$AR[geno_obj == 'wt'] <= 1.5 & datainarea$Circ.[geno_obj == 'wt'] >= 0.8)/length(datainarea$AR[geno_obj == 'wt'])

sum(datainarea$AR[geno_obj == 'wt'] <= 1.5 & datainarea$Circ.[geno_obj == 'wt'] >= 0.8)
#gp
plot(datainarea$AR[geno_obj == 'gp'] ~ datainarea$Circ.[geno_obj == 'gp'],ylim = c(0,8.5))
length(datainarea$AR[geno_obj == 'gp'])
sum(datainarea$AR[geno_obj == 'gp'] <= 1.5 & datainarea$Circ.[geno_obj == 'gp'] >= 0.9)
sum(datainarea$AR[geno_obj == 'gp'] <= 1.5 & datainarea$Circ.[geno_obj == 'gp'] >= 0.8)/length(datainarea$AR[geno_obj == 'gp'])

sum(datainarea$AR[geno_obj == 'gp'] <= 1.5 & datainarea$Circ.[geno_obj == 'gp'] >= 0.8)

abline(h = 1.5)
abline(v = .8)


sum(datain_mo_wt$AR <= 1.5)
sum(datain_mo_wt$Circ. >= 0.9)
sum(datain_mo_wt$AR <= 1.5 & datain_mo_wt$Circ. >= 0.9)
dim(datain_mo_wt)[1]
sum(datain_mo_wt$AR <= 1.5 & datain_mo_wt$Circ. >= 0.9)/dim(datain_mo_wt)[1]


#GP
plot(datain_mo_gp$AR ~ datain_mo_gp$Circ., ylim = c(0,8.5))
sum(datain_mo_gp$AR <= 1.5)
sum(datain_mo_gp$Circ. >= 0.9)
sum(datain_mo_gp$AR <= 1.5 & datain_mo_gp$Circ. >= 0.9)
dim(datain_mo_gp)[1]
sum(datain_mo_gp$AR <= 1.5 & datain_mo_gp$Circ. >= 0.9)/dim(datain_mo_gp)[1]


chisq.test( rbind( c(88,22),  c(70,5)))

