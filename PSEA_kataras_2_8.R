# if (!requireNamespace("BiocManager"))

#   install.packages("BiocManager")

# BiocManager::install()

# BiocManager::install("PSEA", version = "3.8")

# BiocManager::install("AnnotationDbi")

# BiocManager::install("illuminaMousev2.db")


install.packages("purrr")
library("purrr")
library("GEOquery")

library("AnnotationDbi")

library("PSEA")

library("MASS")

library("illuminaMousev2.db")



#geop <- getGEO('GSE47029',destdir="C:/Users/User/Desktop/kaul_lab_work/decon") # in the first run

####introduce experimental data
geop <- getGEO(GEO='GSE47029', destdir=".")
# warning from line above: 'select()' returned 1:many mapping between keys and columns


##### normalizes the log2 scaled exp data and extracneuts expression data from GEO info; exprl row = gene, col~samples
exprl=2^exprs(geop$GSE47029_series_matrix.txt.gz) # I had to add $GSE etc back in or wouldnt read
##is the 2^ neccessary? give raw expression???


#has 550525 NA values!!!! want to remove rows?? with NA vals
head(exprl)
sum(is.na(exprl))
dim(exprl)
exprl2 <- na.omit(exprl)
dim(exprl2)
sum(is.na(exprl2))
head(exprl2)
exprl <- exprl2

