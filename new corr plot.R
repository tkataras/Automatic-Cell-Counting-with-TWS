###need to have exprl and info in already etc

##now only WT


neuron_genes=c("Nefm", "Reln", "Mapt")# "neurofiliment medium gene, Reelin protein
micro_genes=c("Aif1", "Ccl4", "Cd68", "Ptprc")#aif1 = gene for iba1 prot, 
astro_genes=c("Aldh1l1", "Aqp4", "Sox9", "Gfap")# aldh1=astro promoter,sox9 = astro in adult brain, aqp=aquaporin; tried Glt1, but it didnt work, no matches, 
oligo_genes=c("Mog", "Mbp")# myelin oligodendrocyte glycoprotein, Myelin basic protein
endoth_genes=c("Pecam1", "Cd34")



neuron_probesets=mapIds(illuminaMousev2.db, keys=neuron_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
neuron_reference <- marker(exprl, neuron_probesets)

microglia_probesets=mapIds(illuminaMousev2.db, keys=micro_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
microglia_probesets[[4]] <- microglia_probesets[[4]][-1]#removing the first of 2 elements from list for Ptprc
microglia_probesets[[4]] <- microglia_probesets[[4]][-1]#removing the second of 2 elements from list for Ptprc
microglia_reference <- marker(exprl, microglia_probesets)

astrocyte_probesets=mapIds(illuminaMousev2.db, keys=astro_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
####hav to make specific changes to probesets here!!!!!!!!!!!!!!!!!######################
#aldh1 probe 4 weak corr with all other aldh1
astrocyte_probesets[[1]] <- astrocyte_probesets[[1]][-3]
astrocyte_reference  <- marker(exprl, astrocyte_probesets)

oligo_probesets=mapIds(illuminaMousev2.db, keys=oligo_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
#mbp probe 4 shows poor intercorrelation ILMN_3011353
oligo_probesets[[2]] <- oligo_probesets[[2]][-4] 
oligo_reference <- marker(exprl, oligo_probesets)

endoth_probesets=mapIds(illuminaMousev2.db, keys=endoth_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
endoth_reference <- marker(exprl, endoth_probesets)



markers_probesets=c(unlist(neuron_probesets),unlist(astrocyte_probesets),unlist(oligodendrocyte_probesets),unlist(microglia_probesets), unlist(endoth_probesets))

# #only endothelial
# markers_probesets= unlist(endoth_probesets)
markers_probesets=c(unlist(neuron_probesets),unlist(astrocyte_probesets),unlist(oligo_probesets),unlist(microglia_probesets), unlist(endoth_probesets))


markers_exprl=exprl[markers_probesets,]

rownames(markers_exprl)=names(markers_probesets)



marker_cor <- as.matrix(cor(t(markers_exprl),method="pearson"))

X11()
print(ggcorrplot(marker_cor, colors = c("blue", "white", "red"), lab=TRUE, hc.order = F))##hc.order = TRUE casues teh graphing program to cluster

