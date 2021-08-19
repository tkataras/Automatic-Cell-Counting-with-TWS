#ANOVA with post hoc testing
library(mtcars)
data(mtcars)
head(mtcars)

anova_test <- anova()
anova2 <- aov(mtcars$mpg ~ as.factor(mtcars$cyl))
summary(anova2)
TukeyHSD(anova2)
