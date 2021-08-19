# making cell pop trend graph


#load in exprl and info on other script and the markers


m_wt_neuro=mean(neuron_reference[information$`genotype:ch1` == "WT"])
m_wt_astro=mean(astrocyte_reference[information$`genotype:ch1` == "WT"])
m_wt_micro=mean(microglia_reference[information$`genotype:ch1` == "WT"])
m_wt_oligo=mean(oligo_reference[information$`genotype:ch1` == "WT"])


m_gp120_neuro=mean(neuron_reference[information$`genotype:ch1` == "gp120"])
m_gp120_astro=mean(astrocyte_reference[information$`genotype:ch1` == "gp120"])
m_gp120_micro=mean(microglia_reference[information$`genotype:ch1` == "gp120"])
m_gp120_oligo=mean(oligo_reference[information$`genotype:ch1` == "gp120"])


## could do a t test to verify that the markers dont change between the genotypes, but nobody has reported that
##im certain it will show a sig diff for asto and likely micro







####visualizations
X11()
par(mfrow=c(2,3))

#neuro
diff_c <- as.character(round(model2_neuro$coefficients[3],3))
diff_p <- round(pvalmat(list(model2_neuro), c("neuron_reference","neuron_difference"))[2],4)

neuro_title <- paste("neuro", goi_name, "red is ",group_ok)#title for auto save file
#X11() 
model2_neuro_plot<- crplot(model2_neuro, "neuron_reference", g="neuron_difference",newplot = F, ylim = c(0,max(model2_neuro$model)))
title(paste("Neuron", goi_name, "red = ",group_ok))
# legend("top","center", paste("coef=",as.character(round(model2_neuro$coefficients[2],3)),
#                              "p_val=",round(pvalmat(list(model2_neuro), c("neuron_reference","neuron_difference"))[1],4)))
# legend("bottom", paste("diff_coef=",as.character(diff_c), "p=",as.character(diff_p)))
#legend("right", paste("red = only ", group_ok))


#X11()
boxplot(exprl[goi,]~information$`genotype:ch1`,
        data=airquality,
        main="",
        xlab="Geno",
        ylab="expression",
        col="orange",
        border="brown"
        #ylim = c(0,max(model2_neuro$model))
)

col=information$`genotype:ch1`



#X11()
plot(neuron_reference,exprl[goi,], col=as.factor(information$`genotype:ch1`), 
     abline(c(model2_neuro, model2_neuro[1]))) #,  ylim= c(0,max(model2_neuro$model)))


X11()
plot(neuron_reference,exprl[goi,], col=as.factor(information$`genotype:ch1`), 
     abline(model2_neuro),  ylim= c(0,max(model2_neuro$model)))





abline(a=0, b=model2_neuro$coefficients["neuron_difference"])



model2_neuro <- lm(exprl[goi,] ~ neuron_reference + neuron_difference)

model2_neuro_diff <- lm(exprl[goi,neuron_difference > 0] ~  neuron_difference[neuron_difference > 0])

#X11()
plot(neuron_reference,exprl[goi,], col=as.factor(information$`genotype:ch1`), abline(model2_neuro_diff ), ylim= c(0,max(model2_neuro$model)))



abline(model2_neuro$coefficients["neuron_difference"])









X11()
#neuro
diff_c <- as.character(round(model2_neuro$coefficients[3],3))
diff_p <- round(pvalmat(list(model2_neuro), c("neuron_reference","neuron_difference"))[2],4)

neuro_title <- paste("neuro", goi_name, "red is ",group_ok)#title for auto save file
#X11() 
model2_neuro_plot<- crplot(model2_neuro, "neuron_reference", g="neuron_difference",newplot = F)
title(paste("Neuron", goi_name, "red = ",group_ok))
legend("top","center", paste("coef=",as.character(round(model2_neuro$coefficients[2],3)),
                             "p_val=",round(pvalmat(list(model2_neuro), c("neuron_reference","neuron_difference"))[1],4)))
legend("bottom", paste("diff_coef=",as.character(diff_c), "p=",as.character(diff_p)))
#legend("right", paste("red = only ", group_ok))






X11()
g=NULL#for intercept???

neuro_plot1 = ggplot(data = model2_neuro, aes(x = neuron_reference, y = .resid + as.matrix(model2_neuro$model[, c("neuron_reference", g)]) %*% model2_neuro$coef[c("neuron_reference", g)])) + 
  geom_point() + 
  geom_abline(slope = model2_neuro$coefficients[[2]], intercept =  0)
  
  
  
  
  
  annotate("text",x=mean(range(neuron_reference)),y=max(model1$residuals + model1$coefficients[2]),label = paste("coef=",as.character(round(model1$coefficients[2],3))), col="red") +
  annotate("text",x=mean(range(neuron_reference)),y=max(model1$residuals)+ model1$coefficients[2] -max(model1$residuals)/10,
           label = paste("p_val=",round(pvalmat(list(model1), c("neuron_reference","microglia_reference", "astrocyte_reference", "oligo_reference","endoth_reference"))[1],4)), col="red") +
  ylab(paste("CR_",as.character(goi_name)))



  
  X11()
  par(mfrow=c(1,4))
  boxplot(exprl[goi,]~information$`genotype:ch1`,
          data=airquality,
          main="",
          xlab="Geno",
          ylab="expression",
          col="orange",
          border="brown"
          #ylim = c(0,max(model2_neuro$model))
  )
  
  
  #X11()
  crplot(models[[2]][["ILMN_2816876"]], "2", g="6",newplot = F)
  
  plot(neuron_reference,exprl[goi,], col=as.factor(information$`genotype:ch1`), 
       abline(c(model2_neuro, model2_neuro[1]))) #,  ylim= c(0,max(model2_neuro$model)))
  
  diff_c <- as.character(round(model2_neuro$coefficients[3],3))
  diff_p <- round(pvalmat(list(model2_neuro), c("neuron_reference","neuron_difference"))[2],4)
  
  neuro_title <- paste("neuro", goi_name, "red is ",group_ok)#title for auto save file
  #X11() 
  model2_neuro_plot<- crplot(model2_neuro, "neuron_reference", g="neuron_difference",newplot = F)
  title(paste("Neuron", goi_name, "red = ",group_ok))
  legend("top","center", paste("coef=",as.character(round(model2_neuro$coefficients[2],3)),
                               "p_val=",round(pvalmat(list(model2_neuro), c("neuron_reference","neuron_difference"))[1],4)))
  legend("bottom", paste("diff_coef=",as.character(diff_c), "p=",as.character(diff_p)))
  #legend("right", paste("red = only ", group_ok))
  
