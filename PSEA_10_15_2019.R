#
#pSEA_10_15
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



geop <- getGEO('GSE47029', filename="C:/Users/User/Desktop/kaul_lab_work/decon/GSE47029_series_matrix.txt.gz")
exprl=2^exprs(geop)


#remove NA rows
exprl2 <- na.omit(exprl)
exprl <- exprl2


information <- pData(phenoData(geop))
common <-intersect(information$geo_accession,colnames(exprl))
info2 <- information[common,]
information <- info2

#exprl_only_gp120_HIPEX <- exprl[,information$`genotype:ch1` == "gp120" & information$`strain:ch1` == "HIPEX"]

#exprl_only_wt_HIPEX <- exprl[,information$`genotype:ch1` == "WT" & information$`strain:ch1` == "HIPEX"]


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




group_regress <- "gp120" 

groups <- as.numeric(information$`genotype:ch1` == group_regress)


neuron_difference <- groups * neuron_reference
microglia_difference <- groups * microglia_reference
astrocyte_difference <- groups * astrocyte_reference
oligo_difference <- groups * oligo_reference


#Ccdc190, ILMN_2862026
goi <- "ILMN_2862026"
goi_name=mapIds(illuminaMousev2.db, keys="ILMN_2862026", column='SYMBOL', keytype='PROBEID',multiVals="list")


###diff models
model2_neuro <- lm(exprl[goi,] ~ neuron_reference + neuron_difference)
model2_micro <- lm(exprl[goi,] ~ microglia_reference +  microglia_difference)
model2_astro <- lm(exprl[goi,] ~ astrocyte_reference +  astrocyte_difference)#ignore, markers fail to separate from neuro
model2_oligo <- lm(exprl[goi,] ~ oligo_reference +  oligo_difference)

summary(model2_astro)
summary(model2_micro)



#Aspg ILMN_2615380 
goi <- "ILMN_2615380"
goi_name=mapIds(illuminaMousev2.db, keys="ILMN_2615380", column='SYMBOL', keytype='PROBEID',multiVals="list")


###diff models
model2_neuro <- lm(exprl[goi,] ~ neuron_reference + neuron_difference)
model2_micro <- lm(exprl[goi,] ~ microglia_reference +  microglia_difference)
model2_astro <- lm(exprl[goi,] ~ astrocyte_reference +  astrocyte_difference)#ignore, markers fail to separate from neuro
model2_oligo <- lm(exprl[goi,] ~ oligo_reference +  oligo_difference)

summary(model2_astro)
summary(model2_micro)


#Gpb3 ILMN_1244513
goi <- "ILMN_1244513"
goi_name=mapIds(illuminaMousev2.db, keys="ILMN_1244513", column='SYMBOL', keytype='PROBEID',multiVals="list")

###diff models
model2_micro <- lm(exprl[goi,] ~ microglia_reference +  microglia_difference)
model2_astro <- lm(exprl[goi,] ~ astrocyte_reference +  astrocyte_difference)#ignore, markers fail to separate from neuro

summary(model2_astro)
summary(model2_micro)

##Cd52 ILMN_2910934 
goi <- "ILMN_2910934"
goi_name=mapIds(illuminaMousev2.db, keys="ILMN_2910934", column='SYMBOL', keytype='PROBEID',multiVals="list")

###diff models
model2_micro <- lm(exprl[goi,] ~ microglia_reference +  microglia_difference)
model2_astro <- lm(exprl[goi,] ~ astrocyte_reference +  astrocyte_difference)#ignore, markers fail to separate from neuro

summary(model2_astro)
summary(model2_micro)

#Rida ILMN_2610706 
goi <- "ILMN_2610706"
goi_name=mapIds(illuminaMousev2.db, keys="ILMN_2610706", column='SYMBOL', keytype='PROBEID',multiVals="list")

###diff models
model2_micro <- lm(exprl[goi,] ~ microglia_reference +  microglia_difference)
model2_astro <- lm(exprl[goi,] ~ astrocyte_reference +  astrocyte_difference)#ignore, markers fail to separate from neuro

summary(model2_astro)
summary(model2_micro)



#Pik3ap1 ILMN_1257623 
goi <- "ILMN_1257623"
goi_name=mapIds(illuminaMousev2.db, keys="ILMN_1257623", column='SYMBOL', keytype='PROBEID',multiVals="list")

###diff models
model2_micro <- lm(exprl[goi,] ~ microglia_reference +  microglia_difference)
model2_astro <- lm(exprl[goi,] ~ astrocyte_reference +  astrocyte_difference)#ignore, markers fail to separate from neuro

