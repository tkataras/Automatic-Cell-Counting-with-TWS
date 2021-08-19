# if (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")

#install.packages("RSQLite")
library("RSQLite")

#install.packages("bit")
library("bit")

#BiocManager::install("SGSeq")
#BiocManager::install("digest")
library("digest")
library("SGSeq")


###trying to look at the BAM file weve got
BiocManager::install("Rsamtools")
library("Rsamtools")

#which <- IRangesList(seq1=IRanges(1000, 2000), seq2=IRanges(c(100, 1000), c(1000, 2000)))
which <- IRangesList(seq1=IRanges(1000, 2000))


what <- c("rname", "strand", "pos", "qwidth", "seq")
param <- ScanBamParam(which=which, what=what)

list.files("./")

scanBam("Galaxy2HISAT2_on_data_1__aligned_reads_BC176_BaL_CTRL2.bam",  param=ScanBamParam(what=scanBamWhat()))#this worked, appears unpaired

scanBam("Galaxy2HISAT2_on_data_1__aligned_reads_BC176_BaL_CTRL2.bam")

BamFile <- system.file( "Galaxy2HISAT2_on_data_1__aligned_reads_BC176_BaL_CTRL2.bam",  package="Rsamtools")
BamFile

# 
# ## ---- echo = FALSE, results = 'hide'---------------------------------------
# library(knitr)
# opts_chunk$set(error = FALSE)
# 
# ## ----style, echo = FALSE, results = 'asis'---------------------------------
# ##BiocStyle::markdown()
# 
# ## ---- message = FALSE------------------------------------------------------
# library(SGSeq)

## --------------------------------------------------------------------------
si
si2 <- si
###si needs to following info its its columns
# sample_name - Character vector with a unique name for each sample
# file_bam - Character vector or BamFileList specifying BAM files generated with a splice-aware alignment program
# paired_end - Logical vector indicating whether data are paired-end or single-end
# read_length - Numeric vector with read lengths
# frag_length - Numeric vector with average fragment lengths (for paired-end data)

# lib_size - Numeric vector with the total number of aligned reads for 
#single-end data, or the total number of concordantly aligned read pairs for paired-end data

si2$sample_name <- "N1"
si2$file_bam <- "E:/Project MDM HIV RNAseq Data/Theo_work/Galaxy2HISAT2_on_data_1__aligned_reads_BC176_BaL_CTRL2.bam"
si2$paired_end <- FALSE
si2$read_length <- 50
si2$frag_length <- 0
#number fo aligned reads: 12221184 - 1192630 = 11028554
si$lib_size <- 11028554

#cutting down to single sample for testing;
si2 <- si2[1,]
si2
## -------------------------------------------------------------------------- 
#path <- system.file("extdata", package = "SGSeq")
#si$file_bam <- file.path(path, "bams", si$file_bam)

## ---- message = FALSE------------------------------------------------------ installing the database for alignment
# BiocManager::install("TxDb.Hsapiens.UCSC.hg19.knownGene")

#chromosome names are changed to match the naming convention used in the BAM files.
library(TxDb.Hsapiens.UCSC.hg19.knownGene)

#used hg38 for alignemnt BUT I CANNOT GET THE HG38 DB TO LOAD!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#source('http://bioconductor.org/biocLite.R')
#biocLite('AnnotationDbi')

library("AnnotationDbi")
#BiocManager::install("TxDb.Hsapiens.UCSC.hg38.knownGene")
library(TxDb.Hsapiens.UCSC.hg38.knownGene)

txdb <- TxDb.Hsapiens.UCSC.hg38.knownGene
txdb <- keepSeqlevels(txdb, "chr1") ## all gbp in human on chr1
#seqlevelsStyle(txdb) <- "NCBI"

## --------------------------------------------------------------------------
###To work with the annotation in the SGSeq framework, transcript features are extracted from the TxDb object using function convertToTxFeatures(). 
###Only features overlapping the genomic locus of the FBXO31 gene are retained. The genomic coordinates of FBXO31 are stored in a GRanges object gr.
txf_ucsc <- convertToTxFeatures(txdb)

#gr is a g ranges object, need to set if for each gene of interest? 
#ncbi hGBP4: GRCh37.p13 89181144 .. 89198942
proto_gr_df <- as.data.frame(c(89181144,89198942 ))
 
# df <- data.frame(chr="chr1", start=11:15, end=12:16,
#                  strand=c("+","-","+","*","."), score=1:5)

df <- data.frame(chr="chr1", start=89181140:89181144, end=89198942:89198946, score=1:5)

                 

df
gr <- makeGRangesFromDataFrame(df)  # strand value "." is replaced with "*"






txf_ucsc2 <- txf_ucsc[txf_ucsc %over% gr]
head(txf_ucsc2)

