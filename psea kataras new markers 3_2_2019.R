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

#geop <- getGEO(GEO=geo, destdir=".")
#geop <- getGEO('GSE47029',destdir="C:/Users/User/Desktop/kaul_lab_work/decon") # in the first run
geop <- getGEO('GSE47029',filename="C:/Users/User/Desktop/kaul_lab_work/decon/GSE47029_series_matrix.txt.gz")


#un-neg log expression data, row = gene, col~samples
exprl=2^exprs(geop)

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



exprl_no_gp120 <- exprl[,information$`genotype:ch1` == "WT" | information$`genotype:ch1` == "CCR5KO"]
exprl_no_ccr <- exprl[,information$`genotype:ch1` == "WT" | information$`genotype:ch1` == "gp120"]
exprl_only_wt <- exprl[,information$`genotype:ch1` == "WT"]
exprl_gp120_double <- exprl[,information$`genotype:ch1` == "gp120" | information$`genotype:ch1` == "CCR5KO_x_gp120"]


exprl_only_gp120 <- exprl[,information$`genotype:ch1` == "gp120"]
exprl_only_ccr5ko <- exprl[,information$`genotype:ch1` == "CCR5KO"]
exprl_only_ccr5ko_gp120 <-exprl[,information$`genotype:ch1` == "CCR5KO_x_gp120"]

exprl_no_ccr_only_LAV <- exprl[,information$`genotype:ch1` == "WT" & information$`strain:ch1` == "LAV" | information$`genotype:ch1` == "gp120" & information$`strain:ch1` == "LAV" ]
exprl_no_ccr_only_HIPEX <- exprl[,information$`genotype:ch1` == "WT" & information$`strain:ch1` == "HIPEX" | information$`genotype:ch1` == "gp120" & information$`strain:ch1` == "HIPEX" ]
exprl_gp120_double_only_LAV <- exprl[,information$`genotype:ch1` == "gp120" & information$`strain:ch1` == "LAV"| information$`genotype:ch1` == "CCR5KO_x_gp120"& information$`strain:ch1` == "LAV"]
exprl_gp120_double_only_HIPEX <- exprl[,information$`genotype:ch1` == "gp120" & information$`strain:ch1` == "HIPEX"| information$`genotype:ch1` == "CCR5KO_x_gp120" & information$`strain:ch1` == "HIPEX"]

exprl_only_wt_LAV <- exprl[,information$`genotype:ch1` == "WT" & information$`strain:ch1` == "LAV"]

exprl_only_gp120_LAV <- exprl[,information$`genotype:ch1` == "gp120" & information$`strain:ch1` == "LAV"]

exprl_only_wt_HIPEX <- exprl[,information$`genotype:ch1` == "WT" & information$`strain:ch1` == "HIPEX"]
exprl_only_gp120_HIPEX <- exprl[,information$`genotype:ch1` == "gp120" & information$`strain:ch1` == "HIPEX"]

exprl_only_wtF_HIPEX <- exprl[,information$`genotype:ch1` == "WT" & information$`strain:ch1` == "HIPEX" & information$`Sex:ch1` == "F"]
exprl_only_wtM_HIPEX <- exprl[,information$`genotype:ch1` == "WT" & information$`strain:ch1` == "HIPEX" & information$`Sex:ch1` == "M"]


exprl_only_double_HIPEX <- exprl[,information$`genotype:ch1` == "CCR5KO_x_gp120" & information$`strain:ch1` == "HIPEX"]

exprl_wt_gp120_HIPEX <- exprl[,information$`genotype:ch1` == "gp120" & information$`strain:ch1` == "HIPEX" | information$`genotype:ch1` == "WT" & information$`strain:ch1` == "HIPEX"]

exprl_wt_CCR5KO_HIPEX <- exprl[,information$`genotype:ch1` == "WT" & information$`strain:ch1` == "HIPEX" | information$`genotype:ch1` == "CCR5KO" & information$`strain:ch1` == "HIPEX"]

exprl_wt_gp120_HIPEX_F <- exprl[,information$`genotype:ch1` == "gp120" & information$`strain:ch1` == "HIPEX" & information$`Sex:ch1` == "F" | information$`genotype:ch1` == "WT" & information$`strain:ch1` == "HIPEX" & information$`Sex:ch1` == "F"]

#SPECIFY FINAL EXPRL HERE


exprl <- exprl_only_wt
exprl <- exprl_only_gp120

exprl <- exprl_only_wt_HIPEX
exprl <- exprl_no_ccr
exprl <- exprl_gp120_double

exprl <- exprl_no_ccr_only_LAV

exprl <- exprl_only_gp120_HIPEX
exprl <- exprl_gp120_double_only_HIPEX

exprl <- exprl_wt_gp120_HIPEX




head(exprl)
write.csv(exprl, "expression_matrix.csv")

###########REMOVE LATER!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#which(colnames(exprl) == "GSM1143197")
which(colnames(exprl) == "GSM1143252")
exprl <- exprl[,-2]
dim(exprl)


### run after finalising the exprl selection
common <-intersect(information$geo_accession,colnames(exprl))

