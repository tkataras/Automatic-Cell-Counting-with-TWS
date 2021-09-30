###ratio distal vs central IRF7 intensity

datr <- read.csv("F:/primary microglia Jeff images/pHMC Staining plate 7/Results IRF7 in cell no dapi excel working csv.csv")

boxplot(datr$IRF7.avg.inside.cell.over.avg.outside ~ datr$cond)


stripchart(datr$IRF7.avg.inside.cell.over.avg.outside ~ datr$cond, vertical=TRUE,method="jitter")


#removing the lowest ratio, it comes from insufficnet dapi segmentation

datr$Label[10]
datr$IRF7.avg.inside.cell.over.avg.outside[10]

dim(datr[,])
dim(datr[-10,])
datr <- datr[-10,]

boxplot(datr$IRF7.avg.inside.cell.over.avg.outside ~ datr$cond)


stripchart(datr$IRF7.avg.inside.cell.over.avg.outside ~ datr$cond, vertical=TRUE,method="jitter", add=T, col = 2, pch = 19)


summary(aov(datr$IRF7.avg.inside.cell.over.avg.outside ~ datr$cond))

t.test(datr$IRF7.avg.inside.cell.over.avg.outside[datr$cond == "gpbal"] , datr$IRF7.avg.inside.cell.over.avg.outside[datr$cond == "IIIB"])



### origional intensity over %area
###isnt that just mean instensity?


datain2 <- read.csv("F:/primary microglia Jeff images/pHMC Staining plate 7 irf7/Resultsnon norm tub area only.csv")
datcond <-  read.csv("F:/primary microglia Jeff images/pHMC Staining plate 7 irf7/Results IRF7 in cell no dapi excel working csv.csv") ##this file isnt being found???

conds <- datcond$cond
head(datain2)
summary(aov(datain2$Mean ~ conds))
length(datain2$Mean)

boxplot(datain2$Mean ~ as.factor(datcond$cond))
stripchart(datain2$Mean ~ datcond$cond, vertical=TRUE,method="jitter", add=T, col = 2, pch = 19)

test <- (datain2$Mean*datain2$Area)*(datain2$X.Area)



###adding in vehicle




vehic <- read.csv("F:/primary microglia Jeff images/pHMC Staining plate 7 irf7/vehicle IRF7 min non dapi/Results min non dapi IRF7 vehicle working.csv")
vehic$cond
datr2 <- NA
datr2$ratio.avg.insdie.to.avg.outside <- c(datr$IRF7.avg.inside.cell.over.avg.outside, vehic$ratio.avg.inside.over.avg.outside)
datr2$cond <- c(datr$cond, vehic$cond)





boxplot(datr2$ratio.avg.insdie.to.avg.outside ~ datr2$cond)


stripchart(datr2$ratio.avg.insdie.to.avg.outside ~ datr2$cond, vertical=TRUE,method="jitter", add=T, col = 2, pch = 19)


summary(aov(datr2$ratio.avg.insdie.to.avg.outside ~ datr2$cond))
a <- aov(datr2$ratio.avg.insdie.to.avg.outside ~ datr2$cond)
TukeyHSD(a)



##removing positive outlier
ratio_i_to_o <- datr2$ratio.avg.insdie.to.avg.outside[-32]
conditions <- datr2$cond[-32]

boxplot(ratio_i_to_o ~ conditions)

stripchart(ratio_i_to_o ~ conditions, vertical=TRUE,method="jitter", add=T, col = 2, pch = 19)


summary(aov(ratio_i_to_o ~ conditions))
a <- aov(ratio_i_to_o ~ conditions)
TukeyHSD(a)


##adding the unprocessed veh

veh_irf7_tub_only <- read.csv("F:/primary microglia Jeff images/pHMC Staining plate 7 irf7/vehicle unprocessced IRF7 tub only/Results veh unprocess IRF7 tub only.csv")

datr2$IRF7_non_norm_tub_only <- veh_irf7_tub_only$Mean

non_norm_IRF7_tub_only_mean <- c(datain2$Mean, veh_irf7_tub_only$Mean)
length(non_norm_IRF7_tub_only_mean)
non_norm_cond <- c(datcond$cond, vehic$cond)
length(non_norm_cond)
boxplot(non_norm_IRF7_tub_only_mean ~non_norm_cond)

stripchart(non_norm_IRF7_tub_only_mean ~non_norm_cond, vertical=TRUE,method="jitter", add=T, col = 2, pch = 19)



summary(aov(non_norm_IRF7_tub_only_mean ~non_norm_cond))
a <- aov(ratio_i_to_o ~ conditions)
TukeyHSD(a)

