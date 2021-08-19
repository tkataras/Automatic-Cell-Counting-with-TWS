# source("http://bioconductor.org/biocLite.R")
# biocLite("limma")
# install.packages("rlang")
# install.packages("tibble")
library(GEOquery)#needs limma, rlang, tibble

# install.packages("BiocManager")
# BiocManager::install("affy", version = "3.8")
library(affy)

# BiocManager::install("annotate", version = "3.8")
library(annotate)

# BiocManager::install("hgu133a.db", version = "3.8")
library(hgu133a.db)

# BiocManager::install("PSEA", version = "3.8")
library(PSEA)

# install.packages("MASS")
library(MASS)

dataset <- getGEO(GEO="GSE3790", destdir=".")# loading in processed micro array data

information <- pData(phenoData(dataset [["GSE3790-GPL96_series_matrix.txt.gz"]]))
head(information)

phenotypes <- as.character(information[,"characteristics_ch1"])
head(phenotypes)

#restircting to just 1 ctrl and 1 HD phenotype
control <- grep("human caudate nucleus control", phenotypes)
HD <- grep("human caudate nucleus HD grade 1", phenotypes)

control_names <- sapply(strsplit(phenotypes[control], " "), function(x){x[[1]]})
HD_names <- sapply(strsplit(phenotypes[HD], " "), function(x){x[[1]]})


#selecting only samples that passed quality control Hodges 2006
passed_QC <- c ("101", "11", "126", "14", "15", "17", "1", "20",
                "21", "2", "52", "64", "8", "H104", "H109", "H113", "H115",
                "H117", "H118", "H120", "H121", "H124", "H126", "H128", "H129",
                "H131", "H132", "H137", "H85", "12", "13", "3", "7", "HC103",
                "HC105", "HC53", "HC55", "HC74", "HC81", "HC83", "HC86")


control <- control[control_names %in% passed_QC]
HD <- HD[HD_names %in% passed_QC]

sample_IDs <- as.character(information[c(control,HD), "geo_accession"])
datafiles <- sapply(sample_IDs,
                    function(x){rownames(getGEOSuppFiles(x))})

#loading raw data into R
raw_data <- ReadAffy(filenames=datafiles, compress=TRUE)
#normalizing via RMA method Irizarry 2003
expression <- 2^exprs(rma(raw_data)) 


#loading in unique, cell specific probesets
neuron_probesets <- list(c("221805_at", "221801_x_at", "221916_at"),"201313_at", "210040_at", "205737_at", "210432_s_at")
neuron_reference <- marker(expression, neuron_probesets) 

astro_probesets <- list("203540_at", c("210068_s_at","210906_x_at"), "201667_at")
astro_reference <- marker(expression, astro_probesets)

oligo_probesets <- list(c("211836_s_at", "214650_x_at"),"216617_s_at", "207659_s_at", c("207323_s_at", "209072_at"))
oligo_reference <- marker(expression, oligo_probesets)

micro_probesets <- list("204192_at", "203416_at")
micro_reference <- marker(expression, micro_probesets)

#making vector with length of data and ctrl = 0 HD = 1
groups <- c(rep(0, length(control)), rep(1, length(HD))) 

###this seems to set all ctl values to zero 
neuron_difference <- groups * neuron_reference
astro_difference <- groups * astro_reference
oligo_difference <- groups * oligo_reference
micro_difference <- groups * micro_reference

model1 <- lm(expression["202429_s_at",] ~
               neuron_reference + astro_reference + oligo_reference +
               micro_reference, subset=which(groups==0))


###visualising 
X11()
par(mfrow=c(1,4), cex=1.2)
crplot(model1, "neuron_reference", newplot=FALSE)
crplot(model1, "astro_reference", newplot=FALSE)
crplot(model1, "oligo_reference", newplot=FALSE)
crplot(model1, "micro_reference", newplot=FALSE) 



############################# testing with out data on sex
dataset <- getGEO(GEO="GSE47029", destdir=".")# loading in processed micro array data
information <- pData(phenoData(dataset [["GSE47029_series_matrix.txt.gz"]]))
names(information)
head(information$`Sex:ch1`)

phenotypes <- as.character(information[,"Sex:ch1"])
male <- grep("M", phenotypes)
female <- grep("F", phenotypes)

#creating strings of M and F, may not be doing the right thing
male_names <- sapply(strsplit(phenotypes[male], " "), function(x){x[[1]]})
HD_names <- sapply(strsplit(phenotypes[female], " "), function(x){x[[1]]})

#restircting to only samples?? that passe dQC  SKIPPING THIS
#selecting only samples that passed quality control Hodges 2006
# passed_QC <- c ("101", "11", "126", "14", "15", "17", "1", "20",
                # "21", "2", "52", "64", "8", "H104", "H109", "H113", "H115",
                # "H117", "H118", "H120", "H121", "H124", "H126", "H128", "H129",
                # "H131", "H132", "H137", "H85", "12", "13", "3", "7", "HC103",
