##machine learning workshop

diris <- iris

fit1 <- kmeans(iris[,-5], centers = 1, nstart = 10)
summary(fit1)

fit2 <- kmeans(iris[,-5], centers = 2, nstart = 10)
summary(fit2)

fit3 <- kmeans(iris[,-5], centers = 3, nstart = 10)
summary(fit2)

fit4 <- kmeans(iris[,-5], centers = 4, nstart = 10)
summary(fit2)

fit5 <- kmeans(iris[,-5], centers = 5, nstart = 10)
summary(fit2)


fit1$tot.withinss


fit2$tot.withinss


fit3$tot.withinss


fit4$tot.withinss


fit5$tot.withinss

#heirarchical clustering

hc <- hclust(dist(diris[,-5]))
plot(hc)
ct <- cutree(hc, k = 3)
dat <- iris[,-5]
cent <- NA
for (k in 1:3) {
  cent <- rbind(cent, colMeans(dat[ct == k,]))
}
plot(cent)
#didnt finish here, ask for code


#supervised machine learning

set.seed(123)
library(class)
train <- sample(nrow(iris), 0.75*nrow(iris))
knnfit <- knn(iris[train, -5], iris[-train, -5],iris[,5])

knnfit<-knn(iris[train, -5], iris[-train,-5], iris[train,5])
table(knnfit, iris[-train, 5])
mean(knnfit== iris[-train, 5])

#logistic regression
library(nnet)
lrfit <- multinom(Species ~. , data= iris[train,])
summary(lrfit)

lrpred <- predict(lrfit, data= iris[-train,-5], type = 'class')
table(lrpred, iris[-train,5])
mean(lrpred== iris[-train,5])


##Naieve bayes
install.packages("naivebayes")
library(naivebayes)
nbfit <- naive_bayes(Species ~. , data= iris[train,])
nbpred <- predict(nbfit, data= iris[train,-5], type = 'class')
table(nbpred, iris[-train,5])
mean(nbpred== iris[-train,5])



###### support vector machine
install.packages("e1071")
library(e1071)
svmfit<-svm(Species ~., data=iris[train, ], kernel = 'linear')
svmpred<-predict(svmfit, iris[-train,])
table(svmpred, iris[-train,5])
mean(svmpred== iris[-train,5])


tun <- tune(svm, Species ~. , data= iris[train,], kernel= 'linear', ranges = list(cost=seq(0.01,1,.1)))
tun

svmfit1<-svm(Species ~., data=iris[train, ], kernel = 'linear')

svmpred1<-predict(svmfit, iris[-train,])




#neural network
install.packages("neuralnet")
library(neuralnet)
nnfit <- neuralnet(Species ~., data=iris[train, ],hidden = 5)
plot(nnfit)
nnpred1<-compute(nnfit, iris[-train,])
nnpred1$net.result
netmatrix <- max.col(as.matrix(nnpred1$net.result))
table(as.numeric(iris[-train,5]), netmatrix)
mean(as.numeric(iris[-train,5])== netmatrix)




###descision tree
library(rpart)
dtfit <- rpart(Species ~., data = iris[train,], method = 'class')

install.packages("rpart.plot")
library(rpart.plot)

rpart.plot(dtfit)
bestcp <- dtfit$cptable[which.min(dtfit$cptable[, 'xerror']),  'CP']
dttune <- prune(dtfit, cp = bestcp)
table(predict(dttune, type = 'class'), iris[train,5])
mean(predict(dttune, type = 'class')== iris[train,5])


##random forest
install.packages("randomForest")
library(randomForest)
rffit <- randomForest(Species ~., data=iris)
table(iris[,5 ], predict(rffit))
mean(iris[,5 ]== predict(rffit))
pred