info2 <- information[common,]
information <- info2


####### removing ages after 12 months
exprl <- exprl[, as.numeric(information$`age months:ch1`) < 13]
common <-intersect(information$geo_accession,colnames(exprl))

info2 <- information[common,]
information <- info2





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






neuron_genes=c("Nefm")#, "Gad1","Mapt", , "Scn3a","Slc12a5")#"Gabra1", "Htr2a", "Grin2a",#dropped reln, Gabra1 = alpha unit gaba receptor, Grin2a=nmda subunit, rein2a = 
micro_genes=c("Cd68", "Aif1", "Ms4a7", "Ccl4")#"Cd33", "Cd37","Cx3cr1","Itgam", "Ptprc",#removed aif1, because it is upreg on inflamm #Ccl4 mostly produced in astrocytes?!?!?!
astro_genes=c("Gfap", "Aldh1l1")#"Aqp4", "Sox9", "Gja1"#removed gfap, Megf10 # aldh1=astro promoter,sox9 = astro in adult brain, aqp=aquaporin; tried Glt1, but it didnt work, no matches, 
oligo_genes=c("Mog", "Mbp", "Mag")
endoth_genes=c("Eif4ebp1","B2m", "Bsg","Slc7a11","Slc2a1", "Mcam", "Epas1","Gpc5","Vcam1","Pecam1", "Cd34", "Mfsd2a", "Picalm")#"Pecam1", "Cd34", "Mfsd2a", "Picalm")
gen_immune_genes=c("Ccl3", "Ccl5", "Ccl2", "Cxcl10", "Fos", "Nln")




