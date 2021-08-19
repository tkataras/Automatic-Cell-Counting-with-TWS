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

library(ggplot2)

library(gtable)
# install.packages("gridExtra")
library(gridExtra)

library("ggcorrplot")

library("oligo")#no package called oligo, is ok

####introduce experimental data, need to use fcn to create exprl var
geo = 'GSE47029'

#geop <- getGEO(GEO=geo, destdir=".")
#geop <- getGEO('GSE47029',destdir="C:/Users/User/Desktop/kaul_lab_work/decon") # in the first run
geop <- getGEO('GSE47029',filename="C:/Users/User/Desktop/kaul_lab_work/decon/GSE47029_series_matrix.txt.gz")

#un-neg log expression data, row = gene, col~samples
exprl=2^exprs(geop)


####trying to do RMA normalization with the GEO data, sadly rma fucntion exprect affybatch object
#trying RMA through the oligo package
untar("GSE47029_RAW.tar", exdir = "raw_data")
geop_raw <- getGEO('GSE47029',filename="C:/Users/User/Desktop/kaul_lab_work/decon/raw_data/GPL6887_MouseWG-6_V2_0_R3_11278593_A.txt.gz")

geop_raw <- getGEO('GSE47029_RAW')


cels = list.files("raw_data/", pattern = "CEL")

geo_sup <- getGEOSuppFiles("GSE47029")

raw.data = ReadAffy(verbose = FALSE, filenames = cels, cdfname = "hgu133acdf")
exprl_rma = 2^exprs(rma(geop))
rma_test <- rma((geop))





#remove NA rows
exprl2 <- na.omit(exprl)
exprl <- exprl2


####need informatin to drop out the same NA rows that exprl dropped out
#information <- pData(phenoData(geop [["GSE47029_series_matrix.txt.gz"]]))
information <- pData(phenoData(geop))

common <-intersect(information$geo_accession,colnames(exprl))

info2 <- information[common,]
information <- info2

exprl_no_ccr <- exprl[,information$`genotype:ch1` == "WT" | information$`genotype:ch1` == "gp120"]

exprl_no_gp120 <- exprl[,information$`genotype:ch1` == "WT" | information$`genotype:ch1` == "CCR5KO"]
exprl_only_wt <- exprl[,information$`genotype:ch1` == "WT"]

exprl_only_gp120 <- exprl[,information$`genotype:ch1` == "gp120"]
exprl_only_ccr5ko <- exprl[,information$`genotype:ch1` == "CCR5KO"]
exprl_only_ccr5ko_gp120 <-exprl[,information$`genotype:ch1` == "CCR5KO_x_gp120"]
#SPECIFY FINAL EXPRL HERE

exprl <- exprl_only_ccr5ko_gp120

exprl <- exprl_only_ccr5ko

exprl <- exprl_only_gp120
exprl <- exprl_only_wt

exprl <- exprl_no_gp120
###taking our all but wt and gp120 for the info file
common <-intersect(information$geo_accession,colnames(exprl))

info2 <- information[common,]
information <- info2


lcn_goi <- "ILMN_2712075"

p38a_goi1 = "ILMN_2491705"
goi <- lcn_goi
  
  
  neuron_genes=c("Nefm", "Reln", "Mapt")# "neurofiliment medium gene, Reelin protein
  micro_genes=c("Aif1", "Ccl4", "Cd68")#aif1 = gene for iba1 prot, **Ptprc in GEO marker for inflam
  astro_genes=c("Aldh1l1", "Aqp4", "Sox9")#removed gfap, Megf10 # aldh1=astro promoter,sox9 = astro in adult brain, aqp=aquaporin; tried Glt1, but it didnt work, no matches, 
  oligo_genes=c("Mog", "Mbp")# myelin oligodendrocyte glycoprotein, Myelin basic protein
  endoth_genes=c("Pecam1", "Cd34", "Mfsd2a", "Picalm")
  