## --------------------------------------------------------------------------
# J (splice junction)
# I (internal exon)
# F (first/5'-terminal exon)
# L (last/5'-terminal exon)
# U (unspliced transcript).

type(txf_ucsc)
head(txName(txf_ucsc))
head(geneName(txf_ucsc))

## --------------------------------------------------------------------------
sgf_ucsc <- convertToSGFeatures(txf_ucsc)
head(sgf_ucsc)

# Similar to TxFeatures, SGFeatures are GRanges-like objects with additional columns. Column type for an SGFeatures object takes values
# 
# J (splice junction)
# E (disjoint exon bin)
# D (splice donor site)
# A (splice acceptor site).


## ---- message = FALSE------------------------------------------------------
###not about to load bam:   failed to open BamFile: failed to load BAM index

getBamInfo()
si_complete <- getBamInfo(si)


## DataFrame as sample_info and BamFileList as file_bam
DF <- DataFrame(si)
DF$file_bam <- BamFileList(DF$file_bam)
DF_complete <- getBamInfo(DF)
str(DF_complete)





sgfc_ucsc <- analyzeFeatures(si, features = txf_ucsc)
sgfc_ucsc

## ---- eval = FALSE---------------------------------------------------------
#  colData(sgfc_ucsc)
#  rowRanges(sgfc_ucsc)
#  head(counts(sgfc_ucsc))
#  head(FPKM(sgfc_ucsc))

## ----figure-1, fig.width=4.5, fig.height=4.5-------------------------------
df <- plotFeatures(sgfc_ucsc, geneID = 1)

## ---- message = FALSE------------------------------------------------------
sgfc_pred <- analyzeFeatures(si, which = gr)
head(rowRanges(sgfc_pred))

## --------------------------------------------------------------------------
sgfc_pred <- annotate(sgfc_pred, txf_ucsc)
head(rowRanges(sgfc_pred))

## ----figure-2, fig.width=4.5, fig.height=4.5-------------------------------
df <- plotFeatures(sgfc_pred, geneID = 1, color_novel = "red")



###end of the section covering existing annotation
## ---- message = FALSE------------------------------------------------------
sgvc_pred <- analyzeVariants(sgfc_pred)
sgvc_pred

## --------------------------------------------------------------------------
mcols(sgvc_pred)

## --------------------------------------------------------------------------
variantFreq(sgvc_pred)

## ----figure-3, fig.width=1.5, fig.height=4.5-------------------------------
plotVariants(sgvc_pred, eventID = 1, color_novel = "red")

## ---- message = FALSE------------------------------------------------------
library(BSgenome.Hsapiens.UCSC.hg19)
seqlevelsStyle(Hsapiens) <- "NCBI"
vep <- predictVariantEffects(sgv_pred, txdb, Hsapiens)
vep

## ---- eval = FALSE---------------------------------------------------------
#  plotFeatures(sgfc_pred, geneID = 1)
#  plotFeatures(sgfc_pred, geneName = "79791")
#  plotFeatures(sgfc_pred, which = gr)

## ---- eval = FALSE---------------------------------------------------------
#  plotFeatures(sgfc_pred, geneID = 1, include = "junctions")
#  plotFeatures(sgfc_pred, geneID = 1, include = "exons")
#  plotFeatures(sgfc_pred, geneID = 1, include = "both")

## ---- eval = FALSE---------------------------------------------------------
#  plotFeatures(sgfc_pred, geneID = 1, toscale = "gene")
#  plotFeatures(sgfc_pred, geneID = 1, toscale = "exon")
#  plotFeatures(sgfc_pred, geneID = 1, toscale = "none")

## ---- figure-4, fig.width=4.5, fig.height=4.5------------------------------
par(mfrow = c(5, 1), mar = c(1, 3, 1, 1))
plotSpliceGraph(rowRanges(sgfc_pred), geneID = 1, toscale = "none", color_novel = "red")
for (j in 1:4) {
  plotCoverage(sgfc_pred[, j], geneID = 1, toscale = "none")
}

## ---- message = FALSE------------------------------------------------------
sgv <- rowRanges(sgvc_pred)
sgvc <- getSGVariantCounts(sgv, sample_info = si)
sgvc

## --------------------------------------------------------------------------
x <- counts(sgvc)
vid <- variantID(sgvc)
eid <- eventID(sgvc)

## ---- message = FALSE------------------------------------------------------
txf <- predictTxFeatures(si, gr)
sgf <- convertToSGFeatures(txf)
sgf <- annotate(sgf, txf_ucsc)
sgfc <- getSGFeatureCounts(si, sgf)
sgv <- findSGVariants(sgf)
sgvc <- getSGVariantCounts(sgv, sgfc)

## --------------------------------------------------------------------------
sessionInfo()
