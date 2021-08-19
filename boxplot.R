#########Boxplot

X11()
boxplot(exprl[goi,]~information$`genotype:ch1`,
        data=airquality,
        main="",
        xlab="Geno",
        ylab="expression",
        col="orange",
        border="brown"
)






X11()
boxplot(exprl["ILMN_3100276",]~information$`genotype:ch1`,
        #data=airquality,
        main="",
        xlab="Geno",
        ylab="expression",
        col="orange",
        border="brown"
)




t.test(exprl[goi,]~information$`genotype:ch1`)

library("limma")

X11()
boxplot(exprl[information$`genotype:ch1` == "WT",],
        data=airquality,
        main="",
        xlab="Geno",
        ylab="expression",
        col="orange",
        border="brown"
)
dim(exprl)

