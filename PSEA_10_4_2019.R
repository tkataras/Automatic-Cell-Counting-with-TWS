#pSEA_10_4# maing the shortlists
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
#exprl=exprs(geop)


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


goi <- "ILMN_1232278"
goi_name=mapIds(illuminaMousev2.db, keys=goi, column='SYMBOL', keytype='PROBEID',multiVals="list")




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
model2_astro <- lm(exprl[goi,] ~ astrocyte_reference +  astrocyte_difference)
model2_oligo <- lm(exprl[goi,] ~ oligo_reference +  oligo_difference)





#####working on bulk model creationthing####################
model_matrix <- cbind(1, neuron_reference,
                      astrocyte_reference, oligo_reference, microglia_reference,
                      neuron_difference, astrocyte_difference, oligo_difference,
                      microglia_difference)



model_subset <- em_quantvg(c(2,3,4,5), tnv=4, ng=2) 
models <- lmfitst(t(exprl), model_matrix, model_subset,
                  lm=TRUE) 

length(models[[2]])
#checking specific model, not sure what this means
(summary(models[[2]][["ILMN_2712075"]]) )


X11()
crplot(models[[2]][["ILMN_2816876"]], "2", g="6",newplot = F)




regressor_names <- as.character(1:9) 

coefficients <- coefmat(models[[2]], regressor_names) 
head(coefficients)

colnames(coefficients) <-(c("intercept", "neuron_reference", "astrocyte_reference", "oligo_reference", "microglia_reference",
                            "neuron_difference", "astrocyte_difference", "oligo_difference", "microglia_difference"))


pvalues <- pvalmat(models[[2]], regressor_names) 

colnames(pvalues) <-(c("intercept", "neuron_reference", "astrocyte_reference", "oligo_reference", "microglia_reference",
                       "neuron_difference", "astrocyte_difference", "oligo_difference", "microglia_difference"))


models_summary <- lapply(models[[2]], summary) 
adjusted_R2 <- slt(models_summary, 'adj.r.squared') 

average_expression <- apply(exprl, 1, mean) 
#hist(average_expression)

#plotting adjusted r squared
X11()
plot(coefficients[,1] / average_expression, adjusted_R2,
     pch=".") 

# ***having troube with this, why do we care about the coefficint/avg_expression and why would we want it small???
# filter <- adjusted_R2 > 0.6 & coefficients[,1] /
#   average_expression < 0.5 

#new standard, allows more though
filter <- adjusted_R2 > 0.5 & coefficients[,1] /average_expression < 0.5 
#filter <-  adjusted_R2 > 0.6 & coefficients[,1] /average_expression < 0.5
#filter <- adjusted_R2 > 0.5
sum(filter)
### plots relative neuron specific expression in selected models
X11()
plot(coefficients[filter,2] /
       average_expression[filter], -log10(pvalues[filter,2]))#, abline(h = 1.3))


library(annotate) 
symbols <- getSYMBOL(rownames(exprl), "illuminaMousev2.db") 

#neuro order
order <- order(pvalues[filter,6]) 
table <- data.frame(coefficients[,c(2,6)], pvalues[,c(2,6)], symbols)[filter,][order,] 
table[1:20,] 

sum(!is.na(coefficients[filter,6]))


table_full <- data.frame(coefficients[,c(1:9)], pvalues[,c(1:9)], symbols)[filter,][order,] 
table_full[1:5,]

neuro_shorlist <- table_full[is.na(table_full$microglia_reference) & is.na(table_full$oligo_reference) & is.na(table_full$astrocyte_reference),]
dim(neuro_shorlist)

neuro_shorlist
#ILMN_1232278(Pgam1), ILMN_1248892(Tmem184c), ILMN_1216813(Ndufaf5)


#microglia order
order <- order(pvalues[filter,9]) 
table <- data.frame(coefficients[,c(5,9)], pvalues[,c(5,9)], symbols)[filter,][order,] 
table[1:40,] 
sum(!is.na(coefficients[filter,9]))

table_full <- data.frame(coefficients[,c(1:9)], pvalues[,c(1:9)], symbols)[filter,][order,] 
table_full[1:40,] 

