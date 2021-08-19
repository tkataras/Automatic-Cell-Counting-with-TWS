


datain <- read.csv("C:/Users/User/Desktop/Kaul_lab_work/auto_vs_hand_count_for_R.csv")


datain$X
plot(datain$Microglia[datain$X == "WT"] ~ datain$Count[datain$X == "WT"])

WT = lm(datain$Microglia[datain$X == "WT"] ~ datain$Count[datain$X == "WT"])
summary(WT)

WT = lm(datain$Microglia[datain$X == "WT"] ~ datain$Count[datain$X == "WT"])
summary(WT)

plot(datain$Microglia[datain$X == "GP"] ~ datain$Count[datain$X == "GP"])

GP = lm(datain$Microglia[datain$X == "GP"] ~ datain$Count[datain$X == "GP"])
summary(GP)



plot(datain$Microglia[datain$X == "KO"] ~ datain$Count[datain$X == "KO"])

KO = lm(datain$Microglia[datain$X == "KO"] ~ datain$Count[datain$X == "KO"])
summary(KO)


####real stuff down here


WT = lm(datain$Microglia[datain$X == "WT"] ~ datain$Count[datain$X == "WT"])
summary(WT)

plot(datain$Microglia[datain$X == "WT"] ~ datain$Count[datain$X == "WT"],  pch = 20, col = "gray" , cex = 2,ylim = c(220,400), xlim = c(70,230))


abline(lm(WT), lwd=2)




GP = lm(datain$Microglia[datain$X == "GP"] ~ datain$Count[datain$X == "GP"])
summary(GP)

plot(datain$Microglia[datain$X == "GP"] ~ datain$Count[datain$X == "GP"],  pch = 20, col = "gray" , cex = 2,ylim = c(220,400), xlim = c(70,230))


abline(lm(GP), lwd=2)



KO = lm(datain$Microglia[datain$X == "KO"] ~ datain$Count[datain$X == "KO"])
summary(KO)

plot(datain$Microglia[datain$X == "KO"] ~ datain$Count[datain$X == "KO"],  pch = 20, col = "gray" , cex = 2)


abline(lm(KO), lwd=2)


#ko no lower outlier
dim(datain)
datain_no_min <- datain[-67,]
dim(datain_no_min)


KO = lm(datain_no_min$Microglia[datain_no_min$X == "KO"] ~ datain_no_min$Count[datain_no_min$X == "KO"])
summary(KO)

plot(datain_no_min$Microglia[datain_no_min$X == "KO"] ~ datain_no_min$Count[datain_no_min$X == "KO"],  pch = 20, col = "gray" , cex = 2,ylim = c(220,400), xlim = c(70,230))


abline(lm(KO), lwd=2)




min(datain$Microglia[datain$X == "KOGP"])






KOGP = lm(datain$Microglia[datain$X == "KOGP"] ~ datain$Count[datain$X == "KOGP"])
summary(KOGP)

plot(datain$Microglia[datain$X == "KOGP"] ~ datain$Count[datain$X == "KOGP"],  pch = 20, col = "gray" , cex = 2)


abline(lm(KOGP), lwd=2)

####kogp no min

dim(datain)
datain_no_min <- datain[-101,]
dim(datain_no_min)


KOGP = lm(datain_no_min$Microglia[datain_no_min$X == "KOGP"] ~ datain_no_min$Count[datain_no_min$X == "KOGP"])
summary(KOGP)

plot(datain_no_min$Microglia[datain_no_min$X == "KOGP"] ~ datain_no_min$Count[datain_no_min$X == "KOGP"],  pch = 20, col = "gray" , cex = 2, ylim = c(220,400), xlim = c(70,230))


abline(lm(KOGP), lwd=2)







datain
min(datain$Count)




######realised i should area normalize the auto counts too

areanorm <- datain$Count/0.3957408



WT = lm(datain$Microglia[datain$X == "WT"] ~ areanorm[datain$X == "WT"])
summary(WT)

plot(datain$Microglia[datain$X == "WT"] ~ areanorm[datain$X == "WT"],  pch = 20, col = "gray" , cex = 2)


abline(lm(WT), lwd=2)


