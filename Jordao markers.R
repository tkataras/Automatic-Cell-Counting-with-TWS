library("purrr")
#install.packages("dplyr")
library(dplyr)
#install.packages("tidyr")
library(tidyr)

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

#install.packages("Rcurl")
library(ggplot2)

library(gtable)
# install.packages("gridExtra")
library(gridExtra)

library("ggcorrplot")

#library("oligo")

####introduce experimental data, need to use fcn to create exprl var
geo = 'GSE47029'

#geop <- getGEO(GEO=geo, destdir=".")
#geop <- getGEO('GSE47029',destdir="C:/Users/User/Desktop/kaul_lab_work/decon") # in the first run
geop <- getGEO('GSE47029',filename="C:/Users/User/Desktop/kaul_lab_work/decon/GSE47029_series_matrix.txt.gz")

#un-neg log expression data, row = gene, col~samples
#exprl=2^exprs(geop)
#trying w/o antilog this time
exprl=exprs(geop)


#remove NA rows
exprl2 <- na.omit(exprl)
exprl <- exprl2


####need informatin to drop out the same NA rows that exprl dropped out
#information <- pData(phenoData(geop [["GSE47029_series_matrix.txt.gz"]]))
information <- pData(phenoData(geop))

common <-intersect(information$geo_accession,colnames(exprl))

info2 <- information[common,]
information <- info2

exprl_no_gp120 <- exprl[,information$`genotype:ch1` == "WT" | information$`genotype:ch1` == "CCR5KO"]
exprl_no_ccr <- exprl[,information$`genotype:ch1` == "WT" | information$`genotype:ch1` == "gp120"]
exprl_only_wt <- exprl[,information$`genotype:ch1` == "WT"]

exprl_only_gp120 <- exprl[,information$`genotype:ch1` == "gp120"]
exprl_only_ccr5ko <- exprl[,information$`genotype:ch1` == "CCR5KO"]
exprl_only_ccr5ko_gp120 <-exprl[,information$`genotype:ch1` == "CCR5KO_x_gp120"]
#SPECIFY FINAL EXPRL HERE


exprl <- exprl_only_wt
exprl <- exprl_only_ccr5ko


###taking our all but wt and gp120 for the info file
common <-intersect(information$geo_accession,colnames(exprl))

info2 <- information[common,]
information <- info2


