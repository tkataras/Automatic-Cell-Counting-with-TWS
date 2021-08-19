
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
#CUTTING THIS DOWN TO FIRST 10 FOR TESTING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
sample_IDs <- sample_IDs[1:10]

# datafiles <- sapply(sample_IDs,function(x){rownames(getGEOSuppFiles(x))})#stuck here!!!

# example outcome of running datafiles command 
# trying URL 'https://ftp.ncbi.nlm.nih.gov/geo/samples/GSM86nnn/GSM86833/suppl//GSM86833.cel.gz?tool=geoquery'
# Content type 'application/x-gzip' length 3700007 bytes (3.5 MB)
# downloaded 3.5 MB





#loading raw data into R
# raw_data <- ReadAffy(filenames=sample_IDs, compress=TRUE)
#normalizing via RMA method Irizarry 2003
expression <- 2^exprs(rma(raw_data)) 

