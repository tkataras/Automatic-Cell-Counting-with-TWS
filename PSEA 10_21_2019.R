#10_12_2019 trying to make a bar chart comparing gbp genes

tst = "Ifnb1"
goi_test=mapIds(illuminaMousev2.db, keys=tst, column='PROBEID', keytype='SYMBOL',multiVals="list")
goi_test
sum(goi_test[[1]][1] == rownames(exprl))# checks for the chosen probe in the loaded exprl data

#GBP1 ILMN_1244866

# eGBP1 <- (exprl["ILMN_1244866",])
# meGBP1 <- mean(exprl["ILMN_1244866",])
# 
# eGBP1wt <- (exprl["ILMN_1244866", information$`genotype:ch1` == "WT"])
# meGBP1wt <- mean(exprl["ILMN_1244866", information$`genotype:ch1` == "WT"])
# 
# eGBP1gp120 <- (exprl["ILMN_1244866", information$`genotype:ch1` == "gp120"])
# meGBP1gp120 <- mean(exprl["ILMN_1244866", information$`genotype:ch1` == "gp120"])
# 
# avg_diff_eGBP1 <- meGBP1gp120/meGBP1wt

#Gbp2b ILMN_1233293
eGBP1 <- (exprl["ILMN_1233293",]) ## out of bounds because gbp2b is not in microarray
meGBP1 <- mean(exprl["ILMN_1233293",])

#GBP2 probe 1 ILMN_3047389, probe 2 ILMN_3122961
eGBP2_1 <- (exprl["ILMN_3047389",])
meGBP2_1 <- mean(exprl["ILMN_3047389",])


eGBP2_1wt <- (exprl["ILMN_3047389", information$`genotype:ch1` == "WT"])
meGBP2_1wt <- mean(exprl["ILMN_3047389", information$`genotype:ch1` == "WT"])

eGBP2_1gp120 <- (exprl["ILMN_3047389", information$`genotype:ch1` == "gp120"])
meGBP2_1gp120<- mean(exprl["ILMN_3047389", information$`genotype:ch1` == "gp120"])


avg_diff_eGBP2_1 <- meGBP2_1gp120/meGBP2_1wt
fc_GBP2_1 <- log2(meGBP2_1gp120)-log2(meGBP2_1wt)


eGBP2_2 <- (exprl["ILMN_3122961",])
meGBP2_2 <- mean(exprl["ILMN_3122961",])

eGBP2_2wt <- (exprl["ILMN_3122961", information$`genotype:ch1` == "WT"])
meGBP2_2wt <- mean(exprl["ILMN_3122961", information$`genotype:ch1` == "WT"])

eGBP2_2gp120 <- (exprl["ILMN_3122961", information$`genotype:ch1` == "gp120"])
meGBP2_2gp120<- mean(exprl["ILMN_3122961", information$`genotype:ch1` == "gp120"])

avg_diff_eGBP2_2 <- meGBP2_2gp120/meGBP2_2wt
fc_GBP2_2 <- log2(meGBP2_2gp120)-log2(meGBP2_2wt)


#GBP3 probe 1 ILMN_1244513, probe 2 ILMN_2918002
eGBP3_1 <- (exprl["ILMN_1244513",])
meGBP3_1 <- mean(exprl["ILMN_1244513",])

eGBP3_1wt <- (exprl["ILMN_1244513", information$`genotype:ch1` == "WT"])
meGBP3_1wt <- mean(exprl["ILMN_1244513", information$`genotype:ch1` == "WT"])

eGBP3_1gp120 <- (exprl["ILMN_1244513", information$`genotype:ch1` == "gp120"])
meGBP3_1gp120<- mean(exprl["ILMN_1244513", information$`genotype:ch1` == "gp120"])


avg_diff_eGBP3_1 <- meGBP3_1gp120/meGBP3_1wt
fc_GBP3_1 <- log2(meGBP3_1gp120)-log2(meGBP3_1wt)






eGBP3_2 <- (exprl["ILMN_2918002",])
meGBP3_2 <- mean(exprl["ILMN_2918002",])

eGBP3_2wt <- (exprl["ILMN_2918002", information$`genotype:ch1` == "WT"])
meGBP3_2wt <- mean(exprl["ILMN_2918002", information$`genotype:ch1` == "WT"])