#                 # "HC105", "HC53", "HC55", "HC74", "HC81", "HC83", "HC86")
# 
# 
# male <- male[male_names %in% passed_QC]
# female <- female[female_names %in% passed_QC]

sample_IDs <- as.character(information[c(male,female), "geo_accession"])
#CUTTING THIS DOWN TO FIRST !) FOR TESTING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
sample_IDs <- sample_IDs[1:10]

datafiles <- sapply(sample_IDs,function(x){rownames(getGEOSuppFiles(x))})#stuck here!!!

# example outcome of running datafiles command 
# trying URL 'https://ftp.ncbi.nlm.nih.gov/geo/samples/GSM86nnn/GSM86833/suppl//GSM86833.cel.gz?tool=geoquery'
# Content type 'application/x-gzip' length 3700007 bytes (3.5 MB)
# downloaded 3.5 MB





#loading raw data into R
raw_data <- ReadAffy(filenames=sample_IDs, compress=TRUE)
#normalizing via RMA method Irizarry 2003
expression <- 2^exprs(rma(raw_data)) 



# ------------------------------------
Lukasz



# if (!requireNamespace("BiocManager"))

#   install.packages("BiocManager")

# BiocManager::install()

# BiocManager::install("PSEA", version = "3.8")

# BiocManager::install("AnnotationDbi")

# BiocManager::install("illuminaMousev2.db")



library("GEOquery")

library("AnnotationDbi")

library("PSEA")

library("MASS")

#BiocManager::install("illuminaMousev2.db", version = "3.8")
library("illuminaMousev2.db")



# in the above we dont need affy & hgu133a.db - these are for Affymetrix

geop <- getGEO('GSE47029',destdir="C:/Users/User/Desktop/kaul_lab_work/decon") # in the first run
geop <- getGEO('GSE47029',filename="~/Desktop/GEO_data/GSE47029_series_matrix.txt.gz") # later it gets it from disc



exprl=2^exprs(geop$GSE47029_series_matrix.txt.gz) # I had to add $GSE etc back in or wouldnt read



#example of translating gene symbols into probesets below

neuron_genes=c("Nefm")####selects the neuron marker gene for reference signals
neuron_probesets=mapIds(illuminaMousev2.db, keys=neuron_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")

microglia_genes=c("Aif1")
microglia_probesets=mapIds(illuminaMousev2.db, keys=microglia_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")


#neuron_probesets to be used in marker function
neuron_reference <- marker(exprl, neuron_probesets)#exprl was 'expression' previously 
microglia_reference <- marker(exprl, microglia_probesets)#exprl was 'expression' previously 


#making vector with length of data and ctrl = 0 HD = 1
groups <- c(rep(0, length(male)), rep(1, length(female))) 
str(groups)
str(neuron_reference)
str(neuron_probesets)

neuron_difference <- groups * neuron_reference# sets all males to 0 i believe 

model1 <- lm(exprl["ILMN_1225279",] ~ neuron_reference, subset=which(groups==0)) #names from neuron_probeset not showing up eg "ILMN_1225279"
model2 <- lm(exprl["ILMN_1225279",] ~ neuron_reference, subset=which(groups==1))

model3 <- lm(exprl["ILMN_2632416",] ~ neuron_reference, subset=which(groups==0))
model4 <- lm(exprl["ILMN_2632416",] ~ neuron_reference, subset=which(groups==1))

model5 <- lm(exprl["ILMN_2938820",] ~ neuron_reference, subset=which(groups==0))
model6 <- lm(exprl["ILMN_2938820",] ~ neuron_reference, subset=which(groups==1))


###visualising ILMN_1225279
X11()
par(mfrow=c(1,2), cex=1.2)
crplot(model1, "neuron_reference", newplot=FALSE)
crplot(model2, "neuron_reference", newplot=FALSE)
summary(model1)
summary(model2)



model12 <- lm(exprl["ILMN_1225279",] ~ neuron_reference + neuron_difference)
crplot(model12, "neuron_reference", g="neuron_difference")
summary(model12)

par(mfrow=c(1,1), cex=1.2)
crplot(model1, "neuron_reference", newplot=FALSE,)


### vis ILMN_2632416
X11()
par(mfrow=c(1,2), cex=1.2)
crplot(model3, "neuron_reference", newplot=FALSE)
crplot(model4, "neuron_reference", newplot=FALSE)
summary(model3)
summary(model4)

#vis ILMN_2938820
X11()
par(mfrow=c(1,2), cex=1.2)
crplot(model5, "neuron_reference", newplot=FALSE)
crplot(model6, "neuron_reference", newplot=FALSE)
summary(model5)
summary(model6)


