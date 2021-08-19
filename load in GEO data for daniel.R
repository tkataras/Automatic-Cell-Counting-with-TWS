#for daniel


library("GEOquery") #get GEO accession

library("AnnotationDbi") #annotate illumina microarray??

library("PSEA") #functions for processing and analysis 

geo = 'GSE47029'

geop <- getGEO(GEO=geo, destdir="./")

#geop <- getGEO('GSE47029',destdir="C:/Users/User/Desktop/kaul_lab_work/decon") # in the first run
geop <- getGEO('GSE47029',filename="C:/Users/User/Desktop/kaul_lab_work/decon/GSE47029_series_matrix.txt.gz")

#un-neg log expression data, row = gene, col~samples
exprl=2^exprs(geop)
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

