
library("purrr") # processing speed in R???
#install.packages("dplyr")
library("dplyr") #processing
#install.packages("tidyr")
library("tidyr") #processing



library("GEOquery") #get GEO accession

library("AnnotationDbi") #annotate illumina microarray??

library("PSEA") #functions for processing and analysis 

library("MASS") #stat toools

library("illuminaMousev2.db") #gene info for illumina array

# install.packages("BiocManager")
# BiocManager::install("affy", version = "3.8")
#library("affy") #think i dont need this for our illumina data

# BiocManager::install("annotate", version = "3.8")
#library("annotate") #again, this this was for affymetrix data

########################## graphing packages
#install.packages("Rcurl")
library("ggplot2") #managing the multi graphs

library("gtable") 
# install.packages("gridExtra")
library("gridExtra")

library("ggcorrplot")


####introduce experimental data, need to use fcn to create exprl var
geo = 'GSE47029'

geop2 <- getGEO(GEO=geo, destdir="C:/Users/User/Desktop/")
geop2ul <- (geop2[[1]])
str(geop2ul)
exprl=2^exprs((geop2ul))

#geop <- getGEO('GSE47029',destdir="C:/Users/User/Desktop/") # in the first run
geop <- getGEO('GSE47029',filename="C:/Users/User/Desktop/kaul_lab_work/decon/GSE47029_series_matrix.txt.gz")


#un-neg log expression data, row = gene, col~samples
exprl=2^exprs(geop)
#exprl=exprs(geop)


#install.packages(normalize.quantiles)

#trying w/o antilog this time, data already log2 tranformed

#exprl=exprs(geop)


#remove NA rows
exprl2 <- na.omit(exprl)
exprl <- exprl2


####need informatin to drop out the same NA rows that exprl dropped out
#information <- pData(phenoData(geop [["GSE47029_series_matrix.txt.gz"]]))
information <- pData(phenoData(geop))
#information
common <-intersect(information$geo_accession,colnames(exprl))

info2 <- information[common,]
information <- info2

exprl_wt_gp120_HIPEX <- exprl[,information$`genotype:ch1` == "gp120" & information$`strain:ch1` == "HIPEX" | information$`genotype:ch1` == "WT" & information$`strain:ch1` == "HIPEX"]


exprl <- exprl_wt_gp120_HIPEX



### run after finalising the exprl selection
common <-intersect(information$geo_accession,colnames(exprl))

info2 <- information[common,]
information <- info2



# 
# 
# 
# 
# 
# ####making final marker set, this current set in HIPEX gp120 has tot. w/in corr avg = .57 and tot w/out corr avg -.0675
# neuron_genes=c("Nefm", "Gad1")
# neuron_probesets=mapIds(illuminaMousev2.db, keys=neuron_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
# #neuron_probesets[[1]] <- neuron_probesets[[1]][-3]
# neuron_probesets[[2]] <- neuron_probesets[[2]][2]
# neuron_reference <- marker(exprl, neuron_probesets)
# 
# 
# astro_genes=c("Gfap", "Aldh1l1")#,"Slc1a2", "Slc1a3")
# astrocyte_probesets=mapIds(illuminaMousev2.db, keys=astro_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
# astrocyte_probesets[[1]] <- astrocyte_probesets[[1]][-3]
# astrocyte_probesets[[2]] <- astrocyte_probesets[[2]][4]
# astrocyte_reference <- marker(exprl, astrocyte_probesets)
# 
# 
# micro_genes=c("Cd68", "Aif1")#, "Lyz1", "Lyz2")
# microglia_probesets=mapIds(illuminaMousev2.db, keys=micro_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
# microglia_probesets[[2]] <- microglia_probesets[[2]][-2]# removes Aif2
# microglia_probesets[[3]] <- microglia_probesets[[3]][-3]
# microglia_reference <- marker(exprl, microglia_probesets)
# 
# 
# 
# oligo_genes=c("Mog", "Mbp", "Mag")
# oligo_probesets=mapIds(illuminaMousev2.db, keys=oligo_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
# #mbp probe 4 shows poor intercorrelation ILMN_3011353
# oligo_probesets[[2]] <- oligo_probesets[[2]][1] #only use mbp1
# oligo_reference <- marker(exprl, oligo_probesets)
# 
# 
# 
# 
# 
# #removes the probesets used in markers from the expression set for analysis
# markers_probesets=c(unlist(neuron_probesets),unlist(astrocyte_probesets),unlist(oligo_probesets),unlist(microglia_probesets))#, unlist(endoth_probesets))
# markers_char <- as.character(markers_probesets)
# nix <- which(rownames(exprl) %in% markers_char)
# 
# exprl <- exprl[-nix,]
# common <-intersect(information$geo_accession,colnames(exprl))
# info2 <- information[common,]
# information <- info2
# 
# 
# 



#Gbp2b ILMN_1233293
mapIds(illuminaMousev2.db, keys="ILMN_1233293", column='SYMBOL', keytype='PROBEID',multiVals="list")

eGBP2B <- (exprl["ILMN_1233293",]) ## out of bounds because gbp2b is not in microarray
meGBP2B <- mean(exprl["ILMN_1233293",])