table_full[1:20,1:5]
table_full[1:20,6:5]

(table_full[table_full$symbols == "Rida",])

micro_shorlist <- table_full[is.na(table_full$neuron_reference) & is.na(table_full$oligo_reference) & is.na(table_full$astrocyte_reference),]
dim(micro_shorlist)
micro_shorlist
#ILMN_1244513(Gbp3), ILMN_2615380(Aspg), ILMN_2862026(Ccdc190), ILMN_1257623(NA), ILMN_2610706(Rida), ILMN_2910934(Cd52)

#astro order
order <- order(pvalues[filter,7])
table <- data.frame(coefficients[,c(3,7)], pvalues[,c(3,7)], symbols)[filter,][order,] 
table[1:30,] 
sum(!is.na(coefficients[filter,7]))
table_full <- data.frame(coefficients[,c(1:9)], pvalues[,c(1:9)], symbols)[filter,][order,] 
head(table_full)


astro_shorlist <- table_full[is.na(table_full$microglia_reference) & is.na(table_full$oligo_reference) & is.na(table_full$neuron_reference),]
dim(astro_shorlist)
#No astrocyte models at all actually that pass the QC reqs?
# can explain no single cell models as astro involvement with other cell types, but not use about 0 total models

#oligo order
order <- order(pvalues[filter,8]) 
table <- data.frame(coefficients[,c(4,8)], pvalues[,c(4,8)], symbols)[filter,][order,] 
table[1:30,] 
sum(!is.na(coefficients[filter,8]))
table_full <- data.frame(coefficients[,c(1:9)], pvalues[,c(1:9)], symbols)[filter,][order,] 
head(table_full)
dim(table_full)

oligo_shortlist <- table_full[is.na(table_full$microglia_reference) & is.na(table_full$astrocyte_reference) & is.na(table_full$neuron_reference),]
#ILMN_2547305, no gene name in illumina database




#### making the graphs

#oligo 
###diff model
model2_oligo <- lm(exprl[goi,] ~ oligo_reference +  oligo_difference)




testing1 <- lm(exprl[goi,][information$`genotype:ch1` == "gp120"] ~ oligo_reference[information$`genotype:ch1` == "gp120"])
testing2 <- lm(exprl[goi,][information$`genotype:ch1` == "WT"] ~ oligo_reference[information$`genotype:ch1` == "WT"])

X11()
par(mfrow=c(1,4))
#crplot(model2_neuro, "neuron_reference", g="neuron_difference",newplot = F)
crplot(model2_oligo, "oligo_reference", g="oligo_difference",newplot = F)

# plot(exprl[goi,] ~ neuron_reference, ylim=(c(min(exprl[goi,]), max(exprl[goi,]))), col=as.factor(information$`genotype:ch1`))
# abline(testing2)
# 
# 
# plot(exprl[goi,] ~ neuron_reference, ylim=(c(min(exprl[goi,]), max(exprl[goi,]))), col=as.factor(information$`genotype:ch1`))
# abline(testing1)

X11()
plot(exprl[goi,] ~ oligo_reference, ylim=(c(min(exprl[goi,]), max(exprl[goi,]))), col=as.factor(information$`genotype:ch1`))
abline(testing1)
abline(testing2, col="red")


boxplot(exprl[goi,]~information$`genotype:ch1`,
        data=airquality,
        main="",
        xlab="Geno",
        ylab="expression",
        col="orange",
        border="brown"
)


t.test(exprl[goi,]~information$`genotype:ch1`)





#neuro
goi <- "ILMN_1216813"
goi_name=mapIds(illuminaMousev2.db, keys=goi, column='SYMBOL', keytype='PROBEID',multiVals="list")





###diff model
model2_neuro <- lm(exprl[goi,] ~ neuron_reference + neuron_difference)





testing1 <- lm(exprl[goi,][information$`genotype:ch1` == "gp120"] ~ neuron_reference[information$`genotype:ch1` == "gp120"])
testing2 <- lm(exprl[goi,][information$`genotype:ch1` == "WT"] ~ neuron_reference[information$`genotype:ch1` == "WT"])