#example of translating gene symbols into probesets -> reference sets below, Nefm = neuron marker gene, aif1 = gene for iba1 prot 
neuron_genes=c("Nefm", "Reln")# could add more genes here "neurofiliment medium gene
neuron_probesets=mapIds(illuminaMousev2.db, keys=neuron_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
neuron_reference <- marker(exprl, neuron_probesets)
#again warning = 'select()' returned 1:many mapping between keys and columns
microglia_genes=c("Aif1", "Ccl4")
microglia_probesets=mapIds(illuminaMousev2.db, keys=microglia_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
microglia_reference <- marker(exprl, microglia_probesets)

astrocyte_genes=c("Aldh1l1", "Aqp4", "Sox9")# tried Glt1, but it didnt work, no matches, 
astrocyte_probesets=mapIds(illuminaMousev2.db, keys=astrocyte_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
astrocyte_reference <- marker(exprl, astrocyte_probesets)

oligo_genes=c("Mog", "Mbp")
oligo_probesets=mapIds(illuminaMousev2.db, keys=oligo_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
oligo_reference <- marker(exprl, oligo_probesets)


#probesets loaded, now need to get the sample info for experimental data
information <- pData(phenoData(geop [["GSE47029_series_matrix.txt.gz"]]))
names(information)
# making a variable for sex
sex <-as.character(information[,"Sex:ch1"]) 

male <- grep("M", sex)
female <- grep("F", sex)



#groups <- c(rep(0, length(male)), rep(1, length(female))) this doesnt account for the fact that male an female samples arent all grouped together
names(information)
####groups var sets all FEMALE samples to zero
groups <- as.numeric(information$`Sex:ch1`== "M")
groups_gp120 <- as.numeric(information$`genotype:ch1` == "gp120" | information$`genotype:ch1` == "CCR5KO_x_gp120")
#groups <- groups_gp120                           

groups2 <-as.numeric(information$`Sex:ch1`== "F")
#groups <- as.numeric(information$)

#### x_difference data is just the male samples, females set to 0
neuron_difference <- groups * neuron_reference
microglia_difference <- groups * microglia_reference
astrocyte_difference <- groups * astrocyte_reference
oligo_difference <- groups * oligo_reference

neuron_difference2 <- groups2 * neuron_reference
microglia_difference2 <- groups2 * microglia_reference
astrocyte_difference2 <- groups2 * astrocyte_reference
oligo_difference2 <- groups2 * oligo_reference


#want to test with lcn2, first we look at reference data
lcn2 <- c("Lcn2")
lcn2_illumina_name <- mapIds(illuminaMousev2.db, keys=lcn2, column='PROBEID', keytype='SYMBOL',multiVals="list")

#using the probset for lcn from above and the ref data
model1 <- lm(exprl["ILMN_2712075",] ~ neuron_reference + microglia_reference + astrocyte_reference + oligo_reference)


#visualise and summarize illumina ref data selected cell type markers on LCN2 in this case 
X11()
par(mfrow=c(1,4), cex=1.2)
crplot(model1, "neuron_reference", newplot=FALSE)
crplot(model1, "microglia_reference", newplot=FALSE)
crplot(model1, "astrocyte_reference", newplot=FALSE)
crplot(model1, "oligo_reference", newplot=FALSE)
summary(model1)

#### ALL significant, may want to quality control??? wound that help this step??

#now modeling on experimental data
model2_neuro <- lm(exprl["ILMN_2712075",] ~ neuron_reference +  neuron_difference)
#evaluating fem only and male only data intead of male
model2_neuro2 <- lm(exprl["ILMN_2712075",] ~ neuron_reference +  neuron_difference2)

#plot(model2_neuro)
crplot(model2_neuro, "neuron_reference", g="neuron_difference")
summary(model2_neuro)

model2_micro <- lm(exprl["ILMN_2712075",] ~ microglia_reference + microglia_difference)
crplot(model2_micro, "microglia_reference", g="microglia_difference")
summary(model2_micro)

model2_astro <- lm(exprl["ILMN_2712075",] ~ astrocyte_reference + astrocyte_difference)
crplot(model2_astro, "astrocyte_reference", g="astrocyte_difference")
summary(model2_astro)

model2_oligo <- lm(exprl["ILMN_2712075",] ~ oligo_reference + oligo_difference)
crplot(model2_oligo, "oligo_reference", g="oligo_difference")
summary(model2_oligo)


####FOLD DIFFERENCE??? reference coeff + diff coeff all divided by reference
model2_neuro$coefficients[2]
model2_neuro$coefficients[3]
foldchange_neuro=(model2_neuro$coefficients[2] + model2_neuro$coefficients[3])/model2_neuro$coefficients[2] 

###ccmbining reference values and expression into data frame
exprl["ILMN_2712075",][1]
neuron_reference[1]
microglia_reference[1]
astrocyte_reference[1]
exprl[,"GSM1143142"]["ILMN_2712075"]

data_frame_1 <- data.frame(exprl["ILMN_2712075",][1],
           neuron_reference[1],
           microglia_reference[1],
           astrocyte_reference[1],
           exprl[,"GSM1143142"]["ILMN_2712075"]
           
)

ref_data_frame<- data.frame(neuron_reference,
                           microglia_reference,
                           astrocyte_reference,
                           oligo_reference

)
summary(ref_data_frame)

#(neuron_reference[1] + microglia_reference[1]+astrocyte_reference[1])/3

##using the AIC to build model
model3_null <- lm(exprl["ILMN_2712075",] ~ 1,subset = which(groups==0))
summary(model3_null)
crplot(model3_null)
model3 <- stepAIC(model3_null, scope=list(upper=formula(~neuron_reference + neuron_reference + microglia_reference + astrocyte_reference + oligo_reference),
                             lower=formula(~1)), direction='both', trace=0)
summary(model3)



###now stepping through other models, first SEMA6A

SEMA6A=c("Sema6a") 
SEMA6A_probesets=mapIds(illuminaMousev2.db, keys=SEMA6A, column='PROBEID', keytype='SYMBOL',multiVals="list")

model4_null <- lm(exprl["ILMN_1215472",] ~ 1)
model4 <- stepAIC(model4_null,
                  scope=list(upper=formula(~neuron_reference +
                                             astrocyte_reference + oligo_reference + microglia_reference +
                                             neuron_difference + astrocyte_difference + oligo_difference +
                                             microglia_difference), lower=formula(~1)), direction='both',
                  trace=0)
summary(model4)


#looks to be LCN2 step AIC
# model4_null <- lm(exprl["ILMN_2712075",] ~ 1)
# model4 <- stepAIC(model4_null,
#                   scope=list(upper=formula(~neuron_reference +
#                                              astrocyte_reference + oligo_reference + microglia_reference +
#                                              neuron_difference + astrocyte_difference + oligo_difference +
#                                              microglia_difference), lower=formula(~1)), direction='both',trace=0)
# summary(model4) 


### now modeling SNC3B, 
# SNC3B=c("Snc3b")# tried, but it didnt work, no matches!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# SNC3B_probesets=mapIds(illuminaMousev2.db, keys=SNC3B, column='PROBEID', keytype='SYMBOL',multiVals="list")
# 
# model5_null <- lm(exprl["204722_at",] ~ 1)
# model5 <- stepAIC(model5_null,
#                   scope=list(upper=formula(~neuron_reference +
#                                              astrocyte_reference + oligo_reference + microglia_reference +
#                                              neuron_difference + astrocyte_difference + oligo_difference +
#                                              microglia_difference), lower=formula(~1)), direction='both',
#                   trace=0)
# summary(model5)

name=c("Ppp3ca")# calcinurin A, supposedly
PPP3ca_probesets=mapIds(illuminaMousev2.db, keys=name, column='PROBEID', keytype='SYMBOL',multiVals="list")

model5_null <- lm(exprl["ILMN_1227899",] ~ 1)#first probset
model5 <- stepAIC(model5_null,
                  scope=list(upper=formula(~neuron_reference +
                                             astrocyte_reference + oligo_reference + microglia_reference +
                                             neuron_difference + astrocyte_difference + oligo_difference +
                                             microglia_difference), lower=formula(~1)), direction='both',
                  trace=0)
summary(model5)


#lmfitst fits set of models to every transcript in an expresion profile, !!!! not sure what the "1" is doing there, look to be standing in for the intercept
model_matrix <- cbind(1, neuron_reference,
                      astrocyte_reference, oligo_reference, microglia_reference,
                      neuron_difference, astrocyte_difference, oligo_difference,
                      microglia_difference) #zeros = dropped samplse
#We then specify the subset of models that we want to fit as a list
# model_subset <- em_quantvg(c(2,3,4,5), tnv=4, ng=2) 
help(em_quantvg)
model_subset <- em_quantvg(c(2,3,4,5), tnv=4, ng=2, int = T)

model_subset[[17]] 
models <- lmfitst(t(exprl), model_matrix, model_subset,lm=T) 

summary(models[[2]][["ILMN_2712075"]])#looking at lcn2 

regressor_names <- as.character(1:9)
coefficients <- coefmat(models[[2]], regressor_names)
pvalues <- pvalmat(models[[2]], regressor_names)
models_summary <- lapply(models[[2]], summary)
adjusted_R2 <- slt(models_summary, 'adj.r.squared') #some r squared = 0

average_expression <- apply(exprl, 1, mean) # averages across rows
X11()
plot(coefficients[,1] / average_expression, adjusted_R2, pch=".")

filter <- adjusted_R2 > 0.6 & coefficients[,1] / average_expression < 0.5 
sum(filter) # number of genes?? that pass

X11()
plot(coefficients[filter,2] /average_expression[filter], -log10(pvalues[filter,2])) #### DONT ENTIRELY UNDERSTAND THIS!!!!!!!!!!!!!!!


library(annotate)
symbols <- getSYMBOL(rownames(exprl), "illuminaMousev2.db")
sum(symbols)


order <- order(pvalues[filter,6]) 
#neuronal expression levels, differences in neuronal expression in HD versus control, and their associated p-values
##### FIND OUT WHAT coer.2 adn coef.6 ARE EXACTLY
table <- data.frame(coefficients[,c(2,6)], pvalues[,c(2,6)], symbols)[filter,][order,]
table[2,]##Anxa3



#examining Anxa3, which may be sig diff bt genders?? and related to lcn2
Anxa3 <- c("Anxa3")
Anxa3_illumina_name <- mapIds(illuminaMousev2.db, keys=Anxa3, column='PROBEID', keytype='SYMBOL',multiVals="list")


model_anxa3 <- lm(exprl["ILMN_1241171",] ~ neuron_reference + microglia_reference + astrocyte_reference + oligo_reference)


#visualise and summarize illumina ref data selected cell type markers on LCN2 in this case 
X11()
par(mfrow=c(1,4), cex=1.2)
crplot(model_anxa3, "neuron_reference", newplot=FALSE)
crplot(model_anxa3, "microglia_reference", newplot=FALSE)
crplot(model_anxa3, "astrocyte_reference", newplot=FALSE)
crplot(model_anxa3, "oligo_reference", newplot=FALSE)
summary(model_anxa3)

#looking at gender for anxa3 
model2_anxa3_neuro <- lm(exprl["ILMN_1241171",] ~ neuron_reference +  neuron_difference)
#evaluating fem only and male only data intead of male
model2_anxa3_neuro2 <- lm(exprl["ILMN_1241171",] ~ neuron_reference +  neuron_difference2)

#plot(model2_neuro)
crplot(model2_anxa3_neuro, "neuron_reference", g="neuron_difference")
summary(model2_anxa3_neuro)

model2_anxa3_micro <- lm(exprl["ILMN_2712075",] ~ microglia_reference + microglia_difference)
crplot(model2_anxa3_micro, "microglia_reference", g="microglia_difference")
summary(model2_anxa3_micro)

model2_anxa3_astro <- lm(exprl["ILMN_2712075",] ~ astrocyte_reference + astrocyte_difference)
crplot(model2_anxa3_astro, "astrocyte_reference", g="astrocyte_difference")
summary(model2_anxa3_astro)

model2_anxa3_oligo <- lm(exprl["ILMN_2712075",] ~ oligo_reference + oligo_difference)
crplot(model2_anxa3_oligo, "oligo_reference", g="oligo_difference")
summary(model2_anxa3_oligo)


