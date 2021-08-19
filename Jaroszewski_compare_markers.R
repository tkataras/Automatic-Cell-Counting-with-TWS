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

install.packages("ggcorrplot")
library("ggcorrplot")

library("illuminaMousev2.db")

#geop <- getGEO('GSE47029',destdir="~/Desktop/GEO_data")

geop <- getGEO('GSE47029',filename="~/Desktop/GEO_data/GSE47029_series_matrix.txt.gz")
geop <- getGEO(GEO='GSE47029', destdir=".")



g=pData(geop$GSE47029_series_matrix.txt.gz)['genotype:ch1']

#sample_order=order(g) # g already in order??

exprl=2^exprs(geop$GSE47029_series_matrix.txt.gz) # I had to add $GSE etc back in or wouldnt read

#exprl=2^exprs(geop)
exprl_only_wt <- exprl[,information$`genotype:ch1` == "WT"]
exprl <- exprl_only_wt


genotypes=g[sample_order,1]



wt=which(genotypes=="WT")

ccr5kohet=which(genotypes=="CCR5KO/het")



present_probesets=rownames(exprl)


# 
# #neuron_genes=c("Nefl","Snap25","Nefm") the first two contain NAs in the data
# 
# 
# 
# neuron_genes=c("Nefm", "Reln")
# 
# neuron_probesets=mapIds(illuminaMousev2.db, keys=neuron_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
# 
# 
# # sox9 = Astrocyte-Specific Nuclear Marker in the Adult Brain Outside the Neurogenic Regions
# #
# astrocyte_genes=c("Aldh1l1", "Sox9", "Aqp4")
# 
# astrocyte_probesets=mapIds(illuminaMousev2.db, keys=astrocyte_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
# 
# 
# # Mbp = Myelin basic protein, A structural component of myelin, expressed exclusively by myelinating glia.
# #Myelin oligodendrocyte glycoprotein (MOG) A glycoprotein found on the surface of oligodendrocytes.
# #oligodendrocyte_genes=c("Olig1", "Olig2", "Olig3", "Mbp", "Mog")
# oligodendrocyte_genes=c("Mbp", "Mog")
# 
# 
# oligodendrocyte_probesets=mapIds(illuminaMousev2.db, keys=oligodendrocyte_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
# 
# 
# 
# microglia_genes=c("Aif1", "Ccl4")
# z
# microglia_probesets=mapIds(illuminaMousev2.db, keys=microglia_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
# 
# 
# #what is purpose of below line?????? doesnt change the var
# #microglia_probesets=lapply(microglia_probesets, function(x) intersect(x,present_probesets))###what is the purpose of this????????????????????????????/
# 
# 


# from current probesets as of 2/12/2019

#example of translating gene symbols into probesets -> reference sets below, Nefm = neuron marker gene,  
neuron_genes=c("Nefm", "Reln","Mapt")####  "Map2" subscript out of bounds on GEO data# "neurofiliment medium gene, Reelin protein
neuron_probesets=mapIds(illuminaMousev2.db, keys=neuron_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
neuron_reference <- marker(exprl, neuron_probesets)
#again warning = 'select()' returned 1:many mapping between keys and columns
microglia_genes=c("Aif1", "Ccl4")#aif1 = gene for iba1 prot, 
microglia_probesets=mapIds(illuminaMousev2.db, keys=microglia_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
microglia_reference <- marker(exprl, microglia_probesets)

astrocyte_genes=c("Aldh1l1", "Aqp4", "Sox9", "Gfap", "Megf10", "Gulp1")# aldh1=astro promoter,sox9 = astro in adult brain, aqp=aquaporin; tried Glt1, but it didnt work, no matches, 
astrocyte_probesets=mapIds(illuminaMousev2.db, keys=astrocyte_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
#aldh1 probe 4 weak corr with all other aldh1
astrocyte_probesets[[1]] <- astrocyte_probesets[[1]][-3]
astrocyte_reference  <- marker(exprl, astrocyte_probesets)

oligo_genes=c("Mog", "Mbp")# myelin oligodendrocyte glycoprotein, Myelin basic protein
oligodendrocyte_probesets=mapIds(illuminaMousev2.db, keys=oligo_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
#mbp probe 4 shows poor intercorrelation ILMN_3011353
oligodendrocyte_probesets[[2]] <- oligodendrocyte_probesets[[2]][-4] 
oligodendrocyte_reference <- marker(exprl, oligodendrocyte_probesets)

#endoth_genes=c("Pecam1", "Cd34", "Foxf2","Foxq1", "Zic3", "Foxl2", "Lef1", "Ppard", "Zic3")
#endoth_genes=c("Pecam1", "Cd34", "Foxf2","Foxq1", "Zic3", "Foxl2", "Lef1", "Ppard") #ppard adn zic3 probesets not found in our GEO data
endoth_genes=c("Pecam1", "Cd34", "Foxf2","Foxq1", "Zic3", "Foxl2", "Lef1")




endoth_probesets=mapIds(illuminaMousev2.db, keys=endoth_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
endoth_reference <- marker(exprl, endoth_probesets)



markers_probesets=c(unlist(neuron_probesets),unlist(astrocyte_probesets),unlist(oligodendrocyte_probesets),unlist(microglia_probesets), unlist(endoth_probesets))

#only endothelial
markers_probesets= unlist(endoth_probesets)
#only astro
markers_probesets= unlist(astrocyte_probesets)

markers_exprl=exprl[markers_probesets,]

rownames(markers_exprl)=names(markers_probesets)



marker_cor <- as.matrix(cor(t(markers_exprl),method="pearson"))
X11()
print(ggcorrplot(marker_cor, colors = c("blue", "white", "red"), lab=TRUE, hc.order = TRUE))

readline(prompt="Press [enter] to continue")