#GBP2 probe 1 ILMN_3047389, probe 2 ILMN_3122961
goi_name=mapIds(illuminaMousev2.db, keys="ILMN_3047389", column='SYMBOL', keytype='PROBEID',multiVals="list")
eGBP2_1 <- (exprl["ILMN_3047389",])
meGBP2_1 <- mean(exprl["ILMN_3047389",])


eGBP2_1wt <- (exprl["ILMN_3047389", information$`genotype:ch1` == "WT"])
meGBP2_1wt <- mean(exprl["ILMN_3047389", information$`genotype:ch1` == "WT"])

eGBP2_1gp120 <- (exprl["ILMN_3047389", information$`genotype:ch1` == "gp120"])
meGBP2_1gp120<- mean(exprl["ILMN_3047389", information$`genotype:ch1` == "gp120"])


avg_diff_eGBP2_1 <- meGBP2_1gp120/meGBP2_1wt
fc_GBP2_1 <- log2(meGBP2_1gp120)-log2(meGBP2_1wt)

mapIds(illuminaMousev2.db, keys="ILMN_3122961", column='SYMBOL', keytype='PROBEID',multiVals="list")
eGBP2_2 <- (exprl["ILMN_3122961",])
meGBP2_2 <- mean(exprl["ILMN_3122961",])

eGBP2_2wt <- (exprl["ILMN_3122961", information$`genotype:ch1` == "WT"])
meGBP2_2wt <- mean(exprl["ILMN_3122961", information$`genotype:ch1` == "WT"])

eGBP2_2gp120 <- (exprl["ILMN_3122961", information$`genotype:ch1` == "gp120"])
meGBP2_2gp120<- mean(exprl["ILMN_3122961", information$`genotype:ch1` == "gp120"])

avg_diff_eGBP2_2 <- meGBP2_2gp120/meGBP2_2wt
fc_GBP2_2 <- log2(meGBP2_2gp120)-log2(meGBP2_2wt)


#GBP3 probe 1 ILMN_1244513, probe 2 ILMN_2918002
mapIds(illuminaMousev2.db, keys="ILMN_1244513", column='SYMBOL', keytype='PROBEID',multiVals="list")

eGBP3_1 <- (exprl["ILMN_1244513",])
meGBP3_1 <- mean(exprl["ILMN_1244513",])

eGBP3_1wt <- (exprl["ILMN_1244513", information$`genotype:ch1` == "WT"])
meGBP3_1wt <- mean(exprl["ILMN_1244513", information$`genotype:ch1` == "WT"])

eGBP3_1gp120 <- (exprl["ILMN_1244513", information$`genotype:ch1` == "gp120"])
meGBP3_1gp120<- mean(exprl["ILMN_1244513", information$`genotype:ch1` == "gp120"])


avg_diff_eGBP3_1 <- meGBP3_1gp120/meGBP3_1wt
fc_GBP3_1 <- log2(meGBP3_1gp120)-log2(meGBP3_1wt)





mapIds(illuminaMousev2.db, keys="ILMN_2918002", column='SYMBOL', keytype='PROBEID',multiVals="list")

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
mapIds(illuminaMousev2.db, keys="ILMN_1244866", column='SYMBOL', keytype='PROBEID',multiVals="list")

eGBP5 <- (exprl["ILMN_1244866",])
meGBP5 <- mean(exprl["ILMN_1244866",])

eGBP5wt <- (exprl["ILMN_1244866", information$`genotype:ch1` == "WT"])
meGBP5wt <- mean(exprl["ILMN_1244866", information$`genotype:ch1` == "WT"])

eGBP5gp120 <- (exprl["ILMN_1244866", information$`genotype:ch1` == "gp120"])
meGBP5gp120<- mean(exprl["ILMN_1244866", information$`genotype:ch1` == "gp120"])

avg_diff_eGBP5 <- meGBP5gp120/meGBP5wt
fc_GBP5 <- log2(meGBP5gp120)-log2(meGBP5wt)

#t.test(eGBP5wt,eGBP5gp120)


fc_table <- cbind(fc_GBP2_1, fc_GBP2_2, fc_GBP3_1, fc_GBP3_2, fc_GBP5)
barplot(fc_table)
#write.csv(fc_table, file = "fc_table.csv")





###########making boxplot for Gbp3

#micro: ILMN_1244513
goi_name=mapIds(illuminaMousev2.db, keys="ILMN_1244513", column='SYMBOL', keytype='PROBEID',multiVals="list")

model2_micro <- lm(exprl["ILMN_1244513",] ~ microglia_reference + microglia_difference)

X11()
par(mfrow=c(1,2))

boxplot(exprl["ILMN_1244513",]~information$`genotype:ch1`,
        data=airquality,
        main=goi_name[[1]],
        xlab=NA,
        ylab="expression",
        col="orange",
        border="brown"
)

crplot(model2_micro, "microglia_reference", g="microglia_difference",newplot = F, ylab = NA, main = "ILMN_1244513", yaxt='n', xlab="microglia reference")


library("ilmnbslookup")

install.packages("ilmnbslookup")
library("ilmnbslookup")

#HOW TO LOOK UP OROBE INFO: SEQ, LOC, QUality
mget("ILMN_2636339", illuminaMousev2PROBESEQUENCE)
mget("ILMN_2636339", illuminaMousev2PROBEQUALITY)

