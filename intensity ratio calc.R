##Author: Theo 


###ratio distal vs central IRF7 intensity, from .csv file

datr <- read.csv("F:/primary microglia Jeff images/pHMC Staining plate 7 irf7/IRF7 inside vs outside dapi calc.csv")


#removing the lowest ratio, it comes from insufficnet dapi segmentation

datr$Label[10]
datr$ratio_inside_mean_over_outside_mean[10]

dim(datr[,])
dim(datr[-10,])
datr <- datr[-10,]


boxplot(datr$ratio_inside_mean_over_outside_mean ~ datr$cond)


stripchart(datr$ratio_inside_mean_over_outside_mean ~ datr$cond, vertical=TRUE,method="jitter", add=T, col = 2, pch = 19)




summary(aov(datr$ratio_inside_mean_over_outside_mean ~ datr$cond))
t.test(datr$ratio_inside_mean_over_outside_mean[datr$cond == "gpbal"] , datr$ratio_inside_mean_over_outside_mean[datr$cond == "gpbal_IFNB"])

t.test(datr$ratio_inside_mean_over_outside_mean[datr$cond == "IFNB"] , datr$ratio_inside_mean_over_outside_mean[datr$cond == "gpbal"])


#just running all the T test effectively
a <- aov(datr$ratio_inside_mean_over_outside_mean ~ datr$cond)
TukeyHSD(a)




###looking at the non normalized values inside cell area

datnn <- read.csv("F:/primary microglia Jeff images/pHMC Staining plate 7 irf7/Results non norm cell only.csv")

datcond <- read.csv("F:/primary microglia Jeff images/pHMC Staining plate 7 irf7/IRF7 inside vs outside dapi calc.csv")




boxplot(datnn$Mean ~ datcond$cond)


stripchart(datnn$Mean ~ datcond$cond, vertical=TRUE,method="jitter", add=T, col = 2, pch = 19)

summary(aov(datnn$Mean ~ datcond$cond))
a <- aov(datnn$Mean ~ datcond$cond)
TukeyHSD(a)





length(datnn$Mean)




#### looking at ephrin normalised ration dapi colocalized vs tubulin colocalized w/o dapi

dateph <- read.csv("F:/primary microglia Jeff images/6-19-2021 - pHMC Staining plate 7 Ephrin-b1/Results eph ratio calc.csv")


boxplot(dateph$mean.ratio.inside.over.outside ~ dateph$cond)


stripchart(dateph$mean.ratio.inside.over.outside ~ dateph$cond, vertical=TRUE,method="jitter", add=T, col = 2, pch = 19)


##running two way anova
summary(aov(dateph$mean.ratio.inside.over.outside ~ dateph$cond))






boxplot(dateph$mode.ratio.inside.outsided ~ dateph$cond)


stripchart(dateph$mode.ratio.inside.outsided ~ dateph$cond, vertical=TRUE,method="jitter", add=T, col = 2, pch = 19)


##running two way anova
summary(aov(dateph$mode.ratio.inside.outsided ~ dateph$cond))

a <- aov(dateph$mode.ratio.inside.outsided ~ dateph$cond)
TukeyHSD(a)



###looking at unprocessed eph aroudn dapi and total

##total
datueph_tot <- read.csv("F:/primary microglia Jeff images/6-19-2021 - pHMC Staining plate 7 Ephrin-b1/Results eph unprocessed.csv")




boxplot(datueph_tot$Mean ~ dateph$cond)


stripchart(datueph_tot$Mean ~ dateph$cond, vertical=TRUE,method="jitter", add=T, col = 2, pch = 19)


##running two way anova
summary(aov(datueph_tot$Mean ~ dateph$cond))

a <- aov(dateph$mode.ratio.inside.outsided ~ dateph$cond)
TukeyHSD(a)

