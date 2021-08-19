# if (!requireNamespace("BiocManager"))

#   install.packages("BiocManager")

# BiocManager::install()

# BiocManager::install("PSEA", version = "3.8")

# BiocManager::install("AnnotationDbi")

# BiocManager::install("illuminaMousev2.db")


#install.packages("purrr")
library("purrr")
library("GEOquery")

library("AnnotationDbi")

library("PSEA")

library("MASS")

library("illuminaMousev2.db")

# install.packages("BiocManager")
# BiocManager::install("affy", version = "3.8")
library(affy)

# BiocManager::install("annotate", version = "3.8")
library(annotate)





geo = 'GSE47029'
load <- function(geo){
  ####introduce experimental data, need to use fcn to create exprl var
   geop <- getGEO(GEO=geo, destdir=".")
  
  #un-neg log expression data, row = gene, col~samples
  exprl=2^exprs(geop$GSE47029_series_matrix.txt.gz)
  #remove NA rows
  exprl2 <- na.omit(exprl)
  exprl <- exprl2
  return(exprl)
}


exprl <- load(geo)
###remove all CCR5KO animals
information <- pData(phenoData(geop [["GSE47029_series_matrix.txt.gz"]]))

exprl_no_ccr <- exprl[,information$`genotype:ch1` == "WT" | information$`genotype:ch1` == "gp120"]

exprl <- exprl_no_ccr


neuron_genes=c("Nefm", "Reln", "Mapt")# "neurofiliment medium gene, Reelin protein
micro_genes=c("Aif1", "Ccl4")#aif1 = gene for iba1 prot, 
astro_genes=c("Aldh1l1", "Aqp4", "Sox9", "Gfap")# aldh1=astro promoter,sox9 = astro in adult brain, aqp=aquaporin; tried Glt1, but it didnt work, no matches, 
oligo_genes=c("Mog", "Mbp")# myelin oligodendrocyte glycoprotein, Myelin basic protein
endoth_genes=c("Pecam1", "Cd34")

#goi ="ILMN_2712075"#lcn2
goi = "ILMN_2658687" #ltc4s
goi = "ILMN_2491705"
#looking up alternative GOIs

ltc4s_probesets=mapIds(illuminaMousev2.db, keys="Ltc4s", column='PROBEID', keytype='SYMBOL',multiVals="list")
ltc4s_goi <- "ILMN_2658687"

CysLTR1_probesets=mapIds(illuminaMousev2.db, keys="Cysltr1", column='PROBEID', keytype='SYMBOL',multiVals="list")
CysLTR1_goi <- "ILMN_2680770"

Ifnb1_probesets=mapIds(illuminaMousev2.db, keys="Ifnb1", column='PROBEID', keytype='SYMBOL',multiVals="list")
Ifnb1_goi <- "ILMN_2711910"


Ifna7_probesets=mapIds(illuminaMousev2.db, keys="Ifna7", column='PROBEID', keytype='SYMBOL',multiVals="list")
Ifna7_goi <- "ILMN_2658633" #isnt in geo 

Ifna1_probesets=mapIds(illuminaMousev2.db, keys="Ifna1", column='PROBEID', keytype='SYMBOL',multiVals="list")
#### 3 probesets
Ifna1_goi1 <- "ILMN_1233604"
Ifna1_goi2 <- "ILMN_2617487"
Ifna1_goi3 <- "ILMN_2858639"

Ifna4_probesets=mapIds(illuminaMousev2.db, keys="Ifna4", column='PROBEID', keytype='SYMBOL',multiVals="list")
Ifna4_goi <- "ILMN_2738901"

P38a_probesets=mapIds(illuminaMousev2.db, keys="Mapk14", column='PROBEID', keytype='SYMBOL',multiVals="list")
p38a_goi1 = "ILMN_2491705"

PSEA_ref(neuron_genes, micro_genes, astro_genes, oligo_genes, p38a_goi1)

