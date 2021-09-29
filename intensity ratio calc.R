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




### origional intensity over %area
###isnt that just mean instensity?


datain2 <- read.csv("F:/primary microglia Jeff images/pHMC Staining plate 7/Results IRF7 min non Tub working.csv")
datcond <-  read.csv("F:/primary microglia Jeff images/pHMC Staining plate 7/Results IRF7 in cell no dapi excel working csv.csv")

conds <- datcond$cond
head(datain2)
summary(aov(datain2$Mean ~ conds))
length(datain2$Mean)

boxplot(datain2$Mean ~ as.factor(datcond$cond))
stripchart(datain2$Mean ~ datcond$cond, vertical=TRUE,method="jitter", add=T, col = 2, pch = 19)

test <- (datain2$Mean*datain2$Area)*(datain2$X.Area)