#Microglia
#micro_genes <- c("Tmem229", "Hexb", "Slc2a5", "P2ry12", "Siglech", "Trem2")
micro_genes <- c( "Hexb", "Slc2a5", "P2ry12", "Siglech", "Trem2")# no tmem229
microglia_probesets=mapIds(illuminaMousev2.db, keys=micro_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
microglia_probesets[[4]] <- microglia_probesets[[4]][-2]

microglia_reference <- marker(exprl, microglia_probesets)

#CNS_assoc_macrophages
CNS_assoc_m_genes <- c("Mrc1", "Lyve1", "Cd163", "Siglec1")
CNS_assoc_m_probesets=mapIds(illuminaMousev2.db, keys=CNS_assoc_m_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
CNS_assoc_m_probesets[[3]] <- CNS_assoc_m_probesets[[3]][-1]

CNS_assoc_m_reference <- marker(exprl,CNS_assoc_m_probesets)

#Monocyte_derived
#Monocyte_derived_genes <- c("Ly6c2", "Ccr2", "Plac8", "Anxa8", "Nr4a1") #Ly6c2 is null, Ccr2 unmatched marker 
Monocyte_derived_genes <- c("Plac8","Anxa8", "Nr4a1")# anxa8 marker 1 only is present, other two probesets unrestricted
Monocyte_derived_probesets=mapIds(illuminaMousev2.db, keys=Monocyte_derived_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
Monocyte_derived_probesets[[2]] <- Monocyte_derived_probesets[[2]][-2]
Monocyte_derived_reference <- marker(exprl, Monocyte_derived_probesets)

#Dendritic_cells
#Dendritic_cell_genes <- c("Flt3", "Sbtb46", "Batf3", "Itgae", "Clec9a")
Dendritic_cell_genes <- c( "Batf3", "Itgae", "Clec9a")# no Sbtb46 markers at all, no FLT3 in exprl

Dendritic_cell_probesets=mapIds(illuminaMousev2.db, keys=Dendritic_cell_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
#need to remove string element 3 and5 form Itgae, 

Dendritic_cell_probesets[[2]] <- Dendritic_cell_probesets[[2]][-3]
Dendritic_cell_probesets[[2]] <- Dendritic_cell_probesets[[2]][-4]

# need WITH Clec9a string 3
Dendritic_cell_probesets[[3]] <- Dendritic_cell_probesets[[2]][3]
Dendritic_cell_reference <- marker(exprl, Dendritic_cell_probesets)





############Print marker correlation chart
markers_probesets=c(unlist(microglia_probesets),unlist(CNS_assoc_m_probesets),unlist(Monocyte_derived_probesets),unlist(Dendritic_cell_probesets))


markers_exprl=exprl[markers_probesets,]

rownames(markers_exprl)=names(markers_probesets)



marker_cor <- as.matrix(cor(t(markers_exprl),method="pearson"))
X11()
hc <- F
print(ggcorrplot(marker_cor, colors = c("blue", "white", "red"), lab=TRUE, hc.order = hc))






####this looks for the gene id in tst in the illumina mouse db and then the GEO data in use
tst = "Siglec1"
goi_test=mapIds(illuminaMousev2.db, keys=tst, column='PROBEID', keytype='SYMBOL',multiVals="list")
goi_test
sum(goi_test[[1]][1] == rownames(exprl))# checks for the chosen probe in the loaded exprl data


#this isnt working, dont know why
for (i in 1:length(goi_test)){
sum(goi_test[[1]][i] == rownames(exprl))# checks for the chosen probe in the loaded exprl data
5
    }







lcn2_goi <- "ILMN_2712075"
CysLTR1_goi <- "ILMN_2680770"
ltc4s_goi <- "ILMN_2658687"
Ifna1_goi1 <- "ILMN_1233604"
Ifna1_goi2 <- "ILMN_2617487"
Ifna1_goi3 <- "ILMN_2858639"
Ifna7_goi <- "ILMN_2658633" #not in data sample
Ifnb1_goi <- "ILMN_2711910"#not in data sample

AMPKa1_goi <- "ILMN_1233439"
mbp1_goi <- "ILMN_1227299"
Tnfaip3_goi <- "ILMN_1252202" #this should be A20 protein


###specify goi
goi <- lcn2_goi
goi <- Tnfaip3_goi

goi_name=mapIds(illuminaMousev2.db, keys=goi, column='SYMBOL', keytype='PROBEID',multiVals="list")





#Model expression of the goi with combination of reference cell pop signals
model1 <- lm(exprl[goi,] ~ microglia_reference + CNS_assoc_m_reference + Monocyte_derived_reference + Dendritic_cell_reference)

g=NULL#for intercept???



neuro_plot1 = ggplot(data = model1, aes(x = neuron_reference, y = .resid + as.matrix(model1$model[, c("neuron_reference", g)]) %*% model1$coef[c("neuron_reference", g)])) + 
  geom_point() + 
  geom_abline(slope = model1$coefficients[[2]], intercept =  0) +
  annotate("text",x=mean(range(neuron_reference)),y=max(model1$residuals + model1$coefficients[2]),label = paste("coef=",as.character(round(model1$coefficients[2],3))), col="red") +
  annotate("text",x=mean(range(neuron_reference)),y=max(model1$residuals)+ model1$coefficients[2] -max(model1$residuals)/10,
           label = paste("p_val=",round(pvalmat(list(model1), c("neuron_reference","microglia_reference", "astrocyte_reference", "oligo_reference","endoth_reference"))[1],4)), col="red") +
  ylab(paste("CR_",as.character(goi_name)))

#each y values is: residual + ref_value * slope coeff
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



























neuron_genes=c("Nefm", "Mapt")#dropped reln
micro_genes=c("Ccl4", "Cd68", "Ms4a7")#removed aif1, because it is upreg on inflamm
astro_genes=c("Aqp4", "Sox9")#removed gfap, Megf10 # aldh1=astro promoter,sox9 = astro in adult brain, aqp=aquaporin; tried Glt1, but it didnt work, no matches, 
oligo_genes=c("Mog", "Mbp")
endoth_genes=c("Pecam1", "Cd34", "Mfsd2a", "Picalm")


neuron_probesets=mapIds(illuminaMousev2.db, keys=neuron_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
neuron_reference <- marker(exprl, neuron_probesets)

microglia_probesets=mapIds(illuminaMousev2.db, keys=micro_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
# microglia_probesets[[4]] <- microglia_probesets[[4]][-1]#removing the first of 2 elements from list for Ptprc
# microglia_probesets[[4]] <- microglia_probesets[[4]][-1]#removing the second of 2 elements from list for Ptprc
microglia_reference <- marker(exprl, microglia_probesets)

astrocyte_probesets=mapIds(illuminaMousev2.db, keys=astro_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
####hav to make specific changes to probesets here!!!!!!!!!!!!!!!!!######################
#aldh1 probe 4 weak corr with all other aldh1
#astrocyte_probesets[[1]] <- astrocyte_probesets[[1]][-3]
astrocyte_reference  <- marker(exprl, astrocyte_probesets)

oligo_probesets=mapIds(illuminaMousev2.db, keys=oligo_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
#mbp probe 4 shows poor intercorrelation ILMN_3011353
oligo_probesets[[2]] <- oligo_probesets[[2]][-4] 
oligo_reference <- marker(exprl, oligo_probesets)

endoth_probesets=mapIds(illuminaMousev2.db, keys=endoth_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
endoth_reference <- marker(exprl, endoth_probesets)



############Print marker correlation chart
markers_probesets=c(unlist(neuron_probesets),unlist(astrocyte_probesets),unlist(oligo_probesets),unlist(microglia_probesets), unlist(endoth_probesets))


markers_exprl=exprl[markers_probesets,]

rownames(markers_exprl)=names(markers_probesets)



marker_cor <- as.matrix(cor(t(markers_exprl),method="pearson"))
X11()
hc <- F
print(ggcorrplot(marker_cor, colors = c("blue", "white", "red"), lab=TRUE, hc.order = hc))