X11()
par(mfrow=c(1,4))

boxplot(exprl[goi,]~information$`genotype:ch1`,
        data=airquality,
        main=goi_name[[1]],
        xlab=NA,
        ylab="expression",
        col="orange",
        border="brown"
)


#crplot(model2_neuro, "neuron_reference", g="neuron_difference",newplot = F)
crplot(model2_neuro, "neuron_reference", g="neuron_difference",newplot = F, ylab = NA, main = goi)

# plot(exprl[goi,] ~ neuron_reference, ylim=(c(min(exprl[goi,]), max(exprl[goi,]))), col=as.factor(information$`genotype:ch1`))
# abline(testing2)
# 
# 
# plot(exprl[goi,] ~ neuron_reference, ylim=(c(min(exprl[goi,]), max(exprl[goi,]))), col=as.factor(information$`genotype:ch1`))
# abline(testing1)

#X11()
plot(exprl[goi,] ~ neuron_reference, ylim=(c(min(exprl[goi,]), max(exprl[goi,]))), col=as.factor(information$`genotype:ch1`))
abline(testing1)
abline(testing2, col="red")




t.test(exprl[goi,]~information$`genotype:ch1`)


######MAKING THE BIG BOX AND CR LOT FOR REAL

X11()
par(mfrow=c(4,6))


goi_name=mapIds(illuminaMousev2.db, keys="ILMN_1232278", column='SYMBOL', keytype='PROBEID',multiVals="list")

model2_neuro <- lm(exprl["ILMN_1232278",] ~ neuron_reference + neuron_difference)



boxplot(exprl["ILMN_1232278",]~information$`genotype:ch1`,
        data=airquality,
        main=goi_name[[1]],
        xlab=NA,
        ylab="expression",
        col="orange",
        border="brown"
)

crplot(model2_neuro, "neuron_reference", g="neuron_difference",newplot = F, ylab = NA, main = goi, yaxt='n')


#ILMN_1248892
goi_name=mapIds(illuminaMousev2.db, keys="ILMN_1248892", column='SYMBOL', keytype='PROBEID',multiVals="list")

model2_neuro <- lm(exprl["ILMN_1248892",] ~ neuron_reference + neuron_difference)



boxplot(exprl["ILMN_1248892",]~information$`genotype:ch1`,
        data=airquality,
        main=goi_name[[1]],
        xlab=NA,
        ylab="expression",
        col="orange",
        border="brown"
)

crplot(model2_neuro, "neuron_reference", g="neuron_difference",newplot = F, ylab = NA, main = goi, yaxt='n')

#ILMN_1216813
goi_name=mapIds(illuminaMousev2.db, keys="ILMN_1216813", column='SYMBOL', keytype='PROBEID',multiVals="list")

model2_neuro <- lm(exprl["ILMN_1216813",] ~ neuron_reference + neuron_difference)



boxplot(exprl["ILMN_1216813",]~information$`genotype:ch1`,
        data=airquality,
        main=goi_name[[1]],
        xlab=NA,
        ylab="expression",
        col="orange",
        border="brown"
)

crplot(model2_neuro, "neuron_reference", g="neuron_difference",newplot = F, ylab = NA, main = goi, yaxt='n')




#micro: ILMN_1244513
goi_name=mapIds(illuminaMousev2.db, keys="ILMN_1244513", column='SYMBOL', keytype='PROBEID',multiVals="list")

model2_micro <- lm(exprl["ILMN_1244513",] ~ microglia_reference + microglia_difference)



boxplot(exprl["ILMN_1244513",]~information$`genotype:ch1`,
        data=airquality,
        main=goi_name[[1]],
        xlab=NA,
        ylab="expression",
        col="orange",
        border="brown"
)

crplot(model2_micro, "microglia_reference", g="microglia_difference",newplot = F, ylab = NA, main = goi, yaxt='n')


#ILMN_2615380
goi_name=mapIds(illuminaMousev2.db, keys="ILMN_2615380", column='SYMBOL', keytype='PROBEID',multiVals="list")