eGBP3_2gp120 <- (exprl["ILMN_2918002", information$`genotype:ch1` == "gp120"])
meGBP3_2gp120<- mean(exprl["ILMN_2918002", information$`genotype:ch1` == "gp120"])

avg_diff_eGBP3_2 <- meGBP3_2gp120/meGBP3_2wt
fc_GBP3_2 <- log2(meGBP3_2gp120)-log2(meGBP3_2wt)


#GBP4 not in microarray

#GBP5 ILMN_1244866
eGBP5 <- (exprl["ILMN_1244866",])
meGBP5 <- mean(exprl["ILMN_1244866",])

eGBP5wt <- (exprl["ILMN_1244866", information$`genotype:ch1` == "WT"])
meGBP5wt <- mean(exprl["ILMN_1244866", information$`genotype:ch1` == "WT"])

eGBP5gp120 <- (exprl["ILMN_1244866", information$`genotype:ch1` == "gp120"])
meGBP5gp120<- mean(exprl["ILMN_1244866", information$`genotype:ch1` == "gp120"])

avg_diff_eGBP5 <- meGBP5gp120/meGBP5wt
fc_GBP5 <- log2(meGBP5gp120)-log2(meGBP5wt)







all_table <- cbind( meGBP2_1, meGBP2_2, meGBP3_1, meGBP3_2, meGBP5)
write.csv(all_table, file = "probes_exp.csv")

barplot(all_table)

all_table2 <- cbind( avg_diff_eGBP2_1, avg_diff_eGBP2_2, avg_diff_eGBP3_1, avg_diff_eGBP3_2, avg_diff_eGBP5)
write.csv(all_table2, file = "probes_exp_av_diff.csv")
barplot(all_table2)


fc_table <- cbind(fc_GBP2_1, fc_GBP2_2, fc_GBP3_1, fc_GBP3_2, fc_GBP5)
write.csv(fc_table, file = "fc_table.csv")




##making the boxplots
boxplot(eGBP1wt, eGBP2_1wt
        data=airquality,
        main="",
        xlab="Geno",
        ylab="expression",
        col="orange",
        border="brown"
)


t.test(eGBP1~information$`genotype:ch1`)




#GBP2 probe 1
goi = "ILMN_3047389"
t.test(exprl[goi,information$`genotype:ch1` == "WT"], exprl[goi,information$`genotype:ch1` == "gp120"])

#GBP2 probe 2
goi = "ILMN_3122961"
t.test(exprl[goi,information$`genotype:ch1` == "WT"], exprl[goi,information$`genotype:ch1` == "gp120"])


#GBP3 probe 2 
goi = "ILMN_3122961"
t.test(exprl[goi,information$`genotype:ch1` == "WT"], exprl[goi,information$`genotype:ch1` == "gp120"])


#GBP5
goi = "ILMN_1244866"
t.test(exprl[goi,information$`genotype:ch1` == "WT"], exprl[goi,information$`genotype:ch1` == "gp120"])

###### looking at Gbp2 probe 2 both probes
eGBP2_1 <- (exprl["ILMN_3047389",])
eGBP2_2 <- (exprl["ILMN_3122961",])
t.test(eGBP2_1,eGBP2_2)


eGBP2_1wt <- (exprl["ILMN_3047389", information$`genotype:ch1` == "WT"])
eGBP2_2wt <- (exprl["ILMN_3122961", information$`genotype:ch1` == "WT"])
t.test(eGBP2_1wt,eGBP2_2wt)


eGBP2_1gp120 <- (exprl["ILMN_3047389", information$`genotype:ch1` == "gp120"])
eGBP2_2gp120 <- (exprl["ILMN_3122961", information$`genotype:ch1` == "gp120"])
t.test(eGBP2_1gp120,eGBP2_2gp120)

t.test(eGBP2_1wt,eGBP2_1gp120)
t.test(eGBP2_2wt,eGBP2_2gp120)

t.test(eGBP2_1wt,eGBP2_2wt)
t.test(eGBP2_1gp120,eGBP2_2gp120)

