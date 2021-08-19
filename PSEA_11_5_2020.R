# maing the shortlists
library("purrr") # processing speed in R???
#install.packages("dplyr")
library("dplyr") #processing
#install.packages("tidyr")
library("tidyr") #processing



library("GEOquery") #get GEO accession

library("AnnotationDbi") #annotate illumina microarray??

library("PSEA") #functions for processing and analysis 

library("MASS") #stat toools

#BiocManager::install("illuminaMousev2.db")

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


##these 2 dont load right now, dont need yet
 install.packages("gridExtra")
library("gridExtra")

library("ggcorrplot")




geo = 'GSE47029'

geop <- getGEO('GSE47029',filename="C:/Users/User/Desktop/kaul_lab_work/decon/GSE47029_series_matrix.txt.gz")

information <- pData(phenoData(geop))

# data already log2 tranformed

#exprl=2^exprs(geop)

#testing log transformed data
exprl <- exprs(geop)


#looking for probes before any NA ommmiting
# $Erbb4
# [1] "ILMN_1242652" many_na"ILMN_2535318" x"ILMN_2699974" x"ILMN_2772217"
# $Ephb2
# [1] "ILMN_1220911" "ILMN_2622255" "ILMN_2688515"
# $Nrg1
# [1] many_na"ILMN_1225579" "ILMN_2971688"
# $Efnb1
# [1] "ILMN_2698443"
# $Bdnf
# [1] "ILMN_1214228" "ILMN_1246842" "ILMN_1255582" "ILMN_2446230" "ILMN_2666980" "ILMN_3105417"
# 
# $Ntrk2
# [1] "ILMN_2705460" "ILMN_3061460" "ILMN_3138904"
# # 
# test = "ILMN_3138904"
# sum(exprl[test,])
# 





exprl_no_ccr <- exprl[,information$`genotype:ch1` == "WT" | information$`genotype:ch1` == "gp120"]
exprl <- exprl_no_ccr




common <-intersect(information$geo_accession,colnames(exprl))

info2 <- information[common,]
information <- info2



# 
# 
# mean(exprl)
# 
# Erbb4_probes <- "ILMN_1242652"
# Ephb2_probes <- c("ILMN_1220911", "ILMN_2622255", "ILMN_2688515")
# Nrg1_probes <- c("ILMN_2971688")
# Efnb1_probes <- c("ILMN_2698443")
# Bdnf_probes <- c("ILMN_1214228", "ILMN_1246842", "ILMN_1255582", "ILMN_2446230", "ILMN_2666980", "ILMN_3105417")
# 
# 
# 
# hist(exprl[Ephb2_probes[3],])
# 
# t.test(exprl[Erbb4_probes,information$`genotype:ch1` == "WT"] ~ exprl[Erbb4_probes,information$`genotype:ch1` == "gp120"])
# 
# 
# 


# dim(exprl)
####removing CCR5KO/het, one single animal, dontknwo what its supposed to be
test <-exprl[,information$`genotype:ch1` != "CCR5KO/het"]
dim(test)
exprl <- test

#information <- pData(phenoData(geop))
common <-intersect(information$geo_accession,colnames(exprl))
info2 <- information[common,]
information <- info2

#remove NA rows
exprl2 <- na.omit(exprl)
exprl <- exprl2

#information <- pData(phenoData(geop))
common <-intersect(information$geo_accession,colnames(exprl))
info2 <- information[common,]
information <- info2


#check to ee if exprl and info are same number of samples
dim(information)[1] -dim(exprl)[2]



