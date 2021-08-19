#thp1 microarray 	GPL10558	
.libPaths("C:/Users/User/Desktop/Kaul_lab_work/R-3.6.3/library/")
.libPaths()



library("purrr") # processing speed in R???
#install.packages("dplyr")
library("dplyr") #processing
#install.packages("tidyr")
library("tidyr") #processing

BiocManager::install(version = "3.10")

install.packages("BiocManager")
BiocManager::install("Biobase")
BiocManager::install("GEOquery")
BiocManager::install("PSEA")

library("Biobase")
library("GEOquery") #get GEO accession

library("AnnotationDbi") #annotate illumina microarray??

library("PSEA") #functions for processing and analysis 

library("MASS") #stat toools

#library("illuminaMousev2.db") #gene info for illumina array
#BiocManager::install("rlang")
library("rlang")

#install.packages("lifecycle")
library("lifecycle")
#install.packages("ggplot2")

#BiocManager::install("illuminaHumanv4.db")


library("illuminaHumanv4.db")


install.packages("readr")
library("readr")
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


neuron_genes = "IFNB1"
t1=mapIds(illuminaHumanv4.db, keys=neuron_genes, column='PROBEID', keytype='SYMBOL',multiVals="list")
t1
# ## GBP4 = ILMN_1771385
# $GBP1
# [1] "ILMN_1701114" "ILMN_1782487" "ILMN_2148785"
# $GBP2
# [1] "ILMN_1774077"
# $GBP3
# [1] "ILMN_1725314"
# $GBP5
# [1] "ILMN_2114568"
# $GBP6
# [1] "ILMN_1756953" "ILMN_2121568"
# $GBP7
# [1] "ILMN_2052172"
# $IRF7
# [1] "ILMN_1674646" "ILMN_1798181" "ILMN_2349061"
# $IRF3
# [1] "ILMN_1765649"
# $IRF9
# [1] "ILMN_1745471"
# $IFNAR1
# [1] "ILMN_1752923"
# $STAT1
# [1] "ILMN_1690105" "ILMN_1691364" "ILMN_1777325"
# $STAT2
# [1] "ILMN_1690921"
# $ISG15
# [1] "ILMN_2054019"
# $SOCS1
# [1] "ILMN_1774733"
# $SOCS2
# [1] "ILMN_1798926" "ILMN_2131861"
# $SOCS3
# [1] "ILMN_1781001" "ILMN_2156250"
# $USP18
# [1] "ILMN_1740200" "ILMN_3240420" "ILMN_3246658"
# $IFNA1
# [1] "ILMN_1688663"
# # 
# $IFNB1
# [1] "ILMN_1682245"
# 


####introduce experimental data, need to use fcn to create exprl var
geo = 'GSE53712'


#geop <- getGEO('GSE53712',destdir="C:/Users/User/Desktop/Kaul_lab_work/THP_microarray/")
#from rohan
setwd("C:/Users/User/Desktop/Kaul_lab_work/THP_microarray/")
geo <- getGEO(filename='GSE53712_family.soft')

exprl=exprs(geo)

# install.packages("stringi")
library("stringi")

##testing old
#C:\Users\User\Desktop\Kaul_lab_work\THP_microarray
# geop2 <- getGEO('GSE47029',filename="C:/Users/User/Desktop/kaul_lab_work/decon/GSE47029_series_matrix.txt.gz")
# exprl2=exprs(geop2)
# 
# #new
# BiocManager::install("readr")
# 

geop <- getGEO('GSE53712', filename="C:/Users/User/Desktop/Kaul_lab_work/THP_microarray/GSE53712_series_matrix.txt")
test<- geop
exprl=exprs(test)

###got to here. only loaded neccesary packages, annataioinDBI and PSEA

information <- pData(phenoData(geop))

plot(exprl["ILMN_1771385",information$`treatment:ch1` == "control"], exprl["ILMN_1771385",information$`treatment:ch1` == "gp120"])


t.test(exprl["ILMN_1771385",information$`treatment:ch1` == "control"], exprl["ILMN_1771385",information$`treatment:ch1` == "gp120"])

t.test(exprl["ILMN_1771385",information$`treatment:ch1` == "control"], exprl["ILMN_1771385",information$`treatment:ch1` == "LPS"])
#no sig diff for GBP4

#ifna ILMN_1688663
t.test(exprl["ILMN_1688663",information$`treatment:ch1` == "control"], exprl["ILMN_1688663",information$`treatment:ch1` == "gp120"])
t.test(exprl["ILMN_1688663",information$`treatment:ch1` == "control"], exprl["ILMN_1688663",information$`treatment:ch1` == "LPS"])


#GBP4 vs IRF7
plot(exprl["ILMN_1771385",information$`treatment:ch1` == "gp120"], exprl["ILMN_1674646",information$`treatment:ch1` == "gp120"])     
     
     [information$`treatment:ch1` == "control"])

boxp
exprl[,information$`genotype:ch1` == "WT" | information$`genotype:ch1` == "CCR5KO"]

##trying to anova for GBP4
library("dplyr")



group <- as.factor(information$`treatment:ch1`)
groupa <- as.factor(information$`time:ch1`)

length(information$`treatment:ch1`)
dim(exprl)

#exprl2 <- rbind(exprl, as.factor(information$`treatment:ch1`))
#dim(exprl2)

exprl
mydata <- exprl["ILMN_1771385",]
mydata2 <- rbind(mydata, information$`treatment:ch1`)
mydata2t <- t(mydata2)
  