summary(model2_astro)
summary(model2_micro)


# Gpb3 probe 2 ILMN_2918002
goi <- "ILMN_2918002"
goi_name=mapIds(illuminaMousev2.db, keys="ILMN_2918002", column='SYMBOL', keytype='PROBEID',multiVals="list")

###diff models
model2_micro <- lm(exprl[goi,] ~ microglia_reference +  microglia_difference)
model2_astro <- lm(exprl[goi,] ~ astrocyte_reference +  astrocyte_difference)#ignore, markers fail to separate from neuro

summary(model2_astro)
summary(model2_micro)

#comparing the 2 gpb3 probes
X11()
plot(exprl["ILMN_1244513",] ~exprl["ILMN_2918002",] )

compr <- lm(exprl["ILMN_1244513",] ~exprl["ILMN_2918002",] )
summary(compr)



#Gpb2 probe 2 ILMN_2605602
goi <- "ILMN_3047389"
goi_name=mapIds(illuminaMousev2.db, keys="ILMN_3047389", column='SYMBOL', keytype='PROBEID',multiVals="list")

###diff models
model2_micro <- lm(exprl[goi,] ~ microglia_reference +  microglia_difference)
model2_astro <- lm(exprl[goi,] ~ astrocyte_reference +  astrocyte_difference)#ignore, markers fail to separate from neuro

summary(model2_astro)
summary(model2_micro)





#Gpb2 probe 3 ILMN_3122961
goi <- "ILMN_3122961"
goi_name=mapIds(illuminaMousev2.db, keys="ILMN_3122961", column='SYMBOL', keytype='PROBEID',multiVals="list")

###diff models
model2_micro <- lm(exprl[goi,] ~ microglia_reference +  microglia_difference)
model2_astro <- lm(exprl[goi,] ~ astrocyte_reference +  astrocyte_difference)#ignore, markers fail to separate from neuro

summary(model2_astro)
summary(model2_micro)

model3_micro_astro <-lm(exprl[goi,] ~ microglia_reference +  microglia_difference + astrocyte_reference) 
summary(model3_micro_astro)

#Ndufaf5 ILMN_1216813 
goi <- "ILMN_1216813"
goi_name=mapIds(illuminaMousev2.db, keys="ILMN_1216813", column='SYMBOL', keytype='PROBEID',multiVals="list")


###diff models
model2_neuro <- lm(exprl[goi,] ~ neuron_reference + neuron_difference)
model2_micro <- lm(exprl[goi,] ~ microglia_reference +  microglia_difference)
model2_astro <- lm(exprl[goi,] ~ astrocyte_reference +  astrocyte_difference)#ignore, markers fail to separate from neuro
model2_oligo <- lm(exprl[goi,] ~ oligo_reference +  oligo_difference)

summary(model2_neuro)
summary(model2_micro)


#ILMN_1248892  Tmem184c
goi <- "ILMN_1248892"
goi_name=mapIds(illuminaMousev2.db, keys="ILMN_1248892", column='SYMBOL', keytype='PROBEID',multiVals="list")


###diff models
model2_neuro <- lm(exprl[goi,] ~ neuron_reference + neuron_difference)

summary(model2_neuro)



#ILMN_1232278 
goi <- "ILMN_1232278"
goi_name=mapIds(illuminaMousev2.db, keys="ILMN_1232278", column='SYMBOL', keytype='PROBEID',multiVals="list")


###diff models
model2_neuro <- lm(exprl[goi,] ~ neuron_reference + neuron_difference)

summary(model2_neuro)

#ILMN_2547305 
goi <- "ILMN_2547305"
goi_name=mapIds(illuminaMousev2.db, keys="ILMN_2547305", column='SYMBOL', keytype='PROBEID',multiVals="list")


###diff models
model2_oligo <- lm(exprl[goi,] ~ oligo_reference +  oligo_difference)

summary(model2_oligo)


#### Gpb5 ILMN_1244866
goi <- "ILMN_1244866"
goi_name=mapIds(illuminaMousev2.db, keys="ILMN_1244866", column='SYMBOL', keytype='PROBEID',multiVals="list")

###diff models
model2_micro <- lm(exprl[goi,] ~ microglia_reference +  microglia_difference)
model2_astro <- lm(exprl[goi,] ~ astrocyte_reference +  astrocyte_difference)#ignore, markers fail to separate from neuro

summary(model2_astro)
summary(model2_micro)
crplot(model2_micro,"microglia_reference", g="microglia_difference" )