##the cell pop probeset from my quals. it is very limited, eg only 2 genes for microglia pop
####making final marker set, this current set in HIPEX gp120 has tot. w/in corr avg = .57 and tot w/out corr avg -.0675
neuron_genes=c("Nefm", "Gad1")
neuron_probesets=mapIds(illuminaMousev2.db, keys=neuron_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
#neuron_probesets[[1]] <- neuron_probesets[[1]][-3]
neuron_probesets[[2]] <- neuron_probesets[[2]][2]
neuron_reference <- marker(exprl, neuron_probesets)


astro_genes=c("Gfap","Aldh1l1", "Lcn2")#,"Slc1a2", "Slc1a3")
astrocyte_probesets=mapIds(illuminaMousev2.db, keys=astro_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
astrocyte_probesets[[1]] <- astrocyte_probesets[[1]][-3]
astrocyte_probesets[[2]] <- astrocyte_probesets[[2]][-1]
astrocyte_probesets[[2]] <- astrocyte_probesets[[2]][-2]
astrocyte_reference <- marker(exprl, astrocyte_probesets)

# astro_genes=c("Aldh1l1")#,"Slc1a2", "Slc1a3")
# astrocyte_probesets=mapIds(illuminaMousev2.db, keys=astro_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
# astrocyte_probesets[[1]] <- astrocyte_probesets[[1]][4]
# astrocyte_reference <- marker(exprl, astrocyte_probesets)


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

endoth_genes=c("Vwf", "Cd34","Pecam1")
endoth_probesets=mapIds(illuminaMousev2.db, keys=endoth_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
endoth_reference <- marker(exprl, endoth_probesets)





#check geno etc
information$`genotype:ch1`
information$`Sex:ch1`






















#information$`genotype:ch1`
# 
# 
# 
# head(exprl)
# (exprl["ILMN_2505095",])
# 

#exprl_wt_gp120_HIPEX <- exprl[,information$`genotype:ch1` == "gp120" & information$`strain:ch1` == "HIPEX" | information$`genotype:ch1` == "WT" & information$`strain:ch1` == "HIPEX"]
#exprl <- exprl_wt_gp120_HIPEX
# common <-intersect(information$geo_accession,colnames(exprl))
# 
# info2 <- information[common,]
# information <- info2





####teh boxplot thing

#weird, one values for CCR5KO/het
#exprl["ILMN_1220911",information$`genotype:ch1` == "CCR5KO/het"]

### working indiviual box pot code

# # $Ccl4
# [1] "ILMN_1223257" "ILMN_1224472"
# 
# $Ccl3
# [1] "ILMN_1253919"
# $Ccl5
# [1] "ILMN_1231814"
# $Efnb1
# [1] "ILMN_2698443"
# $Bdnf
# [1] "ILMN_1214228" "ILMN_1246842" "ILMN_1255582" "ILMN_2446230" "ILMN_2666980" "ILMN_3105417"
# 
# $Ephb2
# [1] "ILMN_1220911" "ILMN_2622255" "ILMN_2688515"
# #


#goi <- exprl["ILMN_1771385",]
goi <- "ILMN_2688515"
goi_val <- exprl[goi,]
goi_name=mapIds(illuminaMousev2.db, keys=goi, column='SYMBOL', keytype='PROBEID',multiVals="list")
goi_name
title=goi_name


info <- information$`genotype:ch1`

X11()
boxplot(goi_val~info,
        data=airquality,
        main=as.character(title),
        xlab="genotype",
        ylab="expression",
        col="orange",
        border="brown",
        pars = list(boxwex = 0.8)
)





mylevels <- levels(as.factor(info))

#levelProportions <- summary(data$names)/nrow(data)
levelProportions <- summary(as.factor(info))/length(goi_val)
for(i in 1:length(mylevels)){
  
  thislevel <- mylevels[i]
  thisvalues <- goi_val[information$`genotype:ch1` ==thislevel]
  
  # take the x-axis indices and add a jitter, proportional to the N in each level
  myjitter <- jitter(rep(i, length(thisvalues)), amount=levelProportions[i]/2)
  points(myjitter, thisvalues, pch=20, col=rgb(0,0,0,.9)) 
  
}





#ANOVA
group <- as.factor(information$`genotype:ch1`)
probe_id <- "ILMN_2688515"
res.aov <- aov(exprl[probe_id,] ~ group)
summary(res.aov)

TukeyHSD(res.aov)



# 
# 
# 
# Ephb2_probes <- c("ILMN_1220911", "ILMN_2622255", "ILMN_2688515")
# Nrg1_probes <- c("ILMN_2971688")
# Efnb1_probes <- c("ILMN_2698443")
# Bdnf_probes <- c("ILMN_1214228", "ILMN_1246842", "ILMN_1255582", "ILMN_2446230", "ILMN_2666980", "ILMN_3105417")
# 
# 
# 









###########################################################################

# only neuro ref adn diff in best model
# Pgam1_goi <- "ILMN_1232278"
# Tubb6_goi <- "ILMN_2718217"
# Fcrls_goi <- "ILMN_2770968" # neg ref corr
# Ndufaf5_goi <- "ILMN_1216813" #not super strong, made slides in notes
# Mroh1_goi <- "ILMN_2613806" #mroh strongly negative, cant really use

# 
# goi <- "ILMN_1220911"
# goi_name=mapIds(illuminaMousev2.db, keys=goi, column='SYMBOL', keytype='PROBEID',multiVals="list")
# 
# 
# #jeff = ERBB4, EPHB2, NRG1, EFNB1, trkb, bdnf

test = "Ephb2"
t1=mapIds(illuminaMousev2.db, keys=test, column='PROBEID', keytype='SYMBOL',multiVals="list")
t1
# 
# sum(exprl["ILMN_2688515",])

# $Erbb4
# [1] "ILMN_1242652" "ILMN_2535318" "ILMN_2699974" "ILMN_2772217"
# $Ephb2
# [1] "ILMN_1220911" "ILMN_2622255" "ILMN_2688515"
# $Nrg1
# [1] "ILMN_1225579" "ILMN_2971688"
# $Efnb1
# [1] "ILMN_2698443"
# $Bdnf
# [1] "ILMN_1214228" "ILMN_1246842" "ILMN_1255582" "ILMN_2446230" "ILMN_2666980" "ILMN_3105417"
# 
# $Ntrk2
# [1] "ILMN_2705460" "ILMN_3061460" "ILMN_3138904"
# # $Ccl4
# [1] "ILMN_1223257" "ILMN_1224472"
# 
# $Ccl3
# [1] "ILMN_1253919"
# $Ccl5
# [1] "ILMN_1231814"
# $Ephb2
# [1] "ILMN_1220911" "ILMN_2622255" "ILMN_2688515"
# #

group_regress <- "gp120" 

groups <- as.numeric(information$`genotype:ch1` == group_regress)

sum(as.numeric(information$`genotype:ch1` == "CCR5KO_x_gp120"))


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
       average_expression[filter], -log10(pvalues[filter,2]), abline(h = 1.3))


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
goi <- "ILMN_1248892"
goi_name=mapIds(illuminaMousev2.db, keys=goi, column='SYMBOL', keytype='PROBEID',multiVals="list")





###diff model
model2_neuro <- lm(exprl[goi,] ~ neuron_reference + neuron_difference)





testing1 <- lm(exprl[goi,][information$`genotype:ch1` == "gp120"] ~ neuron_reference[information$`genotype:ch1` == "gp120"])
testing2 <- lm(exprl[goi,][information$`genotype:ch1` == "WT"] ~ neuron_reference[information$`genotype:ch1` == "WT"])

X11()
par(mfrow=c(1,4))
#crplot(model2_neuro, "neuron_reference", g="neuron_difference",newplot = F)
crplot(model2_neuro, "neuron_reference", g="neuron_difference",newplot = F)

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


boxplot(exprl[goi,]~information$`genotype:ch1`,
        data=airquality,
        main="",
        xlab="Geno",
        ylab="expression",
        col="orange",
        border="brown"
)


t.test(exprl[goi,]~information$`genotype:ch1`)


###model2 microglia???



###diff model
model2_neuro <- lm(exprl[goi,] ~ neuron_reference + neuron_difference)





testing1 <- lm(exprl[goi,][information$`genotype:ch1` == "gp120"] ~ microglia_reference[information$`genotype:ch1` == "gp120"])
testing2 <- lm(exprl[goi,][information$`genotype:ch1` == "WT"] ~ neuron_reference[information$`genotype:ch1` == "WT"])




###########CR plots


####visualizations
X11()
par(mfrow=c(2,3))

#neuro
diff_c <- as.character(round(model2_neuro$coefficients[3],3))
diff_p <- round(pvalmat(list(model2_neuro), c("neuron_reference","neuron_difference"))[2],4)

neuro_title <- paste("neuro", goi_name, "red is ",group_regress)#title for auto save file
#X11() 
model2_neuro_plot<- crplot(model2_neuro, "neuron_reference", g="neuron_difference",newplot = F)
title(paste("Neuron", goi_name, "red = ",group_regress))
legend("top","center", paste("coef=",as.character(round(model2_neuro$coefficients[2],3)),
                             "p_val=",round(pvalmat(list(model2_neuro), c("neuron_reference","neuron_difference"))[1],4)))
legend("bottom", paste("diff_coef=",as.character(diff_c), "p=",as.character(diff_p)))
#legend("right", paste("red = only ", group_regress))




#micro
diff_c2 <- as.character(round(model2_micro$coefficients[3],3))
diff_p2 <- round(pvalmat(list(model2_micro), c("microglia_reference","microglia_difference"))[2],4)

#X11()
model2_micro_plot<- crplot(model2_micro, "microglia_reference", g="microglia_difference", newplot = F)
title(paste("microglia", goi_name, "red = ",group_regress))
legend("top", paste("coef=",as.character(round(model2_micro$coefficients[2],3)),
                    "p_val=",round(pvalmat(list(model2_micro), c("microglia_reference","microglia_difference"))[1],4)))
legend("bottom", paste("diff_coef=",as.character(diff_c2), "p=",as.character(diff_p2)))
#legend("right", paste("red = only ", group_regress))
micro_title <- paste("micro", goi_name, "red is ",group_regress)#title for auto save file




#astro
diff_c3 <- as.character(round(model2_astro$coefficients[3],3))
diff_p3 <- round(pvalmat(list(model2_astro), c("astrocyte_reference","astrocyte_difference"))[2],4)


#X11()
model2_astro_plot<-crplot(model2_astro, "astrocyte_reference", g="astrocyte_difference",newplot = F)
title(paste("astrocyte", goi_name, "red = ",group_regress))
legend("top", paste("coef=",as.character(round(model2_astro$coefficients[2],3)),
                    "p_val=",round(pvalmat(list(model2_astro), c("astrocyte_reference","astrocyte_difference"))[1],4)))
legend("bottom", paste("diff_coef=",as.character(diff_c3), "p=",as.character(diff_p3)))
#legend("right", paste("red = only ", group_regress))
astro_title <- paste("astro", goi_name, "red is ",group_regress)#title for auto save file

#oligo
diff_c4 <- as.character(round(model2_oligo$coefficients[3],3))
diff_p4 <- round(pvalmat(list(model2_oligo), c("oligo_reference","oligo_difference"))[2],4)


#X11()
model2_oligo_plot<-crplot(model2_oligo, "oligo_reference", g="oligo_difference",newplot = F)
title(paste("oligo", goi_name, "red = ",group_regress))
legend("top", paste("coef=",as.character(round(model2_oligo$coefficients[2],3)),
                    "p_val=",round(pvalmat(list(model2_oligo), c("oligo_reference","oligo_difference"))[1],4)))
legend("bottom", paste("diff_coef=",as.character(diff_c4), "p=",as.character(diff_p4)))
#legend("right", paste("red = only ", group_regress))
oligo_title <- paste("oligo", goi_name, "red is ",group_regress)#title for auto save file




