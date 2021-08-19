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

dataset <- getGEO(GEO="GSE3790", destdir=".")
