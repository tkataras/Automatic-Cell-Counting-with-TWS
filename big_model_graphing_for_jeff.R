strain <- as.factor(information$`strain:ch1`)

age_months<- as.numeric(information$`age months:ch1`)


sex <- information$`Sex:ch1`
sex[sex == "M"] = 1
sex[sex == "F"] = 0
sex <- as.numeric(sex)

###need to set HIPEX to 0 and LAV to 1
strain_bl <- as.character(strain)
strain_bl[strain=="HIPEX"] = 0
strain_bl[strain=="LAV"] = 1
strain_bl <- as.numeric(strain_bl)



model_big <- lm(exprl[goi,] ~ neuron_reference + microglia_reference + astrocyte_reference + oligo_reference)# +age_months+sex) #+strain_bl+ endoth_reference ; , subset = which(groups==0)

g=NULL#for intercept???


x11()
testname <- NA
neuro_plot1 = ggplot(data = model_big, aes(x = neuron_reference, col=information$`genotype:ch1`, y = .resid + as.matrix(model_big$model[, c("neuron_reference", g)]) %*% model_big$coef[c("neuron_reference", g)] )) + 
  geom_point() + 
  geom_abline(slope = model_big$coefficients[[2]], intercept =  0) +
  #annotate("text",x=mean(range(neuron_reference)),y=max(model_big$residuals + model_big$coefficients[2]),label = paste("coef=",as.character(round(model_big$coefficients[2],3))), col="red") +
  #annotate("text",x=mean(range(neuron_reference)),y=max(model_big$residuals)+ model_big$coefficients[2] -max(model_big$residuals)/10,
           #label = paste("p_val=",round(pvalmat(list(model_big), c("neuron_reference","microglia_reference", "astrocyte_reference", "oligo_reference","endoth_reference"))[1],4)), col="red") +
  theme(legend.position = "none") +
  ylab(paste("CR_",as.character(goi_name))) 

#each y values is: residual + ref_value * slope coeff
micro_plot1 = ggplot(model_big, aes(x = microglia_reference,col=information$`genotype:ch1`, y = .resid + as.matrix(model_big$model[, c("microglia_reference", g)]) %*% model_big$coef[c("microglia_reference", g)])) + 
  geom_point() +  
  geom_abline(slope = model_big$coefficients[[3]], intercept =  0) +
  #annotate("text",x=mean(range(microglia_reference)),y=max(model_big$residuals + model_big$coefficients[3]),label = paste("coef=",as.character(round(model_big$coefficients[3],3))), col="red") +
  #annotate("text",x=mean(range(microglia_reference)),y=max(model_big$residuals)+ model_big$coefficients[3]-max(model_big$residuals)/10,
           #label = paste("p_val=",round(pvalmat(list(model_big), c("neuron_reference","microglia_reference", "astrocyte_reference", "oligo_reference","endoth_reference"))[2],4)), col="red") +
  theme(legend.position = "none") +
  ylab(paste("CR_",as.character(goi_name)))


astro_plot1 = ggplot(model_big, aes(x = astrocyte_reference,col=information$`genotype:ch1`, y = .resid + as.matrix(model_big$model[, c("astrocyte_reference", g)]) %*% model_big$coef[c("astrocyte_reference", g)])) + 
  geom_point() + 
  geom_abline(slope = model_big$coefficients[[4]], intercept =  0) +
  #annotate("text",x=mean(range(astrocyte_reference)),y=max(model_big$residuals + model_big$coefficients[4]),label = paste("coef=",as.character(round(model_big$coefficients[4],3))), col="red") +
  #annotate("text",x=mean(range(astrocyte_reference)),y=max(model_big$residuals)+ model_big$coefficients[4]-max(model_big$residuals)/10,
           #label = paste("p_val=",round(pvalmat(list(model_big), c("neuron_reference","microglia_reference", "astrocyte_reference", "oligo_reference","endoth_reference"))[3],4)), col="red") +
  theme(legend.position = "none") +
  ylab(paste("CR_",as.character(goi_name)))