##Gbp7 ILMN_2860645
goi <- "ILMN_2860645"
goi_name=mapIds(illuminaMousev2.db, keys="ILMN_2860645", column='SYMBOL', keytype='PROBEID',multiVals="list")

###diff models
model2_micro <- lm(exprl[goi,] ~ microglia_reference +  microglia_difference)
model2_astro <- lm(exprl[goi,] ~ astrocyte_reference +  astrocyte_difference)#ignore, markers fail to separate from neuro

summary(model2_astro)
summary(model2_micro)


#GBP2 probe 1 ILMN_3047389 
goi <- "ILMN_3047389"
goi_name=mapIds(illuminaMousev2.db, keys="ILMN_3047389", column='SYMBOL', keytype='PROBEID',multiVals="list")

###diff models
model2_micro <- lm(exprl[goi,] ~ microglia_reference +  microglia_difference)
model2_astro <- lm(exprl[goi,] ~ astrocyte_reference +  astrocyte_difference)#ignore, markers fail to separate from neuro

summary(model2_astro)
summary(model2_micro)


crplot(model2_micro,"microglia_reference", g="microglia_difference" )

#GBP2 probe 2 ILMN_3122961
goi <- "ILMN_3122961"
goi_name=mapIds(illuminaMousev2.db, keys="ILMN_3122961", column='SYMBOL', keytype='PROBEID',multiVals="list")

###diff models
model2_micro <- lm(exprl[goi,] ~ microglia_reference +  microglia_difference)
model2_astro <- lm(exprl[goi,] ~ astrocyte_reference +  astrocyte_difference)#ignore, markers fail to separate from neuro

summary(model2_astro)
summary(model2_micro)


crplot(model2_micro,"microglia_reference", g="microglia_difference" )



# Mx1 anti flu virus ILMN_2707870
goi <- "ILMN_2707870"
goi_name=mapIds(illuminaMousev2.db, keys="ILMN_2707870", column='SYMBOL', keytype='PROBEID',multiVals="list")

###diff models
model2_micro <- lm(exprl[goi,] ~ microglia_reference +  microglia_difference)
model2_astro <- lm(exprl[goi,] ~ astrocyte_reference +  astrocyte_difference)#ignore, markers fail to separate from neuro

summary(model2_astro)
summary(model2_micro)

####getting probe squence
x <- illuminaMousev2PROBESEQUENCE
mapped_probes <- mappedkeys(x)
# Convert to a list
xx <- as.list(x[mapped_probes])

head(xx)
xx["ILMN_1244513"] # gpb3 probe 1



#loking up this Atl1 thing
# 3 probes: [1] "ILMN_1246414" "ILMN_2689284" "ILMN_2732594"
goi <- "ILMN_1246414"
goi_name=mapIds(illuminaMousev2.db, keys="ILMN_2707870", column='SYMBOL', keytype='PROBEID',multiVals="list")

X11()
plot(exprl["ILMN_1244513",] ~exprl["ILMN_2732594",] )

compr <- lm(exprl["ILMN_1244513",] ~exprl["ILMN_1246414",] )
summary(compr)





#taking off top and bottom of the GBP3 probe 1


goi <- "ILMN_1244513"
goi_name=mapIds(illuminaMousev2.db, keys="ILMN_1244513", column='SYMBOL', keytype='PROBEID',multiVals="list")


order <- (order(exprl["ILMN_1244513",]))
new_test <- exprl["ILMN_1244513",][order]
new_test
length(new_test)
new_test_min <- new_test[6:56]
length(new_test_min)

micro_ref <- microglia_reference[names(new_test_min)]
length(micro_ref)
micro_diff <- microglia_difference[names(new_test_min)]

model_min_micro <- lm(new_test_min ~ micro_ref +  micro_diff)
summary(model_min_micro)
crplot(model_min_micro,"micro_ref", g="micro_diff" )
model2_neuro_plot<- crplot(model2_neuro, "neuron_reference", g="neuron_difference",newplot = F)


### Cd52 ILMN_2910934

goi <- "ILMN_2910934"
goi_name=mapIds(illuminaMousev2.db, keys="ILMN_2910934", column='SYMBOL', keytype='PROBEID',multiVals="list")


order <- (order(exprl["ILMN_2910934",]))
new_test <- exprl["ILMN_2910934",][order]
new_test_min <- new_test[6:56]

micro_ref <- microglia_reference[names(new_test_min)]
micro_diff <- microglia_difference[names(new_test_min)]
model_min_micro <- lm(new_test_min ~ micro_ref +  micro_diff)
summary(model_min_micro)
crplot(model_min_micro,"micro_ref", g="micro_diff" )

new_test_min
