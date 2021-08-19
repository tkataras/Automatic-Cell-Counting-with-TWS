#### probe sequences


####getting probe squence
# x <- illuminaMousev2PROBESEQUENCE

mapped_probes <- mappedkeys(x)
# Convert to a list
xx <- as.list(x[mapped_probes])

head(xx)
xx["ILMN_1244513"] # gpb3 probe 1





#GBP1 ILMN_1244866 ?!?!?!?!?!?!?
#GBP2 probe 1 ILMN_3047389, probe 2 ILMN_3122961
#GBP3 probe 1 ILMN_1244513, probe 2 ILMN_2918002
#GBP5 ILMN_1244866


GBP1_sq <- xx["ILMN_1244513"]

tst = "Gbp2b"
goi_test=mapIds(illuminaMousev2.db, keys=tst, column='PROBEID', keytype='SYMBOL',multiVals="list")
goi_test
sum(goi_test[[1]][1] == rownames(exprl))# checks for the chosen probe in the loaded exprl data


####gthe Gene names .csv file lists ILMN_1233293 as the probe ID for Gbp1


goi <- "ILMN_1244866"
goi_name=mapIds(illuminaMousev2.db, keys=goi, column='SYMBOL', keytype='PROBEID',multiVals="list")
goi_name
###name given here is "Gbp2b"

GBP2B_sq <- xx["ILMN_1233293"]




###GBP2 probe 1
GBP2_p1 <- xx["ILMN_3047389"]
###GBP2 probe 2
GBP2_p2 <- xx["ILMN_3122961"]


##GBP3probe 1
GBP3_p1 <- xx["ILMN_1244513"]

##GBP3 probe 2
GBP3_p2 <- xx["ILMN_2918002"]
##GBP5 
GBP5_sq <- xx["ILMN_1244866"]



#gbp1 called gbp2b but not in microaray



#gbp2 probe 1
goi <- "ILMN_3047389"
t.test(exprl[goi,information$`genotype:ch1` == "WT"], exprl[goi,information$`genotype:ch1` == "gp120"])

#gbp2 probe 2
goi <- "ILMN_3122961"
t.test(exprl[goi,information$`genotype:ch1` == "WT"], exprl[goi,information$`genotype:ch1` == "gp120"])

#gbp3 probe 1
goi <- "ILMN_1244513"
t.test(exprl[goi,information$`genotype:ch1` == "WT"], exprl[goi,information$`genotype:ch1` == "gp120"])

#gbp3 probe 2
goi <- "ILMN_2918002"
t.test(exprl[goi,information$`genotype:ch1` == "WT"], exprl[goi,information$`genotype:ch1` == "gp120"])

#gbp5
goi <- "ILMN_2918002"
t.test(exprl[goi,information$`genotype:ch1` == "WT"], exprl[goi,information$`genotype:ch1` == "gp120"])

#gbp7 probe 1 ILMN_2860645
goi <- "ILMN_2860645"
t.test(exprl[goi,information$`genotype:ch1` == "WT"], exprl[goi,information$`genotype:ch1` == "gp120"])

#gbp8 probe 1 ILMN_2646187
goi <- "ILMN_2646187"
t.test(exprl[goi,information$`genotype:ch1` == "WT"], exprl[goi,information$`genotype:ch1` == "gp120"])
### GBP8 NOT sig diff in brain

##gbp 9 probe 2 ILMN_2641863
goi <- "ILMN_2641863"
t.test(exprl[goi,information$`genotype:ch1` == "WT"], exprl[goi,information$`genotype:ch1` == "gp120"])
##NOT sig diff

