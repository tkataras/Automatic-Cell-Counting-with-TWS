#### assessing marker set error, need to have created the marker sets already

x11()
par(mfrow=c(2,3))
hist(neuron_reference)
hist(microglia_reference)
hist(astrocyte_reference)
hist(oligo_reference)
hist(endoth_reference)


exprl[unlist(neuron_probesets),1]

hist(exprl[unlist(neuron_probesets),])

hist(exprl[unlist(microglia_probesets),])

#### need to calculate with within gene averages to compare in corr plot
#strting with micro
microglia_probesets
mean(microglia_probesets[1])

exprl[unlist(microglia_probesets[1]),]


x <- exprl[unlist(microglia_probesets[1]),]
cn <- colnames(exprl[unlist(microglia_probesets[1]),])

head(x)

ccl4avg <- colMeans(x)
cd68 <- exprl[unlist(microglia_probesets[2]),]
Cx3cr1 <- exprl[unlist(microglia_probesets[3]),]


test <- cbind(ccl4avg, cd68avg,Cx3cr1avg)
plot(test)


x11()
par(mfrow=c(1,3))


plot(ccl4avg, cd68)
plot(cd68,Cx3cr1)
plot(ccl4avg,Cx3cr1)

test <- lm(ccl4avg ~ cd68)
summary(test)

test <- lm(ccl4avg ~ Cx3cr1)
summary(test)

test <- lm(cd68 ~ Cx3cr1)
summary(test)