PSEA_ref <- function(neuron_genes, micro_genes, astro_genes, oligo_genes, goi){
  
  ### getting the gene name from chosen probe
  goi_name=mapIds(illuminaMousev2.db, keys=goi, column='SYMBOL', keytype='PROBEID',multiVals="list")
  
  
  
  neuron_probesets=mapIds(illuminaMousev2.db, keys=neuron_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
  neuron_reference <- marker(exprl, neuron_probesets)
  
  microglia_probesets=mapIds(illuminaMousev2.db, keys=micro_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
  microglia_reference <- marker(exprl, microglia_probesets)
  
  astrocyte_probesets=mapIds(illuminaMousev2.db, keys=astro_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
  ####hav to make specific changes to probesets here!!!!!!!!!!!!!!!!!######################
  #aldh1 probe 4 weak corr with all other aldh1
  astrocyte_probesets[[1]] <- astrocyte_probesets[[1]][-3]
  astrocyte_reference  <- marker(exprl, astrocyte_probesets)
  
  oligo_probesets=mapIds(illuminaMousev2.db, keys=oligo_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
  #mbp probe 4 shows poor intercorrelation ILMN_3011353
  oligo_probesets[[2]] <- oligo_probesets[[2]][-4] 
  oligo_reference <- marker(exprl, oligo_probesets)
  
  endoth_probesets=mapIds(illuminaMousev2.db, keys=endoth_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
  endoth_reference <- marker(exprl, endoth_probesets)
  
  
  
  #Model expression of the goi with combination of reference cell pop signals
  model1 <- lm(exprl[goi,] ~ neuron_reference + microglia_reference + astrocyte_reference + oligo_reference + endoth_reference)
  
  
  ##visualise and summarize illumina ref data selected cell type markers on LCN2 in this case
  plot(model1$residuals)
  abline(model1$coefficients[2],1)
  
  
  X11()
  #par(mfrow=c(1,5), cex=1.2)
  par(mfrow=c(1,5))
  
  crplot(model1, "neuron_reference", newplot=F)
  
  
  crplot(model1, "microglia_reference", newplot=FALSE)
  crplot(model1, "astrocyte_reference", newplot=FALSE)
  crplot(model1, "oligo_reference", newplot=FALSE)
  crplot(model1, "endoth_reference", newplot=FALSE)
  
  title(as.character(as.character(goi_name)))
  #legend(1,1,model1$coefficients[2])
  print(summary(model1))
  print(goi)
  
  
}

#doing my own graphing
library(ggplot2)

### getting the gene name from chosen probe again
goi_name=mapIds(illuminaMousev2.db, keys=goi, column='SYMBOL', keytype='PROBEID',multiVals="list")


# ggplot(model1, aes(x = neuron_reference, y = .resid)) + geom_point() + geom_abline() + annotate("text",x=1,y=-1,label = as.character(round(model1$coefficients[2],3)))

g=NULL
# rpc <- residuals(model1) + as.matrix(model1$model[, c("neuron_reference", g)]) %*% model1$coef[c("neuron_reference", g)]
# rpc <- as.numeric(rpc)
# 
# frame1 <- data.frame(neuron_reference, rpc)
# ggplot(frame1, aes(x = neuron_reference, y = rpc)) + geom_point()

### correct ggplot2 model code
neuro_plot1 = ggplot(data = model1, aes(x = neuron_reference, y = .resid + as.matrix(model1$model[, c("neuron_reference", g)]) %*% model1$coef[c("neuron_reference", g)])) + 
  geom_point() + 
  geom_abline(slope = model1$coefficients[[2]], intercept =  0) +
  annotate("text",x=mean(range(neuron_reference)),y=max(model1$residuals + model1$coefficients[2]),label = paste("coef=",as.character(round(model1$coefficients[2],3))), col="red") +
  annotate("text",x=mean(range(neuron_reference)),y=max(model1$residuals)+ model1$coefficients[2] -max(model1$residuals)/10,
           label = paste("p_val=",round(pvalmat(list(model1), c("neuron_reference","microglia_reference", "astrocyte_reference", "oligo_reference","endoth_reference"))[1],4)), col="red") +
  ylab(paste("CR_",as.character(goi_name)))


micro_plot1 = ggplot(model1, aes(x = microglia_reference, y = .resid + as.matrix(model1$model[, c("microglia_reference", g)]) %*% model1$coef[c("microglia_reference", g)])) + 
  geom_point() +  
  geom_abline(slope = model1$coefficients[[3]], intercept =  0) +
  annotate("text",x=mean(range(microglia_reference)),y=max(model1$residuals + model1$coefficients[3]),label = paste("coef=",as.character(round(model1$coefficients[3],3))), col="red") +
  annotate("text",x=mean(range(microglia_reference)),y=max(model1$residuals)+ model1$coefficients[3]-max(model1$residuals)/10,
           label = paste("p_val=",round(pvalmat(list(model1), c("neuron_reference","microglia_reference", "astrocyte_reference", "oligo_reference","endoth_reference"))[2],4)), col="red") +
  ylab(paste("CR_",as.character(goi_name)))
  

astro_plot1 = ggplot(model1, aes(x = astrocyte_reference, y = .resid + as.matrix(model1$model[, c("astrocyte_reference", g)]) %*% model1$coef[c("astrocyte_reference", g)])) + 
  geom_point() + 
  geom_abline(slope = model1$coefficients[[4]], intercept =  0) +
  annotate("text",x=mean(range(astrocyte_reference)),y=max(model1$residuals + model1$coefficients[4]),label = paste("coef=",as.character(round(model1$coefficients[4],3))), col="red") +
  annotate("text",x=mean(range(astrocyte_reference)),y=max(model1$residuals)+ model1$coefficients[4]-max(model1$residuals)/10,
           label = paste("p_val=",round(pvalmat(list(model1), c("neuron_reference","microglia_reference", "astrocyte_reference", "oligo_reference","endoth_reference"))[3],4)), col="red") +
  ylab(paste("CR_",as.character(goi_name)))


oligo_plot1 = ggplot(model1, aes(x = oligo_reference, y = .resid + as.matrix(model1$model[, c("oligo_reference", g)]) %*% model1$coef[c("oligo_reference", g)])) + 
  geom_point() + 
  geom_abline(slope = model1$coefficients[[5]], intercept =  0) +
  annotate("text",x=mean(range(oligo_reference)),y=max(model1$residuals + model1$coefficients[5]),label = paste("coef=",as.character(round(model1$coefficients[5],3))), col="red") +
  annotate("text",x=mean(range(oligo_reference)),y=max(model1$residuals)+ model1$coefficients[5]-max(model1$residuals)/10,
           label = paste("p_val=",round(pvalmat(list(model1), c("neuron_reference","microglia_reference", "astrocyte_reference", "oligo_reference","endoth_reference"))[4],4)), col="red") +
  ylab(paste("CR_",as.character(goi_name)))


endoth_plot1 = ggplot(model1, aes(x = endoth_reference, y = .resid + as.matrix(model1$model[, c("endoth_reference", g)]) %*% model1$coef[c("endoth_reference", g)])) + 
  geom_point() + 
  geom_abline(slope = model1$coefficients[[6]], intercept =  0) +
  annotate("text",x=mean(range(oligo_reference)),y=max(model1$residuals + model1$coefficients[6]),label = paste("coef=",as.character(round(model1$coefficients[6],3))), col="red") +
  annotate("text",x=mean(range(oligo_reference)),y=max(model1$residuals)+ model1$coefficients[6]-max(model1$residuals)/10,
           label = paste("p_val=",round(pvalmat(list(model1), c("neuron_reference","microglia_reference", "astrocyte_reference", "oligo_reference", "endoth_reference"))[5],4)), col="red") +
  ylab(paste("CR_",as.character(goi_name)))





library(gtable)
# install.packages("gridExtra")
library(gridExtra)
X11()
grid.arrange(neuro_plot1,micro_plot1,astro_plot1,oligo_plot1,endoth_plot1, nrow = 1)





str(summary(model1))
  f <- summary(model1)$fstatistic
p <- pf(f[1],f[2],f[3],lower.tail=F)
  names(model1)
  model1$model


ggplot(d, aes(x = hp, y = mpg)) +
  geom_point() +
  geom_point(aes(y = predicted), shape = 1)



















information <- pData(phenoData(geop [["GSE47029_series_matrix.txt.gz"]]))

goi ="ILMN_2712075"

####need to restrict information to no ccrko just like exprl, row and col are swaped from exprl (eg in info GSM sample id = row)
information_no_ccr <- information[information$`genotype:ch1` == "WT" | information$`genotype:ch1` == "gp120",]


groups <- as.numeric(information_no_ccr$`Sex:ch1`== "M")
groups_gp120 <- as.numeric(information_no_ccr$`genotype:ch1` == "gp120")

#groups <- groups_gp120

groups2 <-as.numeric(information$`Sex:ch1`== "F")
#groups <- as.numeric(information$)


PSEA_diff <- function(neuron_genes, micro_genes, astro_genes, oligo_genes,goi, exprl, groups){
  
  
  
  ### getting the gene name from chosen probe
  goi_name=mapIds(illuminaMousev2.db, keys=goi, column='SYMBOL', keytype='PROBEID',multiVals="list")
  
  
  neuron_probesets=mapIds(illuminaMousev2.db, keys=neuron_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
  neuron_reference <- marker(exprl, neuron_probesets)
  
  microglia_probesets=mapIds(illuminaMousev2.db, keys=micro_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
  microglia_reference <- marker(exprl, microglia_probesets)
  
  astrocyte_probesets=mapIds(illuminaMousev2.db, keys=astro_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
  ####hav to make specific changes to probesets here!!!!!!!!!!!!!!!!!######################
  #aldh1 probe 4 weak corr with all other aldh1
  astrocyte_probesets[[1]] <- astrocyte_probesets[[1]][-3]
  astrocyte_reference  <- marker(exprl, astrocyte_probesets)
  
  oligo_probesets=mapIds(illuminaMousev2.db, keys=oligo_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
  #mbp probe 4 shows poor intercorrelation ILMN_3011353
  oligo_probesets[[2]] <- oligo_probesets[[2]][-4] 
  oligo_reference <- marker(exprl, oligo_probesets)
  
  
  
  
  neuron_difference <- groups * neuron_reference
  microglia_difference <- groups * microglia_reference
  astrocyte_difference <- groups * astrocyte_reference
  oligo_difference <- groups * oligo_reference
  
  
  model2_neuro <- lm(exprl[goi,] ~ neuron_reference +  neuron_difference)
  X11()
  crplot(model2_neuro, "neuron_reference", g="neuron_difference")
  title("Neuron")
  legend()
  print(summary(model2_neuro))
  
  model2_micro <- lm(exprl[goi,] ~ microglia_reference + microglia_difference)
  X11()
  crplot(model2_micro, "microglia_reference", g="microglia_difference")
  title("Microglia")
  print(summary(model2_micro))
  
  model2_astro <- lm(exprl[goi,] ~ astrocyte_reference + astrocyte_difference)
  X11()
  crplot(model2_astro, "astrocyte_reference", g="astrocyte_difference")
  title("Astrocyte")
  print(summary(model2_astro))
  
  model2_oligo <- lm(exprl[goi,] ~ oligo_reference + oligo_difference)
  X11()
  crplot(model2_oligo, "oligo_reference", g="oligo_difference")
  title("Oligodendrocyte")
  print(summary(model2_oligo))
  print(goi)
  
  
  
}

PSEA_diff(neuron_genes, micro_genes, astro_genes, oligo_genes, goi, exprl, groups_gp120)
###figure out why blank windows