# oligo_plot1 = ggplot(model_big, aes(x = oligo_reference, y = .resid + as.matrix(model_big$model[, c("oligo_reference", g)]) %*% model_big$coef[c("oligo_reference", g)])) + 
#   geom_point() + 
#   geom_abline(slope = model_big$coefficients[[5]], intercept =  0) +
#   annotate("text",x=mean(range(oligo_reference)),y=max(model_big$residuals + model_big$coefficients[5]),label = paste("coef=",as.character(round(model_big$coefficients[5],3))), col="red") +
#   annotate("text",x=mean(range(oligo_reference)),y=max(model_big$residuals)+ model_big$coefficients[5]-max(model_big$residuals)/10,
#            label = paste("p_val=",round(pvalmat(list(model_big), c("neuron_reference","microglia_reference", "astrocyte_reference", "oligo_reference","endoth_reference"))[4],4)), col="red") +
#   ylab(paste("CR_",as.character(goi_name)))
# 
# # 
# endoth_plot1 = ggplot(model_big, aes(x = endoth_reference, y = .resid + as.matrix(model_big$model[, c("endoth_reference", g)]) %*% model_big$coef[c("endoth_reference", g)])) + 
#   geom_point() + 
#   geom_abline(slope = model_big$coefficients[[6]], intercept =  0) +
#   annotate("text",x=mean(range(oligo_reference)),y=max(model_big$residuals + model_big$coefficients[6]),label = paste("coef=",as.character(round(model_big$coefficients[6],3))), col="red") +
#   annotate("text",x=mean(range(oligo_reference)),y=max(model_big$residuals)+ model_big$coefficients[6]-max(model_big$residuals)/10,
#            label = paste("p_val=",round(pvalmat(list(model_big), c("neuron_reference","microglia_reference", "astrocyte_reference", "oligo_reference", "endoth_reference"))[5],4)), col="red") +
#   ylab(paste("CR_",as.character(goi_name)))

# age_plot1 = ggplot(model_big, aes(x = age_months, y = .resid + as.matrix(model_big$model[, c("age_months", g)]) %*% model_big$coef[c("age_months", g)])) +
#   geom_point() +  geom_abline(slope = model_big$coefficients[[6]], intercept =  0)+
#   annotate("text",x=mean(range(age_months)),y=max(model_big$residuals + model_big$coefficients[6]),label = paste("coef=",as.character(round(model_big$coefficients[6],3))), col="red") +
#   annotate("text",x=mean(range(age_months)),y=max(model_big$residuals)+ model_big$coefficients[6]-max(model_big$residuals)/10,
#            label = paste("p_val=",round(pvalmat(list(model_big), c("neuron_reference","microglia_reference", "astrocyte_reference", "oligo_reference","endoth_reference", "age_months"))[6],4)), col="red") +
#   ylab(paste("CR_",as.character(goi_name)))
# 
# sex_plot1 = ggplot(model_big, aes(x = sex, y = .resid + as.matrix(model_big$model[, c("sex", g)]) %*% model_big$coef[c("sex", g)])) +
#   geom_point() +  geom_abline(slope = model_big$coefficients[[7]], intercept =  0)+
#   annotate("text",x=mean(range(sex)),y=max(model_big$residuals + model_big$coefficients[7]),label = paste("coef=",as.character(round(model_big$coefficients[7],3))), col="red") +
#   annotate("text",x=mean(range(sex)),y=max(model_big$residuals)+ model_big$coefficients[7]-max(model_big$residuals)/10,
#            label = paste("p_val=",round(pvalmat(list(model_big), c("neuron_reference","microglia_reference", "astrocyte_reference", "oligo_reference","endoth_reference", "age_months", "sex"))[7],4)), col="red") +
#   ylab(paste("CR_",as.character(goi_name)))
#

# 
# strain_plot1 = ggplot(model_big, aes(x = strain_bl, y = .resid + as.matrix(model_big$model[, c("strain_bl", g)]) %*% model_big$coef[c("strain_bl", g)])) + 
#   geom_point() +  geom_abline(slope = model_big$coefficients[[8]], intercept =  0)+
#   annotate("text",x=mean(range(strain_bl)),y=max(model_big$residuals + model_big$coefficients[8]),label = paste("coef=",as.character(round(model_big$coefficients[8],3))), col="red") +
#   annotate("text",x=mean(range(strain_bl)),y=max(model_big$residuals)+ model_big$coefficients[8]-max(model_big$residuals)/10,
#            label = paste("p_val=",round(pvalmat(list(model_big), c("neuron_reference","microglia_reference", "astrocyte_reference", "oligo_reference","endoth_reference", "age_months", "sex",  "strain_bl"))[8],4)), col="red") +
#   ylab(paste("CR_",as.character(goi_name)))
# 
# 


#plot(neuro_plot1)
#plot(sex_plot1)
#plot(strain_plot1)

#visualise the above charts

X11()

grid.arrange(neuro_plot1,micro_plot1,astro_plot1, nrow = 1)#,oligo_plot1, age_plot1,sex_plot1,  nrow = 2) #endoth_plot1,strain_plot1,


summary(model_big)
goi
goi_name