group_by(exprl["ILMN_1771385",], mydata2t[,2]) %>%
  summarise(
    count = n(),
    mean = mean(weight, na.rm = TRUE),
    sd = sd(weight, na.rm = TRUE)
  )



exprl <- exprl[]
plot(exprl["ILMN_1212938",] ~exprl["ILMN_1214715",])



# Box plot
boxplot(mydata ~ group, data = mydata,
        xlab = "Treatment", ylab = "Weight",
        frame = FALSE, col = c("#00AFBB", "#E7B800", "#FC4E07"))

goi~information$`treatment:ch1`



# plotmeans
library("gplots")
plotmeans(weight ~ group, data = my_data, frame = FALSE,
          xlab = "Treatment", ylab = "Weight",
          main="Mean Plot with 95% CI") 

#just doing the anova
#res.aov <- aov(weight ~ group, data = my_data)

#gbp4
res.aov <- aov(exprl["ILMN_1771385",] ~ group)
summary(res.aov)

TukeyHSD(res.aov)

#IRF7
res.aov <- aov(exprl["ILMN_1674646",] ~ group)
summary(res.aov)

TukeyHSD(res.aov)

plot(exprl["ILMN_1674646",] ~ exprl["ILMN_1771385",])





### working indiviual box pot code

#goi <- exprl["ILMN_1771385",]
goi <- exprl["ILMN_1688663",information$`time:ch1` == "24h"]

info <- information$`treatment:ch1`[information$`time:ch1` == "24h"]
  
X11()
boxplot(goi~info,
        data=airquality,
        main="",
        xlab="Treatment",
        ylab="expression",
        col="orange",
        border="brown",
        pars = list(boxwex = 0.8)
)





mylevels <- levels(as.factor(info))

#levelProportions <- summary(data$names)/nrow(data)
levelProportions <- summary(as.factor(info))/length(goi)
for(i in 1:length(mylevels)){
  
  thislevel <- mylevels[i]
  thisvalues <- goi[information$`treatment:ch1`==thislevel]
  
  # take the x-axis indices and add a jitter, proportional to the N in each level
  myjitter <- jitter(rep(i, length(thisvalues)), amount=levelProportions[i]/2)
  points(myjitter, thisvalues, pch=20, col=rgb(0,0,0,.9)) 
  
}



### working indiviual box pot code but selecting out the mapk inhib
#ifna ILMN_1688663
#ifnb ILMN_1682245


goi <- exprl["ILMN_1771385",]
goi <- exprl["ILMN_1688663",information$`time:ch1` == "24h"]
goi <- goi[information$`treatment:ch1`== "control" | information$`treatment:ch1` == "LPS" | information$`treatment:ch1` == "gp120"]
goi <- goi[1:9]

info <- information$`treatment:ch1`[information$`time:ch1` == "24h"]
info <- info[info == "control" | info == "LPS" | info == "gp120"]

X11()
boxplot(goi~info,
        data=airquality,
        main="",
        xlab="Treatment",
        ylab="expression",
        col="orange",
        border="brown",
        pars = list(boxwex = 0.8),
        ylim = c(6, 10)
)





mylevels <- levels(as.factor(info))

#levelProportions <- summary(data$names)/nrow(data)
levelProportions <- summary(as.factor(info))/length(goi)
for(i in 1:length(mylevels)){
  
  thislevel <- mylevels[i]
  thisvalues <- goi[information$`treatment:ch1`==thislevel]
  
  # take the x-axis indices and add a jitter, proportional to the N in each level
  myjitter <- jitter(rep(i, length(thisvalues)), amount=levelProportions[i]/2)
  points(myjitter, thisvalues, pch=20, col=rgb(0,0,0,.9)) 
  
}






















rbind(information$`time:ch1`,
information$`treatment:ch1`,
exprl["ILMN_1674646",])


ggplot2
plot(goi~information$`treatment:ch1`)










str(geop2)
geop$`time:ch1`

geop2 <- getGEO(GEO=geo, destdir="C:/Users/User/Desktop/")
geop2ul <- (geop2[[1]])
#str(geop2ul)
exprl=2^exprs((geop2ul))
head(exprl)


#exprl=exprs(geop)


#install.packages(normalize.quantiles)

#trying w/o antilog this time, data already log2 tranformed

#exprl=exprs(geop)


#remove NA rows
exprl2 <- na.omit(exprl)
exprl <- exprl2


####need informatin to drop out the same NA rows that exprl dropped out
#information <- pData(phenoData(geop [["GSE47029_series_matrix.txt.gz"]]))
information <- pData(phenoData(geop2ul))
#information
common <-intersect(information$geo_accession,colnames(exprl))

info2 <- information[common,]
information <- info2

symbols <- mapIds(illuminaHumanv4.db, rownames(data), "SYMBOL","PROBEID")
symbold <- mapIds(illuminaHumanv4.db, rownames(data), "SYMBOL","PROBEID", multiVals = "list")

geneSymbols <- mapIds(org.Hs.eg.db, keys=rownames(M1), column="SYMBOL", keytype="ENTREZID", multiVals="first")
head(geneSymbols)
geneSymbols <- mapIds(illuminaHumanv4.db, keys=rownames(exprl), column="SYMBOL", keytype="ILLUMID", multiVals="first")


tst = "Lcn2ee"
goi_test=mapIds(illuminaHumanv4.db, keys=tst, column='PROBEID', keytype='SYMBOL',multiVals="list")
goi_test
sum(goi_test[[1]][1] == rownames(exprl))# checks for the chosen probe in the loaded exprl data