#groups <- as.numeric(information$`Sex:ch1`== "M")
#groups <- as.numeric(information$`genotype:ch1` =="WT")
group_ok <- "CCR5KO" 
groups <- as.numeric(information$`genotype:ch1` == group_ok)

groups2 <- as.numeric(information$`genotype:ch1` == "WT")


save_loc <- "C:/Users/User/Desktop/Kaul_lab_work/decon/graphs/"

####################run all of above first before using fcn. need to fix that!!!!!


PSEA_ref <- function(neuron_genes, micro_genes, astro_genes, oligo_genes, endoth_genes, goi, groups, group_ok){
  
  ### getting the gene name from chosen probe
  goi_name=mapIds(illuminaMousev2.db, keys=goi, column='SYMBOL', keytype='PROBEID',multiVals="list")
  
  
  
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
  #oligo_probesets[[2]] <- oligo_probesets[[2]][-4] 
  oligo_reference <- marker(exprl, oligo_probesets)
  
  endoth_probesets=mapIds(illuminaMousev2.db, keys=endoth_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
  endoth_reference <- marker(exprl, endoth_probesets)
  
  
  
  #Model expression of the goi with combination of reference cell pop signals
  model1 <- lm(exprl[goi,] ~ neuron_reference + microglia_reference + astrocyte_reference + oligo_reference + endoth_reference)
  
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
  
  
  endoth_plot1 = ggplot(model1, aes(x = endoth_reference, y = .resid + as.matrix(model1$model[, c("endoth_reference", g)]) %*% model1$coef[c("endoth_reference", g)])) + 
    geom_point() + 
    geom_abline(slope = model1$coefficients[[6]], intercept =  0) +
    annotate("text",x=mean(range(oligo_reference)),y=max(model1$residuals + model1$coefficients[6]),label = paste("coef=",as.character(round(model1$coefficients[6],3))), col="red") +
    annotate("text",x=mean(range(oligo_reference)),y=max(model1$residuals)+ model1$coefficients[6]-max(model1$residuals)/10,
             label = paste("p_val=",round(pvalmat(list(model1), c("neuron_reference","microglia_reference", "astrocyte_reference", "oligo_reference", "endoth_reference"))[5],4)), col="red") +
    ylab(paste("CR_",as.character(goi_name)))
  
  
  
  
  
  # ##visualise and summarize illumina ref data selected cell type markers on LCN2 in this case
  # plot(model1$residuals)
  # abline(model1$coefficients[2],1)
  # 
  
  X11()
  grid.arrange(neuro_plot1,micro_plot1,astro_plot1,oligo_plot1,endoth_plot1, nrow = 1)
  jpeg(paste(save_loc, goi_name))
  # #par(mfrow=c(1,5), cex=1.2)
  # par(mfrow=c(1,5))
  # 
  # crplot(model1, "neuron_reference", newplot=F)
  # 
  # 
  # crplot(model1, "microglia_reference", newplot=FALSE)
  #crplot(model1, "astrocyte_reference", newplot=FALSE)
  # crplot(model1, "oligo_reference", newplot=FALSE)
  # crplot(model1, "endoth_reference", newplot=FALSE)
  # 
  # title(as.character(as.character(goi_name)))
  # #legend(1,1,model1$coefficients[2])
  print(summary(model1))
  #print(goi)
  
  
  
  #####difference 
  
  #### x_difference data is just the male samples, females set to 0
  neuron_difference <- groups * neuron_reference
  microglia_difference <- groups * microglia_reference
  astrocyte_difference <- groups * astrocyte_reference
  oligo_difference <- groups * oligo_reference
  endoth_difference <- groups * endoth_reference
  
  
  
  # ####attempting my own ggplot2 CR plot, having trouble
  # model2_neuro_plot1 = ggplot(model2_neuro, aes(x = neuron_reference, y = .resid + as.matrix(model2_neuro$model[, c("neuron_reference", g)]) %*% model1$coef[c("neuron_reference", g)])) + 
  #   geom_point() +
  #   geom_point() +
  #   geom_abline(slope = model2_neuro$coefficients[[2]], intercept =  0) +
  #   geom_abline(slope = model2_neuro$coefficients[[3]], intercept =  0, col="blue") +
  #   annotate("text",x=mean(range(neuron_reference)),y=max(model2_neuro$residuals + model2_neuro$coefficients[2]),label = paste("coef=",as.character(round(model2_neuro$coefficients[2],3))), col="red") +
  #   annotate("text",x=mean(range(neuron_reference)),y=max(model1$residuals)+ model1$coefficients[6]-max(model1$residuals)/10,
  #            label = paste("p_val=",round(pvalmat(list(model2_neuro), c("neuron_reference","neuron_difference"))[1],2)), col="red") +
  #   ylab(paste("CR_",as.character(goi_name))) + 
  #   annotate("text",x=mean(range(neuron_reference))+.5*mean(range(neuron_reference)),y=max(model2_neuro$residuals + model2_neuro$coefficients[3]),label = paste("diff_coef=",as.character(round(model2_neuro$coefficients[3],3))), col="red") +
  #   annotate("text",x=mean(range(neuron_reference))+.5*mean(range(neuron_reference)),y=max(model2_neuro$residuals)+ model2_neuro$coefficients[3]-max(model2_neuro$residuals)/10,
  #            label = paste("diff_p_val=",round(pvalmat(list(model2_neuro), c("neuron_reference","neuron_difference"))[2],2)), col="red") 
  #   
  # 
  
  titles <- c(neuro_title, micro_title, astro_title, oligo_title, endoth_title)
  #plots <- c(model2_neuro_plot, model2_micro_plot, model2_astro_plot, model2_oligo_plot, model2_endoth_plot)
  
  #trying par to get all graphs at once
  X11()
  par(mfrow=c(1,5))
  
  model2_neuro <- lm(exprl[goi,] ~ neuron_reference + neuron_difference)
  
  diff_c <- as.character(round(model2_neuro$coefficients[3],3))
  diff_p <- round(pvalmat(list(model2_neuro), c("neuron_reference","neuron_difference"))[2],4)
  
  neuro_title <- paste("neuro", goi_name, "red is ",group_ok)#title for auto save file
  X11() 
  model2_neuro_plot<- crplot(model2_neuro, "neuron_reference", g="neuron_difference",newplot = F)
  title(paste("Neuron", goi_name, "red = ",group_ok))
  legend("top", paste("coef=",as.character(round(model2_neuro$coefficients[2],3)),
                      "p_val=",round(pvalmat(list(model2_neuro), c("neuron_reference","neuron_difference"))[1],4)))
  legend("left", paste("diff_coef=",as.character(diff_c), "p=",as.character(diff_p)))
  legend("right", paste("red = only ", group_ok))
  

  
  #model2_neuro_plot_test<- crplot(model2_neuro, "neuron_reference", newplot = F)
  
  
  
  
  
  
  model2_micro <- lm(exprl[goi,] ~ microglia_reference +  microglia_difference)
  
  diff_c2 <- as.character(round(model2_micro$coefficients[3],3))
  diff_p2 <- round(pvalmat(list(model2_micro), c("microglia_reference","microglia_difference"))[2],4)
  
  X11()
  model2_micro_plot<- crplot(model2_micro, "microglia_reference", g="microglia_difference", newplot = F)
  title(paste("microglia", goi_name, "red = ",group_ok))
  legend("top", paste("coef=",as.character(round(model2_micro$coefficients[2],3)),
                      "p_val=",round(pvalmat(list(model2_micro), c("microglia_reference","microglia_difference"))[1],4)))
  legend("left", paste("diff_coef=",as.character(diff_c2), "p=",as.character(diff_p2)))
  legend("right", paste("red = only ", group_ok))
  micro_title <- paste("micro", goi_name, "red is ",group_ok)#title for auto save file
  


  
  
  model2_astro <- lm(exprl[goi,] ~ astrocyte_reference +  astrocyte_difference)
  
  diff_c3 <- as.character(round(model2_astro$coefficients[3],3))
  diff_p3 <- round(pvalmat(list(model2_astro), c("astrocyte_reference","astrocyte_difference"))[2],4)
  
  
  X11()
  model2_astro_plot<-crplot(model2_astro, "astrocyte_reference", g="astrocyte_difference",newplot = F)
  title(paste("astrocyte", goi_name, "red = ",group_ok))
  legend("top", paste("coef=",as.character(round(model2_astro$coefficients[2],3)),
                      "p_val=",round(pvalmat(list(model2_astro), c("astrocyte_reference","astrocyte_difference"))[1],4)))
  legend("left", paste("diff_coef=",as.character(diff_c3), "p=",as.character(diff_p3)))
  legend("right", paste("red = only ", group_ok))
  astro_title <- paste("astro", goi_name, "red is ",group_ok)#title for auto save file
  
  
  model2_oligo <- lm(exprl[goi,] ~ oligo_reference +  oligo_difference)
  
  diff_c4 <- as.character(round(model2_oligo$coefficients[3],3))
  diff_p4 <- round(pvalmat(list(model2_oligo), c("oligo_reference","oligo_difference"))[2],4)
  
  
  X11()
  model2_oligo_plot<-crplot(model2_oligo, "oligo_reference", g="oligo_difference",newplot = F)
  title(paste("oligo", goi_name, "red = ",group_ok))
  legend("top", paste("coef=",as.character(round(model2_oligo$coefficients[2],3)),
                      "p_val=",round(pvalmat(list(model2_oligo), c("oligo_reference","oligo_difference"))[1],4)))
  legend("left", paste("diff_coef=",as.character(diff_c4), "p=",as.character(diff_p4)))
  legend("right", paste("red = only ", group_ok))
  oligo_title <- paste("oligo", goi_name, "red is ",group_ok)#title for auto save file
  
  
  # #testing, remove after################################################################################
  # model2test_oligo <- lm(exprl[goi,]~oligo_reference)
  # model2_oligo_test <-crplot(model2test_oligo, "oligo_reference")
  # 
  # groups2 <- !groups
  # oligo_difference2 <- groups2 * oligo_reference
  # model2test_oligo2 <- lm(exprl[goi,]~oligo_reference + oligo_difference2)
  # model2_oligo_test2 <-crplot(model2test_oligo2, "oligo_reference", g = "oligo_difference2")
  # 
  # 
  # mode_test <- lm(exprl[goi,]~oligo_difference + oligo_difference2)
  # modetest_graph <- crplot(mode_test, "oligo_difference", g = "oligo_difference2")


  #X11() 
  
  model2_endoth <- lm(exprl[goi,] ~ endoth_reference +  endoth_difference)
  
  diff_c4 <- as.character(round(model2_endoth$coefficients[3],3))
  diff_p4 <- round(pvalmat(list(model2_endoth), c("endoth_reference","endoth_difference"))[2],4)
  
  
  X11()
  model2_endoth_plot<-crplot(model2_endoth, "endoth_reference", g="endoth_difference",newplot = F)
  title(paste("endoth", goi_name, "red = ",group_ok))
  legend("top", paste("coef=",as.character(round(model2_endoth$coefficients[2],3)),
                      "p_val=",round(pvalmat(list(model2_endoth), c("endoth_reference","endoth_difference"))[1],4)))
  legend("left", paste("diff_coef=",as.character(diff_c4), "p=",as.character(diff_p4)))
  legend("right", paste("red = only ", group_ok))
  endoth_title <- paste("endoth", goi_name, "red is ",group_ok)#title for auto save file
  
  ####writing all the plots to jpg files automatically, save
  # plot_name = neuro_title
  # 
   
  # for(plot_name in 1:length(plots))){
  #   jpeg(paste(save_loc,plot_name))
  # }
  # 
  blah <- paste(save_loc, titles[1])
   

  
  
  ########trying to throw them all on one graph, not working
  
  X11()
  par(mfrow=c(1,5), cex=1.2)
  model2_neuro_plot
  model2_micro_plot
  model2_astro_plot
  model2_oligo_plot
  model2_endoth_plot
  
  ############Print marker correlation chart
  markers_probesets=c(unlist(neuron_probesets),unlist(astrocyte_probesets),unlist(oligo_probesets),unlist(microglia_probesets), unlist(endoth_probesets))
  
  
  markers_exprl=exprl[markers_probesets,]
  
  rownames(markers_exprl)=names(markers_probesets)
  
  
  
  marker_cor <- as.matrix(cor(t(markers_exprl),method="pearson"))
  X11()
  hc <- F
  print(ggcorrplot(marker_cor, colors = c("blue", "white", "red"), lab=TRUE, hc.order = hc))
  
  
  
}



PSEA_ref(neuron_genes, micro_genes, astro_genes, oligo_genes,endoth_genes, lcn2_goi, groups, group_ok)
lcn2_goi <- "ILMN_2712075"
CysLTR1_goi <- "ILMN_2680770"
ltc4s_goi <- "ILMN_2658687"
Ifna1_goi1 <- "ILMN_1233604"
Ifna1_goi2 <- "ILMN_2617487"
Ifna1_goi3 <- "ILMN_2858639"
Ifna7_goi <- "ILMN_2658633" #not in data sample
Ifnb1_goi <- "ILMN_2711910"

# 
# X11()
# plot(exprl[unlist(goi),] ~ neuron_reference)

# ####testing stuff
# neuro_plot1_test = ggplot(data = model1, aes(x = neuron_reference, y = .resid %*% model1$coef[c("neuron_reference", g)])) + 
#   geom_point() + 
#   geom_abline(slope = model1$coefficients[[2]], intercept =  0) +
#   annotate("text",x=mean(range(neuron_reference)),y=max(model1$residuals + model1$coefficients[2]),label = paste("coef=",as.character(round(model1$coefficients[2],3))), col="red") +
#   annotate("text",x=mean(range(neuron_reference)),y=max(model1$residuals)+ model1$coefficients[2] -max(model1$residuals)/10,
#            label = paste("p_val=",round(pvalmat(list(model1), c("neuron_reference","microglia_reference", "astrocyte_reference", "oligo_reference","endoth_reference"))[1],4)), col="red") +
#   ylab(paste("CR_",as.character(goi_name)))
# 
# 
# 
# ##looking into the diff cr plots, what exactly are the dots of 2 colors
# ggplot(model2_neuro, aes(x = neuron_difference + neuron_reference, y = exprl[goi,])) + geom_point()
# 






#plotting all basic ref vs goi exprl
X11()
#par(mfrow=c(1,5))
plot(exprl[goi,] ~ neuron_reference)
#abline(lm(exprl[goi,] ~ neuron_reference))
abline(lm(exprl[goi,] ~ neuron_reference + microglia_reference + astrocyte_reference + oligo_reference + endoth_reference))
summary(lm(exprl[goi,] ~ neuron_reference))
plot(exprl[goi,] ~ microglia_reference)
plot(exprl[goi,] ~ astrocyte_reference)
plot(exprl[goi,] ~ oligo_reference)
plot(exprl[goi,] ~ endoth_reference)

test model

X11()
install.packages("car")
library(car)
crPlots(model1)






mapIds(illuminaMousev2.db, keys="Picalm", column='PROBEID', keytype='SYMBOL',multiVals="list")