##making the gbp2 boxplots
boxplot(eGBP2_1wt, eGBP2_2wt, eGBP2_1gp120, eGBP2_2gp120,
        data=airquality,
        main="",
        xlab="Geno",
        ylab="expression",
        col="orange",
        border="brown"
)
gbp2_frame <- (cbind(eGBP2_1wt, eGBP2_2wt, eGBP2_1gp120, eGBP2_2gp120))
write.csv(gbp2_frame, "gbp2frame.csv")
barplot(gbp2_frame)


fc_GBP2_1 <- log2(meGBP2_1gp120)-log2(meGBP2_1wt)

fc_GBP2_2 <- log2(meGBP2_2gp120)-log2(meGBP2_2wt)

log2(.5)-log2(1)


dim(exprl)
glm(exprl)
age_vs_gbp3 <- lm(exprl[gbp3p1_goi,] ~ information$`age months:ch1`)
plot(exprl[gbp3p1_goi,] ~ information$`age months:ch1`)

plot(exprl[gbp3p1_goi,] ~ exprl["ILMN_1227573",])


#[1] Ifna1 "ILMN_1233604" "ILMN_2617487" "ILMN_2858639"
plot(exprl[gbp3p1_goi,] ~ exprl["ILMN_1222758",])

plot(exprl[gbp3p1_goi,] ~ exprl["ILMN_1233604",] + information$`genotype:ch1`)
t.test(exprl[gbp3p1_goi, information$`age months:ch1` == 1.5 & information$`genotype:ch1` == "gp120"], 
       exprl[gbp3p1_goi, information$`age months:ch1` == 3 & information$`genotype:ch1` == "gp120"])

plot(exprl[gbp3p1_goi, information$`age months:ch1` == 1.5 & information$`genotype:ch1` == "gp120"], 
       exprl[gbp3p1_goi, information$`age months:ch1` == 3 & information$`genotype:ch1` == "gp120"])



#$`Ifnar2`
#[1] "ILMN_1225311" "ILMN_2598703" "ILMN_2971514"
plot(exprl[gbp3p1_goi, information$`genotype:ch1` == "gp120"] ~ exprl["ILMN_2971514",information$`genotype:ch1` == "gp120"])

#$`Irf9`
#[1] "ILMN_1233461" "ILMN_2636339"

plot(exprl[gbp3p1_goi, information$`genotype:ch1` == "gp120"] ~ exprl["ILMN_2636339",information$`genotype:ch1` == "gp120"])
#look up sequences for blast, one ifr9 probe correlated realy strongly with gbp3, other did not
ml_probe2_irf9 <- lm(exprl[gbp3p1_goi, information$`genotype:ch1` == "gp120"] ~ exprl["ILMN_2636339",information$`genotype:ch1` == "gp120"])
summary(ml_probe2_irf9)

ml_probe1_irf9 <- lm(exprl[gbp3p1_goi, information$`genotype:ch1` == "gp120"] ~ exprl["ILMN_1233461",information$`genotype:ch1` == "gp120"])
summary(ml_probe1_irf9)
plot()

#ILMN_2636339
plot(exprl[gbp3p1_goi, information$`genotype:ch1` == "gp120"] ~ exprl["ILMN_2636339",information$`genotype:ch1` == "gp120"])


## gbp2 vs irf9 probe 1 in microarray ILMN_3047389, probe 2 ILMN_3122961 gbp2probe1 ILMN_3047389
plot(exprl["ILMN_3047389", information$`genotype:ch1` == "gp120"] ~ exprl["ILMN_2636339",information$`genotype:ch1` == "gp120"])
plot(exprl["ILMN_3122961", information$`genotype:ch1` == "gp120"] ~ exprl["ILMN_2636339",information$`genotype:ch1` == "gp120"])

#$`Irf1`
#[1] "ILMN_2599782" "ILMN_2624100" "ILMN_2649067" "ILMN_2649068" "ILMN_2834777"
plot(exprl[gbp3p1_goi, information$`genotype:ch1` == "gp120"] ~ exprl["ILMN_2834777",information$`genotype:ch1` == "gp120"])
Irf1lm <- lm((exprl[gbp3p1_goi, information$`genotype:ch1` == "gp120"] ~ exprl["ILMN_2834777",information$`genotype:ch1` == "gp120"]))
summary(Irf1lm)



