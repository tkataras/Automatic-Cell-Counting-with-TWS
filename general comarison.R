



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
#trying w/o antilog this time, data already log2 tranformed

#exprl=exprs(geop)

#exprl=2^exprs(geop)

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






####this looks for the gene id in tst in the illumina mouse db and then the GEO data in use
tst = "Nefm"
goi_test=mapIds(illuminaMousev2.db, keys=tst, column='PROBEID', keytype='SYMBOL',multiVals="list")
goi_test
sum(goi_test[[1]][3] == rownames(exprl))# checks for the chosen probe in the loaded exprl data


goi <- lcn2_goi

Lgals3bp_goi <- "ILMN_1258526"

Mnat1a_goi <- "ILMN_2758631"
Mnat1b_goi <- "ILMN_2758632" 

goi <- Mnat1a_goi
goi <- Mnat1b_goi


goi <- Lgals3bp_goi

Tuba8_goi <- "ILMN_2487308"
goi <- Tuba8_goi

goi <- Gpnmb_goi

goi <- Ahnak_goi3

goi <- C3_goi
goi <- Cd68_goi


goi <- C4b_goi1
goi <- Kcnab3_goi
goi <- Ctsz_goi

Tubb2b_goi <- "ILMN_1221835" #several other probees
goi <- Tubb2b_goi

####  general t test 

###ONLY HIPEX!!!!!!!!!!!!!!!!!!!!
exprl <- exprl[,information$`strain:ch1` == "HIPEX"]
common <-intersect(information$geo_accession,colnames(exprl))
info2 <- information[common,]
information <- info2



mean(exprl[goi,information$`genotype:ch1` == "WT"])
mean(exprl[goi,information$`genotype:ch1` == "gp120"])

t.test(exprl[goi,information$`genotype:ch1` == "WT"], exprl[goi,information$`genotype:ch1` == "gp120"])


X11()
hist(exprl[goi,information$`genotype:ch1` == "WT"])
X11()
hist(exprl[goi,information$`genotype:ch1` == "gp120"])




mean(exprl[goi,information$`genotype:ch1` == "WT"])
mean(exprl[goi,information$`genotype:ch1` == "CCR5KO"])
t.test(exprl[goi,information$`genotype:ch1` == "WT"], exprl[goi,information$`genotype:ch1` == "CCR5KO"])

X11()
hist(exprl[goi,information$`genotype:ch1` == "WT"])
X11()
hist(exprl[goi,information$`genotype:ch1` == "CCR5KO"])




mean(exprl[goi,information$`genotype:ch1` == "gp120"])
mean(exprl[goi,information$`genotype:ch1` == "CCR5KO_x_gp120"])

X11()
hist(exprl[goi,information$`genotype:ch1` == "gp120"])
X11()
hist(exprl[goi,information$`genotype:ch1` == "CCR5KO_x_gp120"])



t.test(exprl[goi,information$`genotype:ch1` == "gp120"], exprl[goi,information$`genotype:ch1` == "CCR5KO_x_gp120"])



t.test(exprl[goi,information$`genotype:ch1` == "WT"], exprl[goi,information$`genotype:ch1` == "CCR5KO_x_gp120"])







length(exprl[goi,information$`genotype:ch1` == "CCR5KO_x_gp120"])





mean(exprl[goi,])


#looking at only LAV

exprl_only_LAV <- exprl[,information$`strain:ch1` == "LAV" ]


exprl <- exprl_only_LAV


####need informatin to drop out the same NA rows that exprl dropped out
#information <- pData(phenoData(geop [["GSE47029_series_matrix.txt.gz"]]))
information <- pData(phenoData(geop))
#information
common <-intersect(information$geo_accession,colnames(exprl))

info2 <- information[common,]
information <- info2





mean(exprl[goi,information$`genotype:ch1` == "WT"])
mean(exprl[goi,information$`genotype:ch1` == "gp120"])

X11()
hist(exprl[goi,information$`genotype:ch1` == "WT"])
X11()
hist(exprl[goi,information$`genotype:ch1` == "gp120"])

mean(exprl[goi,information$`genotype:ch1` == "WT"])
mean(exprl[goi,information$`genotype:ch1` == "CCR5KO"])

X11()
hist(exprl[goi,information$`genotype:ch1` == "WT"])
X11()
hist(exprl[goi,information$`genotype:ch1` == "CCR5KO"])

mean(exprl[goi,information$`genotype:ch1` == "gp120"])
mean(exprl[goi,information$`genotype:ch1` == "CCR5KO_x_gp120"])

X11()
hist(exprl[goi,information$`genotype:ch1` == "gp120"])
X11()
hist(exprl[goi,information$`genotype:ch1` == "CCR5KO_x_gp120"])



t.test(exprl[goi,information$`genotype:ch1` == "gp120"], exprl[goi,information$`genotype:ch1` == "CCR5KO_x_gp120"])
length(exprl[goi,information$`genotype:ch1` == "gp120"])














exprl_only_HIPEX <- exprl[,information$`strain:ch1` == "HIPEX" ]




mean(neuron_reference[information$`genotype:ch1` == "WT"])
mean(neuron_reference[information$`genotype:ch1` == "gp120"])

sd(neuron_reference[information$`genotype:ch1` == "WT"])
sd(neuron_reference[information$`genotype:ch1` == "gp120"])

sd(neuron_reference)
t.test(neuron_reference[information$`genotype:ch1` == "WT"], neuron_reference[information$`genotype:ch1` == "gp120"])
