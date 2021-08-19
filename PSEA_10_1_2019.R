##PSEA_11_1_2019
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




geo = 'GSE47029'

geop <- getGEO('GSE47029',filename="C:/Users/User/Desktop/kaul_lab_work/decon/GSE47029_series_matrix.txt.gz")


#trying w/o antilog this time, data already log2 tranformed

exprl=2^exprs(geop)


#remove NA rows
exprl2 <- na.omit(exprl)
exprl <- exprl2


information <- pData(phenoData(geop))
common <-intersect(information$geo_accession,colnames(exprl))
info2 <- information[common,]
information <- info2





exprl_wt_gp120_HIPEX <- exprl[,information$`genotype:ch1` == "gp120" & information$`strain:ch1` == "HIPEX" | information$`genotype:ch1` == "WT" & information$`strain:ch1` == "HIPEX"]
exprl <- exprl_wt_gp120_HIPEX
common <-intersect(information$geo_accession,colnames(exprl))

info2 <- information[common,]
information <- info2


####making final marker set, this current set in HIPEX gp120 has tot. w/in corr avg = .57 and tot w/out corr avg -.0675
neuron_genes=c("Nefm", "Gad1")
neuron_probesets=mapIds(illuminaMousev2.db, keys=neuron_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
#neuron_probesets[[1]] <- neuron_probesets[[1]][-3]
neuron_probesets[[2]] <- neuron_probesets[[2]][2]
neuron_reference <- marker(exprl, neuron_probesets)


astro_genes=c("Gfap", "Aldh1l1")#,"Slc1a2", "Slc1a3")
astrocyte_probesets=mapIds(illuminaMousev2.db, keys=astro_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
astrocyte_probesets[[1]] <- astrocyte_probesets[[1]][-3]
astrocyte_probesets[[2]] <- astrocyte_probesets[[2]][4]
astrocyte_reference <- marker(exprl, astrocyte_probesets)


micro_genes=c("Cd68", "Aif1")#, "Lyz1", "Lyz2")
microglia_probesets=mapIds(illuminaMousev2.db, keys=micro_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
microglia_probesets[[2]] <- microglia_probesets[[2]][-2]# removes Aif2
microglia_probesets[[3]] <- microglia_probesets[[3]][-3]
microglia_reference <- marker(exprl, microglia_probesets)



oligo_genes=c("Mog", "Mbp", "Mag")
oligo_probesets=mapIds(illuminaMousev2.db, keys=oligo_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
#mbp probe 4 shows poor intercorrelation ILMN_3011353
oligo_probesets[[2]] <- oligo_probesets[[2]][1] #only use mbp1
oligo_reference <- marker(exprl, oligo_probesets)



###########################################################################

# only neuro ref adn diff in best model
# Pgam1_goi <- "ILMN_1232278"
# Tubb6_goi <- "ILMN_2718217"
# Fcrls_goi <- "ILMN_2770968" # neg ref corr
# Ndufaf5_goi <- "ILMN_1216813" #not super strong, made slides in notes
# Mroh1_goi <- "ILMN_2613806" #mroh strongly negative, cant really use


goi <- "ILMN_2816876"
goi_name=mapIds(illuminaMousev2.db, keys=goi, column='SYMBOL', keytype='PROBEID',multiVals="list")



model1 <- lm(exprl[goi,] ~ neuron_reference + microglia_reference + astrocyte_reference + oligo_reference)
summary(model1)





group_regress <- "gp120" 

groups <- as.numeric(information$`genotype:ch1` == group_regress)



#make diff interaction regressors
neuron_difference <- groups * neuron_reference
microglia_difference <- groups * microglia_reference
astrocyte_difference <- groups * astrocyte_reference
oligo_difference <- groups * oligo_reference


###diff models
model2_neuro <- lm(exprl[goi,] ~ neuron_reference + neuron_difference)
model2_micro <- lm(exprl[goi,] ~ microglia_reference +  microglia_difference)
model2_astro <- lm(exprl[goi,] ~ astrocyte_reference +  astrocyte_difference)#ignore, markers fail to separate from neuro
model2_oligo <- lm(exprl[goi,] ~ oligo_reference +  oligo_difference)


summary(model2_oligo)

summary(model2_astro)



testing1 <- lm(exprl[goi,][information$`genotype:ch1` == "gp120"] ~ neuron_reference[information$`genotype:ch1` == "gp120"])
testing2 <- lm(exprl[goi,][information$`genotype:ch1` == "WT"] ~ neuron_reference[information$`genotype:ch1` == "WT"])

testing3 <- lm(exprl[goi,][information$`genotype:ch1` == "WT"] ~ neuron_reference[information$`genotype:ch1` == "WT"] + neuron_reference[information$`genotype:ch1` == "gp120"])
###testing3 doesnt work because 27 WT samples and 34 gp120

testing1 <- lm(exprl[goi,][information$`genotype:ch1` == "gp120"] ~ astrocyte_reference[information$`genotype:ch1` == "gp120"])
testing2 <- lm(exprl[goi,][information$`genotype:ch1` == "WT"] ~ astrocyte_reference[information$`genotype:ch1` == "WT"])




X11()
par(mfrow=c(1,4))
#crplot(model2_neuro, "neuron_reference", g="neuron_difference",newplot = F)
crplot(model2_micro, "microglia_reference", g="microglia_difference",newplot = F)

# plot(exprl[goi,] ~ neuron_reference, ylim=(c(min(exprl[goi,]), max(exprl[goi,]))), col=as.factor(information$`genotype:ch1`))
# abline(testing2)
# 
# 
# plot(exprl[goi,] ~ neuron_reference, ylim=(c(min(exprl[goi,]), max(exprl[goi,]))), col=as.factor(information$`genotype:ch1`))
# abline(testing1)
X11()
plot(exprl[goi,] ~ astrocyte_reference, ylim=(c(min(exprl[goi,]), max(exprl[goi,]))), col=as.factor(information$`genotype:ch1`))
abline(testing1)
abline(testing2)


boxplot(exprl[goi,]~information$`genotype:ch1`,
        data=airquality,
        main="",
        xlab="Geno",
        ylab="expression",
        col="orange",
        border="brown"
)


t.test(exprl[goi,]~information$`genotype:ch1`)