neuron_probesets=mapIds(illuminaMousev2.db, keys=neuron_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
neuron_reference <- marker(exprl, neuron_probesets)

microglia_probesets=mapIds(illuminaMousev2.db, keys=micro_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
microglia_probesets[[2]] <- microglia_probesets[[2]][-2]# removes Aif2
#microglia_probesets[[4]] <- microglia_probesets[[4]][-1]#removing the first of 2 elements from list for Ptprc
#microglia_probesets[[4]] <- microglia_probesets[[4]][-1]#removing the second of 2 elements from list for Ptprc
microglia_reference <- marker(exprl, microglia_probesets)

astrocyte_probesets=mapIds(illuminaMousev2.db, keys=astro_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
####hav to make specific changes to probesets here!!!!!!!!!!!!!!!!!######################
#aldh1 probe 4 weak corr with all other aldh1
#astrocyte_probesets[[1]] <- astrocyte_probesets[[1]][-3]
astrocyte_reference <- marker(exprl, astrocyte_probesets)

oligo_probesets=mapIds(illuminaMousev2.db, keys=oligo_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
#mbp probe 4 shows poor intercorrelation ILMN_3011353
oligo_probesets[[2]] <- oligo_probesets[[2]][1] #only use mbp1
oligo_reference <- marker(exprl, oligo_probesets)

endoth_probesets=mapIds(illuminaMousev2.db, keys=endoth_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
endoth_reference <- marker(exprl, endoth_probesets)


gen_immune_probesets=mapIds(illuminaMousev2.db, keys=gen_immune_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
gen_immune_reference <- marker(exprl, gen_immune_probesets)

X11()
plot(microglia_reference - gen_immune_reference)

micro_ref_minus_gen_imm <- microglia_reference - gen_immune_reference

X11()
plot(exprl[goi,] ~ micro_ref_minus_gen_imm)


X11()
plot(exprl[goi,] ~ microglia_reference)



astro_ref_minus_gen_imm <- astrocyte_reference - gen_immune_reference






############Print marker correlation chart


markers_probesets=c(unlist(neuron_probesets),unlist(astrocyte_probesets),unlist(oligo_probesets),unlist(microglia_probesets))#, unlist(endoth_probesets))


markers_exprl=exprl[markers_probesets,]



#names(markers_probesets) <- c("Nefm.1", "Nefm.2", "Nefm.3","Gad1", "Gfap.1", "Gfap.2", "Aldh1l1", "Mog.1", "Mog.2", "Mbp", "Mag","Cd68", "Aif1.1", "Aif1.2")
rownames(markers_exprl)=names(markers_probesets)



marker_cor <- as.matrix(cor(t(markers_exprl),method="pearson"))
pmat <- cor_pmat(t(markers_exprl))

X11()
hc <- F
print(ggcorrplot(marker_cor, colors = c("blue", "white", "red"), lab=T, hc.order = hc)) ###, p.mat = pmat 


X11()
print(ggcorrplot(marker_cor, colors = c("blue", "white", "red"),p.mat = pmat )) ###, p.mat = pmat 

X11()
print(ggcorrplot(marker_cor, colors = c("blue", "white", "red"),p.mat = pmat, insig = "blank", lab = F )) ###, p.mat = pmat 




 
write.csv(marker_cor, file = "./markers_9_23finalwtgp120.csv")
###This averages within gene markers, as the PSEA code does, so we 'see' the correlations that the PSEA works with

marker_set <- NA
#test <- list(neuron_probesets[1], neuron_probesets[1], neuron_probesets[1])
probe_list <- list(neuron_probesets, astrocyte_probesets, oligo_probesets, microglia_probesets)#, endoth_probesets)


for (j in 1:length(probe_list)){

probeset <- probe_list[[j]]

new_ex <- matrix(ncol=length(information$`Sex:ch1`), nrow=30)
for(i in 1:length(probeset)){
  if (length(unlist(probeset[i])) > 1){
  avgs <- colMeans(exprl[unlist(probeset[i]),])
  new_ex[i,] <- avgs
  }
  else { new_ex[i,] <- exprl[unlist(probeset[i]),]}
  
}
new_ex <- na.omit(new_ex)
rownames(new_ex) <- unlist(names((probeset)))
marker_set <- rbind(marker_set, new_ex)

}



marker_set <- marker_set[-1,]
marker_cor <- as.matrix(cor(t(marker_set),method="pearson"))
X11()
hc <- F
print(ggcorrplot(marker_cor, colors = c("blue", "white", "red"), lab=T, hc.order = hc ))


#plot cd68 by cd37
plot(exprl["ILMN_2689785",] ~exprl["ILMN_2929526",])

#aif1 probe 1 vs gfap probe 1
X11()
plot(exprl["ILMN_1212938",] ~exprl["ILMN_1214715",])

exprl[head(order(exprl["ILMN_1214715",])),]

which(colnames(exprl) == "GSM1143255")



#aif1 probe 2 vs gfap probe 1
X11()

plot(exprl["ILMN_2804487",] ~exprl["ILMN_1214715",])



GSM1143254
ILMN_1212645

exprl[exprl == "ILMN_1212645"]


exprl <- exprl[]
plot(exprl["ILMN_1212938",] ~exprl["ILMN_1214715",])



data.frame(new_ex)
#########################code to examine within and without makerer error

marker_set
probe_list

i = 2
for (i in 1:length(probe_list)){
  names(unlist(probe_list[[i]]))
  marker_set
         }




########doing diff analysis
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
Ms4a7_goi1 <- "ILMN_3019158"
Ms4a7_goi2 <- "ILMN_3091003"
Ccl5_goi <- "ILMN_1231814"
Nes_goi <- "ILMN_2703267"

Pdpn_goi <- "ILMN_2654754"
S100a6_goi <- "ILMN_2712120"

Slc7a11_goi1 <- "ILMN_2463432"
Slc7a11_goi2 <- "ILMN_2536188"
Slc7a11_goi3 <- "ILMN_2740738"
Slc7a11_goi4 <- "ILMN_2948143" # this probe was the highest IDed probde for astrocyte
C4x_goi <- "ILMN_1215092"
C4x2_goi <- "ILMN_2646052"
Gpnmb_goi <- "ILMN_2614655"
Tuba8_goi2 <- "ILMN_2487308"
Hdac61_goi <- "ILMN_2770180"
Hdac62_goi <- "ILMN_2943818"

Cdk7_goi <-  "ILMN_2698458"
Mnat1a_goi <- "ILMN_2758631"
Mnat1b_goi <- "ILMN_2758632"

Lgals3bp_goi <- "ILMN_1258526"

Cxcl10_goi1 <- "ILMN_1214419"

C4b_goi1 <- "ILMN_1215092"
C4b_goi2 <- "ILMN_1246898"

Ahnak_goi1 <- "ILMN_1258578"
Ahnak_goi3<- "ILMN_2458765"

C3_goi <- "ILMN_2759484"

Cd68_goi <- "ILMN_2689785"

Kcnab3_goi <- "ILMN_2655386"
Ctsz_goi <- "ILMN_2839569"

Aif1_goi1 <- "ILMN_1212938"

Tubb2b_goi1 <- "ILMN_1221835"


Ccl4_goi1 <- "ILMN_1223257"

Vwf_goi <- "ILMN_2519673"

Clu_goi <- "ILMN_2727153"

#neuro sig diff genes, all for poster 9_30_2019
Pgam1_goi <- "ILMN_1232278"
Tmem184c_goi <- "ILMN_1248892"
Bmp6_goi <- "ILMN_2705217"
Naprt_goi <-"ILMN_1225191"

Schip1_goi <- "ILMN_1244514"
Ccr5_goi <- "ILMN_2888191"
Rida_goi <- "ILMN_2816876"
# only neuro ref adn diff in best model
Pgam1_goi <- "ILMN_1232278"
Tubb6_goi <- "ILMN_2718217"
Fcrls_goi <- "ILMN_2770968"
Ndufaf5_goi <- "ILMN_1216813"
Mroh1_goi <- "ILMN_2613806"

#possible oligo marker
olig_goi <- "ILMN_3097381"


#for jeff
Ddx3x_goi <- "ILMN_2710166"


Gfap_goi1 <- "ILMN_1214715"

Pik3ap1_goi <- "ILMN_1257623"

gbp3p1_goi <- "ILMN_1244513"
gbp3p2_goi <- "ILMN_2918002"
####this looks for the gene id in tst in the illumina mouse db and then the GEO data in use
tst = "Irf7"
goi_test=mapIds(illuminaMousev2.db, keys=tst, column='PROBEID', keytype='SYMBOL',multiVals="list")
goi_test
sum(goi_test[[1]][1] == rownames(exprl))# checks for the chosen probe in the loaded exprl data


###specify goi
goi <- lcn2_goi
goi <- Ms4a7_goi1
goi <- Ccl5_goi
goi <- Hdac61_goi

goi <- Tuba8_goi2
goi <- Pik3ap1_goi
goi <- gbp3p1_goi
goi <- gbp3p1_goi
goi <- gbp3p2_goi

#for testing names of illumina probes
# goitest <- "ILMN_2547305"
# goi_name=mapIds(illuminaMousev2.db, keys=goitest, column='SYMBOL', keytype='PROBEID',multiVals="list")
# goi_name


goi_name=mapIds(illuminaMousev2.db, keys=goi, column='SYMBOL', keytype='PROBEID',multiVals="list")





#Model expression of the goi with combination of reference cell pop signals
model1 <- lm(exprl[goi,] ~ neuron_reference + microglia_reference + astrocyte_reference + oligo_reference + endoth_reference)
summary(model1)

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








#visualise the above charts

X11()
grid.arrange(neuro_plot1,micro_plot1,astro_plot1,oligo_plot1,endoth_plot1, nrow = 1)
#save_loc <- "C:/Users/User/Desktop/Kaul_lab_work/decon/images for 3_14/"
#jpeg(paste(save_loc, goi_name, ".jpg"))
#dev.off()



###specify grouping structure
 
group_regress <- "gp120" 

groups <- as.numeric(information$`genotype:ch1` == group_regress)

# #for sex
# group_regress <- "M" 
# groups <- as.numeric(information$`Sex:ch1` == group_regress)



#make diff interaction regressors
neuron_difference <- groups * neuron_reference
microglia_difference <- groups * microglia_reference
astrocyte_difference <- groups * astrocyte_reference
oligo_difference <- groups * oligo_reference
#endoth_difference <- groups * endoth_reference



###building loop struct?? used for now
#titles <- c(neuro_title, micro_title, astro_title, oligo_title, endoth_title)


###diff models
model2_neuro <- lm(exprl[goi,] ~ neuron_reference + neuron_difference)
model2_micro <- lm(exprl[goi,] ~ microglia_reference +  microglia_difference)
model2_astro <- lm(exprl[goi,] ~ astrocyte_reference +  astrocyte_difference)#ignore, markers fail to separate from neuro
model2_oligo <- lm(exprl[goi,] ~ oligo_reference +  oligo_difference)
#model2_endoth <- lm(exprl[goi,] ~ endoth_reference +  endoth_difference)


model2_neuro_sav <- model2_neuro$model

test <- cbind(information$`genotype:ch1`, exprl[goi,], neuron_reference)
head(test)

write.csv(test,"./testing.csv")


#sex, age and strain
sex_difference <- groups * neuron_reference
model2_sex <- model2_neuro <- lm(exprl[goi,] ~ neuron_reference + neuron_difference)




summary(model2_micro)

####outlier stuff

hat_neuro <- hatvalues(model2_neuro)
hat_neuro_order <- hat_neuro[order(hat_neuro, decreasing = T)]
tipped_hat_neuro <- hat_neuro_order/mean(hat_neuro_order)
tcd_neuro <- cooks.distance(model2_neuro)/mean(cooks.distance(model2_neuro))
tcd_neuro_order <- tcd_neuro[order(tcd_neuro, decreasing = T)]

hat_astro <- hatvalues(model2_astro)
hat_astro_order <- hat_astro[order(hat_astro, decreasing = T)]
tipped_hat_astro <- hat_astro_order/mean(hat_astro_order)
tcd_astro <- cooks.distance(model2_astro)/mean(cooks.distance(model2_astro))
tcd_astro_order <- tcd_astro[order(tcd_astro, decreasing = T)]


hat_micro <- hatvalues(model2_micro)
hat_micro_order <- hat_micro[order(hat_micro, decreasing = T)]
tipped_hat_micro <- hat_micro_order/mean(hat_micro_order)
tcd_micro <- cooks.distance(model2_micro)/mean(cooks.distance(model2_micro))
tcd_micro_order <- tcd_micro[order(tcd_micro, decreasing = T)]


hat_oligo <- hatvalues(model2_oligo)
hat_oligo_order <- hat_oligo[order(hat_oligo, decreasing = T)]
tipped_hat_oligo <- hat_oligo_order/mean(hat_oligo_order)
tcd_oligo <- cooks.distance(model2_oligo)/mean(cooks.distance(model2_oligo))
tcd_oligo_order <- tcd_oligo[order(tcd_oligo, decreasing = T)]




hat_endoth <- hatvalues(model2_endoth)
hat_endoth_order <-  hat_endoth[order(hat_endoth, decreasing = T)]
tipped_hat_endoth <- hat_endoth_order/mean(hat_endoth_order)
tcd_endoth <- cooks.distance(model2_endoth)/mean(cooks.distance(model2_endoth))
tcd_endoth_order <- tcd_endoth[order(tcd_endoth, decreasing = T)]

head(tcd_neuro_order)
head(tcd_astro_order)
head(tcd_micro_order)
head(tcd_oligo_order)
head(tcd_endoth_order)

head(tipped_hat_neuro)
head(tipped_hat_astro)
head(tipped_hat_micro)
head(tipped_hat_oligo)
head(tipped_hat_endoth)


thframe <- list(head(tipped_hat_neuro), head(tipped_hat_micro), head(tipped_hat_astro), head(tipped_hat_oligo), head(tipped_hat_endoth))

plot(hatvalues(model2_oligo), type = "h")

plot(cooks.distance(model2_astro))
cd_astro <- cooks.distance(model2_astro)
cd_astro_order <- cd_astro[order(cd_astro, decreasing = T)]
#find col with name
which( colnames(exprl)=="GSM1143266" )
#verify
head(exprl[,67])
head(exprl[,"GSM1143266"])
dim(exprl)
dim(exprl[,-67])

#now for ref
head(astrocyte_reference)
which(names(astrocyte_reference)=="GSM1143266" )
which(names(astrocyte_difference)=="GSM1143266" )

length(astrocyte_reference)
length(astrocyte_reference[-67])

#ref is same, 67, time to make model



model2_astro_no_GSM1143266 <- lm(exprl[goi,-67] ~ astrocyte_reference[-67] +  astrocyte_difference[-67])
summary(model2_astro)
summary(model2_astro_no_GSM1143266)

  
#now removing highest leverage pt, not cooks dist
head(hat_astro_order)
head(cd_astro_order)

  
names(head(cd_astro_order))
#looks for crossover in top 5 cooks dist and top 5 leverage values
intersect(names(head(cd_astro_order)), names(head(hat_astro_order)))

#now removing top leverage GSM1143197
which( colnames(exprl)=="GSM1143197")

model2_astro_no_GSM1143197 <- lm(exprl[goi,-25] ~ astrocyte_reference[-25] +  astrocyte_difference[-25])
summary(model2_astro_no_GSM1143197)
summary(model2_astro)
summary(model2_astro_no_GSM1143266)
#removal of highest leverage pt (.129) changed the sig diff coef by 0.007%
#removal of hights cooks dist pt (.295) change sig diff coef by 13.585%


#doing the same for micro, 66, 67 and 97
model2_micro_no_GSM1143266 <- lm(exprl[goi,-67] ~ microglia_reference[-67] +  microglia_difference[-67])
model2_micro_no_GSM1143197 <- lm(exprl[goi,-25] ~ microglia_reference[-25] +  microglia_difference[-25])


summary(model2_micro_no_GSM1143266)
summary(model2_micro_no_GSM1143197)
summary(model2_micro)












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

# 
# #endoth
# diff_c4 <- as.character(round(model2_endoth$coefficients[3],3))
# diff_p4 <- round(pvalmat(list(model2_endoth), c("endoth_reference","endoth_difference"))[2],4)
# 
# 
# #X11()
# model2_endoth_plot<-crplot(model2_endoth, "endoth_reference", g="endoth_difference",newplot = F)
# title(paste("endoth", goi_name, "red = ",group_regress))
# legend("top", paste("coef=",as.character(round(model2_endoth$coefficients[2],3)),
#                     "p_val=",round(pvalmat(list(model2_endoth), c("endoth_reference","endoth_difference"))[1],4)))
# legend("bottom", paste("diff_coef=",as.character(diff_c4), "p=",as.character(diff_p4)))
# #legend("right", paste("red = only ", group_regress))
# endoth_title <- paste("endoth", goi_name, "red is ",group_regress)#title for auto save file
# 
# 


str(model_list)
summary(model_list[[2]][1])


#look at hist of goi and all ref values to asses normality in general
X11()
par(mfrow=c(2,3))
hist(exprl[goi,], xlab = as.character(goi_name))
hist(neuron_reference)
hist(microglia_reference)
hist(astrocyte_reference)
hist(oligo_reference)
hist(endoth_reference)

#####looking at just data vs reference of a single cell type. put this in a beggining?
X11()
par(mfrow=c(2,3))

plot(exprl[goi,] ~ neuron_reference, ylab = as.character(goi_name))
abline(lm(exprl[goi,] ~ neuron_reference))

plot(exprl[goi,] ~ microglia_reference, ylab = as.character(goi_name))
abline(lm(exprl[goi,] ~ microglia_reference))

plot(exprl[goi,] ~ astrocyte_reference, ylab = as.character(goi_name))
abline(lm(exprl[goi,] ~ astrocyte_reference))

plot(exprl[goi,] ~ oligo_reference, ylab = as.character(goi_name))
abline(lm(exprl[goi,] ~ oligo_reference))

plot(exprl[goi,] ~ endoth_reference, ylab = as.character(goi_name))
abline(lm(exprl[goi,] ~ endoth_reference))




#plot cooks d vs goi magnitude
X11()
par(mfrow=c(2,3))
plot(exprl[goi,] ~ tcd_neuro)
plot(exprl[goi,] ~ tcd_micro)
plot(exprl[goi,] ~ tcd_astro)
plot(exprl[goi,] ~ tcd_oligo)
plot(exprl[goi,] ~ tcd_endoth)









####### working in lumi
source("https://bioconductor.org/biocLite.R")

biocLite("lumi")

library(GEOquery)

library(lumi)
library(limma)

gunzip("C:/Users/User/Desktop/kaul_lab_work/decon/raw_data/GPL6887_MouseWG-6_V2_0_R3_11278593_A.txt.gz")

#cant read in the raw data, getting suspicious of the data
filename <- "C:/Users/User/Desktop/kaul_lab_work/decon/raw_data/GPL6887_MouseWG-6_V2_0_R3_11278593_A.txt"
       lumi <- lumiR("C:/Users/User/Desktop/kaul_lab_work/decon/raw_data/GPL6887_MouseWG-6_V2_0_R3_11278593_A.txt") 
x <- read.ilmn(files="C:/Users/User/Desktop/kaul_lab_work/decon/raw_data/GPL6887_MouseWG-6_V2_0_R3_11278593_A.txt")

setwd("~/Desktop/active/lupus/GSE65391")
lumi <- lumiR("GPL6887_MouseWG-6_V2_0_R3_11278593_A.txt") 


x.lumi <- lumiR.batch(filename, sampleInfoFile='sampleInfo.txt') # Not Run
x.lumi <- lumiR.batch(filename) # Not Run
x <- read.ilmn(files="C:/Users/User/Desktop/kaul_lab_work/decon/raw_data/GPL6887_MouseWG-6_V2_0_R3_11278593_A.txt")
#getGEO freezes R
geop_raw <- getGEO('GSE47029',filename="C:/Users/User/Desktop/kaul_lab_work/decon/raw_data/GPL6887_MouseWG-6_V2_0_R3_11278593_A.txt.gz")

#reads in as data.frame,other programs dont want to touch a data frame
raw <- read.csv("C:/Users/User/Desktop/kaul_lab_work/decon/raw_data/raw_data_excel_no_head.csv")
head(raw)
eset.rma <- rma(raw) #RMA to normalize the data and 



####trying to do RMA normalization with the GEO data, sadly rma fucntion exprect affybatch object
#trying RMA through the oligo package
untar("GSE47029_RAW.tar", exdir = "raw_data")
geop_raw <- getGEO('GSE47029',filename="C:/Users/User/Desktop/kaul_lab_work/decon/raw_data/GPL6887_MouseWG-6_V2_0_R3_11278593_A.txt.gz")
gunzip("C:/Users/User/Desktop/kaul_lab_work/decon/GSE47029/GSE47029_non-normalized.txt.gz")
geop_non_norm <- getGEO('GSE47029b',filename="C:/Users/User/Desktop/kaul_lab_work/decon/GSE47029/GSE47029_non-normalized.txt")


geop_raw <- getGEO('GSE47029_RAW')


cels = list.files("raw_data/", pattern = "CEL")

geo_sup <- getGEOSuppFiles("GSE47029")

raw.data = ReadAffy(verbose = FALSE, filenames = cels, cdfname = "hgu133acdf")
exprl_rma = 2^exprs(rma(geop))
rma_test <- rma((geop))



####### data frame for Rohan
dim(information)
dim(exprl)
geno <- information$`genotype:ch1`
length(geno)
head(information)
head(exprl)
tail(information,1)
tail(exprl,1)
#seems to line up
rdf <- data.frame(exprl["ILMN_1233439",], 
                  exprl["ILMN_1227299",],
                  exprl["ILMN_2639865",],
                  exprl["ILMN_2737200",],
                  exprl["ILMN_3011353",],
                  exprl["ILMN_3081854",],
                  exprl["ILMN_1214823",],
                  exprl["ILMN_3135566",],
                  exprl["ILMN_1214811",],
                  exprl["ILMN_2941992",],
                  exprl["ILMN_1241228",],
                  exprl["ILMN_2469329",],
                  exprl["ILMN_2469333",],
                  exprl["ILMN_2486186",],
                  exprl["ILMN_1214715",],
                  exprl["ILMN_1215847",],
                  exprl["ILMN_1212938",],
                  exprl["ILMN_1218123",],
                  exprl["ILMN_2804487",],
                  exprl["ILMN_1257068",],
                  exprl["ILMN_2756460",],
                  exprl["ILMN_1250017",],
                  geno)
head(rdf)
rdf_names<- c("Prkaa1", "Mbp_p1","Mbp_p2","Mbp_p3","Mbp_p4","Mbp_p5",
              "Tsc-2_p1", "Tsc-2_p2", "Psen1", "Psen2", "Tnfrsf1a_p1","Tnfrsf1a_p2",
              "Tnfrsf1a_p3","Tnfrsf1b", "Gfap_p1", "Gfap_p2", "Aif1_p1","Aif1_p2","Aif1_p3","Mtor_p1", "Mtor_p2", "Rptor", "geno")
dim(rdf)
length(rdf_names)
colnames(rdf) <- rdf_names
head(rdf)
write.csv(rdf, "rohan_df.csv")

#ILMN_1214715, ILMN_1215847 = Gfap
hist(exprl["ILMN_1214715",])
mean(exprl["ILMN_1214715",])

hist(exprl["ILMN_1215847",])
mean(exprl["ILMN_1215847",])




hist(rnorm(50,159,25))
rnorm(50,159,25)




#looking at age
hist(as.numeric(information$`age months:ch1`))
levels(information$`age months:ch1`)
age_months<- as.numeric(information$`age months:ch1`)

model3 <- lm(neuron_reference ~ age_months)
summary(model3)
plot(model3)

plot(neuron_reference ~ age_months)

model3 <- lm(exprl[goi,] ~ neuron_reference + neuron_difference)

model3 <- lm(microglia_reference ~ age_months)
summary(model3)

model3b <- lm(microglia_reference ~ age_months)
summary(model3)



#ploting age vs ref expression
X11()
par(mfrow=c(2,3))
plot(exprl[goi,] ~ age_months)
plot(neuron_reference ~ age_months)
plot(microglia_reference ~ age_months)
plot(astrocyte_reference ~ age_months)
plot(oligo_reference ~ age_months)
plot(endoth_reference ~ age_months)


sex <- information$`Sex:ch1`
sex[sex == "M"] = 1
sex[sex == "F"] = 0
sex <- as.numeric(sex)

X11()
par(mfrow=c(2,3))
plot(exprl[goi,] ~ sex)
plot(neuron_reference ~ sex)
plot(microglia_reference ~ sex)
plot(astrocyte_reference ~ sex)
plot(oligo_reference ~ sex)
plot(endoth_reference ~ sex)


comb_model <-lm(exprl[goi,] ~ sex + age_months + neuron_reference + microglia_reference + astrocyte_reference + oligo_reference + endoth_reference)
summary(comb_model)
summary(exprl[goi,])


#model2_astro <- lm(exprl[goi,] ~ astrocyte_reference +  astrocyte_difference)#ignore, markers fail to separate from neuro

comb_model2_astro <- lm(exprl[goi,] ~ astrocyte_reference +  astrocyte_difference + age_months)
summary(comb_model2_astro)

comb_model2_astro2 <- lm(exprl[goi,] ~ astrocyte_reference +  astrocyte_difference + strain_bl)
summary(comb_model2_astro2)





#X11()
model2_astro_plot<-crplot(comb_model2_astro2, "astrocyte_reference", g="astrocyte_difference",newplot = F)
title(paste("astrocyte", goi_name, "red = ",group_regress))
legend("top", paste("coef=",as.character(round(comb_model2_astro2$coefficients[2],3)),
                    "p_val=",round(pvalmat(list(comb_model2_astro2), c("astrocyte_reference","astrocyte_difference"))[1],4)))
legend("bottom", paste("diff_coef=",as.character(diff_c3), "p=",as.character(diff_p3)))
#legend("right", paste("red = only ", group_regress))
astro_title <- paste("astro", goi_name, "red is ",group_regress)#title for auto save file



#model2_endoth_plot<-crplot(model2_endoth, "endoth_reference", g="endoth_difference",newplot = F)

#looking at strain
strain <- as.factor(information$`strain:ch1`)
plot(exprl[goi,] ~ as.factor(strain))

comb_model3 <-lm(exprl[goi,] ~ strain + sex + age_months + neuron_reference + microglia_reference + astrocyte_reference + oligo_reference + endoth_reference)
summary(comb_model3)



  #visualise the above charts

X11()
grid.arrange(neuro_plot1)
             
             #,micro_plot1,astro_plot1,oligo_plot1,endoth_plot1, nrow = 1)



head((information$`genotype:ch1`),3)
head((exprl), 1)

dim(information)
dim(t(exprl))
test <- cbind(t(exprl), information)
dim(test)
rownames(test)
write.csv2(test, "test")

test2 <- t(test)
write.csv2(test2, "test2")





#####working on bulk model creationthing####################
model_matrix <- cbind(1, neuron_reference,
                      astrocyte_reference, oligo_reference, microglia_reference,
                      neuron_difference, astrocyte_difference, oligo_difference,
                      microglia_difference)

str(model_matrix)


model_subset <- em_quantvg(c(2,3,4,5), tnv=4, ng=2) 
models <- lmfitst(t(exprl), model_matrix, model_subset,
                  lm=TRUE) 

length(models[[2]])
#checking specific model
(summary(models[[2]][["ILMN_1244866"]]) )


X11()
crplot(models[[2]][["ILMN_2816876"]], "2", g="6",newplot = F)



for_plot <- models[[2]][["ILMN_1215092"]]
str(for_plot)
plot()


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
#ILMN_1244513, ILMN_1233455, ILMN_2615380, ILMN_1214396, ILMN_2862026, ILMN_2646322

neuro_shorlist <- table_full[is.na(table_full$microglia_reference) & is.na(table_full$oligo_reference) & is.na(table_full$astrocyte_reference),]
dim(neuro_shorlist)

neuro_shorlist
#ILMN_1232278, ILMN_1248892, ILMN_1216813, ILMN_2613806



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
#ILMN_1244513, ILMN_1257623, ILMN_2910934
#ILMN_1244513, ILMN_1233455, ILMN_2615380, ILMN_1214396, ILMN_2862026, ILMN_2646322, ILMN_1257623, ILMN_2610706, ILMN_2910934, ILMN_2602352


#astro order
order <- order(pvalues[filter,7])
table <- data.frame(coefficients[,c(3,7)], pvalues[,c(3,7)], symbols)[filter,][order,] 
table[1:30,] 
sum(!is.na(coefficients[filter,7]))
table_full <- data.frame(coefficients[,c(1:9)], pvalues[,c(1:9)], symbols)[filter,][order,] 
head(table_full)


astro_shorlist <- table_full[is.na(table_full$microglia_reference) & is.na(table_full$oligo_reference) & is.na(table_full$neuron_reference),]
dim(astro_shorlist)
#ILMN_2831436


#oligo order
order <- order(pvalues[filter,8]) 
table <- data.frame(coefficients[,c(4,8)], pvalues[,c(4,8)], symbols)[filter,][order,] 
table[1:30,] 
sum(!is.na(coefficients[filter,8]))
table_full <- data.frame(coefficients[,c(1:9)], pvalues[,c(1:9)], symbols)[filter,][order,] 
head(table_full)
dim(table_full)

oligo_shortlist <- table_full[is.na(table_full$microglia_reference) & is.na(table_full$astrocyte_reference) & is.na(table_full$neuron_reference),]
#ILMN_2547305, no gene ame in illumina database



#micro order trying to get all the columns
order <- order(-coefficients[filter,9]) 
table <- data.frame(coefficients[,c(1:9)], pvalues[,c(1:9)], symbols)[filter,][order,] 
table[1:20,] 



goi_name_test=mapIds(illuminaMousev2.db, keys="ILMN_2831436", column='SYMBOL', keytype='PROBEID',multiVals="list")



###model 2 with strain

model2_neuro <- lm(exprl[goi,] ~ neuron_reference + neuron_difference)
summary(model2_neuro)
model2_neuro_strain <- lm(exprl[goi,] ~ neuron_reference + neuron_difference + information$`strain:ch1`)
summary(model2_neuro_strain)

model2_micro <- lm(exprl[goi,] ~ microglia_reference +  microglia_difference)
model2_astro <- lm(exprl[goi,] ~ astrocyte_reference +  astrocyte_difference)#ignore, markers fail to separate from neuro
model2_oligo <- lm(exprl[goi,] ~ oligo_reference +  oligo_difference)
model2_endoth <- lm(exprl[goi,] ~ endoth_reference +  endoth_difference)


###############################################################

model2_neuro <- lm(exprl[goi,] ~ neuron_reference + neuron_difference)

summary(model2_neuro)
crplot(model2_neuro, "neuron_reference", g="neuron_difference",newplot = F)
plot(exprl[goi,] ~ neuron_reference)

testing2 <- lm(exprl[goi,][information$`genotype:ch1` == "WT"] ~ neuron_reference[information$`genotype:ch1` == "WT"])
summary(testing2)
plot(exprl[goi,][information$`genotype:ch1` == "WT"] ~ neuron_reference[information$`genotype:ch1` == "WT"])
abline(testing2)



testing1 <- lm(exprl[goi,][information$`genotype:ch1` == "gp120"] ~ neuron_reference[information$`genotype:ch1` == "gp120"])
summary(testing1)
X11()
plot(exprl[goi,][information$`genotype:ch1` == "gp120"] ~ neuron_reference[information$`genotype:ch1` == "gp120"])
abline(testing1)


X11()
hist(neuron_reference)


testing3 <- lm(exprl[goi,] ~ neuron_reference)
summary(testing3)

lm()

X11()
par(mfrow=c(1,4))
crplot(model2_neuro, "neuron_reference", g="neuron_difference",newplot = F)

# plot(exprl[goi,] ~ neuron_reference, ylim=(c(min(exprl[goi,]), max(exprl[goi,]))), col=as.factor(information$`genotype:ch1`))
# abline(testing2)
# 
# 
# plot(exprl[goi,] ~ neuron_reference, ylim=(c(min(exprl[goi,]), max(exprl[goi,]))), col=as.factor(information$`genotype:ch1`))
# abline(testing1)

plot(exprl[goi,] ~ neuron_reference, ylim=(c(min(exprl[goi,]), max(exprl[goi,]))), col=as.factor(information$`genotype:ch1`))
abline(testing1)
abline(testing2)




abline(testing2)


plot(exprl[goi,][information$`genotype:ch1` == "WT"] ~ neuron_reference[information$`genotype:ch1` == "WT"], ylim=(c(min(exprl[goi,]), max(exprl[goi,]))))
abline(testing2)

plot(exprl[goi,][information$`genotype:ch1` == "gp120"] ~ neuron_reference[information$`genotype:ch1` == "gp120"], ylim=(c(min(exprl[goi,]), max(exprl[goi,]))))
abline(testing1)
  