model2_micro <- lm(exprl["ILMN_2615380",] ~ microglia_reference + microglia_difference)



boxplot(exprl["ILMN_2615380",]~information$`genotype:ch1`,
        data=airquality,
        main=goi_name[[1]],
        xlab=NA,
        ylab="expression",
        col="orange",
        border="brown"
)

crplot(model2_micro, "microglia_reference", g="microglia_difference",newplot = F, ylab = NA, main = goi, yaxt='n')

#ILMN_2862026
goi_name=mapIds(illuminaMousev2.db, keys="ILMN_2862026", column='SYMBOL', keytype='PROBEID',multiVals="list")

model2_micro <- lm(exprl["ILMN_2862026",] ~ microglia_reference + microglia_difference)



boxplot(exprl["ILMN_2862026",]~information$`genotype:ch1`,
        data=airquality,
        main=goi_name[[1]],
        xlab=NA,
        ylab="expression",
        col="orange",
        border="brown"
)

crplot(model2_micro, "microglia_reference", g="microglia_difference",newplot = F, ylab = NA, main = goi, yaxt='n')

#ILMN_1257623
goi_name=mapIds(illuminaMousev2.db, keys="ILMN_1257623", column='SYMBOL', keytype='PROBEID',multiVals="list")

model2_micro <- lm(exprl["ILMN_1257623",] ~ microglia_reference + microglia_difference)



boxplot(exprl["ILMN_1257623",]~information$`genotype:ch1`,
        data=airquality,
        main="Pik3ap1",
        xlab=NA,
        ylab="expression",
        col="orange",
        border="brown"
)

crplot(model2_micro, "microglia_reference", g="microglia_difference",newplot = F, ylab = NA, main = goi, yaxt='n')


#ILMN_2610706
goi_name=mapIds(illuminaMousev2.db, keys="ILMN_2610706", column='SYMBOL', keytype='PROBEID',multiVals="list")

model2_micro <- lm(exprl["ILMN_2610706",] ~ microglia_reference + microglia_difference)



boxplot(exprl["ILMN_2610706",]~information$`genotype:ch1`,
        data=airquality,
        main="Pik3ap1",
        xlab=NA,
        ylab="expression",
        col="orange",
        border="brown"
)

crplot(model2_micro, "microglia_reference", g="microglia_difference",newplot = F, ylab = NA, main = goi, yaxt='n')



#ILMN_2910934
goi_name=mapIds(illuminaMousev2.db, keys="ILMN_2910934", column='SYMBOL', keytype='PROBEID',multiVals="list")

model2_micro <- lm(exprl["ILMN_2910934",] ~ microglia_reference + microglia_difference)



boxplot(exprl["ILMN_2910934",]~information$`genotype:ch1`,
        data=airquality,
        main="Pik3ap1",
        xlab=NA,
        ylab="expression",
        col="orange",
        border="brown"
)

crplot(model2_micro, "microglia_reference", g="microglia_difference",newplot = F, ylab = NA, main = goi, yaxt='n')


#oligo ILMN_2547305
goi_name=mapIds(illuminaMousev2.db, keys="ILMN_2547305", column='SYMBOL', keytype='PROBEID',multiVals="list")

model2_oligo <- lm(exprl["ILMN_2547305",] ~ oligo_reference + oligo_difference)



boxplot(exprl["ILMN_2547305",]~information$`genotype:ch1`,
        data=airquality,
        main="Mobp",
        xlab=NA,
        ylab="expression",
        col="orange",
        border="brown"
)

crplot(model2_oligo, "oligo_reference", g="oligo_difference",newplot = F, ylab = NA, main = goi, yaxt='n')








#testing marker perturbation
model2_micro <- lm(exprl["ILMN_2610706",] ~ microglia_reference + microglia_difference)
summary(model2_micro)
microglia_reference_down <- microglia_reference - (microglia_reference*0.1)
microglia_difference_down <- microglia_difference - (microglia_difference*0.1)

model2_micro_down <- lm(exprl["ILMN_2610706",] ~ microglia_reference_down + microglia_difference_down)
summary(model2_micro_down)
#if you move all ref and diff down equally, nothing changes