####KDnuggets neural neteworks in R lession
#install.packages('ISLR')
library(ISLR)

print(head(College,2))

# Create Vector of Column Max and Min Values
maxs <- apply(College[,2:18], 2, max)
mins <- apply(College[,2:18], 2, min)

# Use scale() and convert the resulting matrix to a data frame
scaled.data <- as.data.frame(scale(College[,2:18],center = mins, scale = maxs - mins))

# Check out results
print(head(scaled.data,2))

# Convert Private column from Yes/No to 1/0
Private = as.numeric(College$Private)-1
data = cbind(Private,scaled.data)

## randomly split data into test data and training data with caTools
install.packages("caTools")
library(caTools)
set.seed(101)


# Create Split (any column is fine)
split = sample.split(data$Private, SplitRatio = 0.70)

# Split based off of split Boolean Vector
train = subset(data, split == TRUE)
test = subset(data, split == FALSE)


feats <- names(scaled.data)

# Concatenate strings
f <- paste(feats,collapse=' + ')
f <- paste('Private ~',f)

# Convert to formula
f <- as.formula(f)

f

#install.packages('neuralnet')
library(neuralnet)
nn <- neuralnet(f,train,hidden=c(10,10,10),linear.output=FALSE)

# Compute Predictions off Test Set
predicted.nn.values <- compute(nn,test[2:18])
#str(predicted.nn.values)

# Check out net.result
print(head(predicted.nn.values$net.result))


predicted.nn.values$net.result <- sapply(predicted.nn.values$net.result,round,digits=0)

#creating simple confusion matrix
table(test$Private,predicted.nn.values$net.result)

#visualize neural network
plot(nn)



library("EBImage")
library("OpenImageR")

img1 <- readImage(("C:/Users/User/Desktop/Kaul_lab_work/Cal_Par_counting_9_19/LAV1666s96CalbindinParvalbumin082918cortexF1bs.tif"))
display(img1)
img2<- readImage(("D://LAV 6M Calbindin Parvalbumin/cortex calb/lav1664s96subbg.tif"))
display(img2)

#getting min and max value for scaling
mx <- max(img1)
mn <- min(img1)

#normalizing with EBimage command normalize

img1_nrm <- normalize(img1, separate = T, ft= c(0,1), inputRange = c(mn, mx))
display(img1_nrm)
writeImage(img1_nrm, "LAV1666s96CalbindinParvalbumin082918cortexF1bsnormal.tiff")

img2_nrm <- normalize(img2, separate = T, ft= c(0,1), inputRange = c(mn, mx))
display(img2_nrm)
writeImage(img2_nrm, "LAV1664s96subbgnormal.tiff")

#break normalized image into many sub images
num_sections <- length(img1[1,])/20

for (i in num_sections)

  
img1_nrm_frames = combine( mapply(function(frame, th) frame > th, getFrames(img1_nrm)))


getFrame(img1_nrm,20)
img1_nrm_frames <- combine(lapply(getFrame(img1_nrm,40,type = c('total', 'render'))))

numberOfFrames(img1_nrm_frames, type = c('total', 'render'))

#testing from ebimage site
threshold = otsu(img1_nrm)
nuc_th = combine( mapply(function(frame, th) frame > th, getFrames(img1_nrm), threshold, SIMPLIFY=FALSE) )
display(nuc_th, all=TRUE)
frame_test <- getFrame(img1_nrm, 1)
display(frame_test)


split



#use these sub images as featers in neural network?




#new normalization goal: mean zero and equal variance

img2_nrm2 <- (img2-mean(img2))/(max(img2) - min(img2))
display(img2_nrm2)
writeImage(img2_nrm2, "LAV1664s96subbgnormal2.tiff")
##cant store negative values in tiff????







test <- read.csv("C:/Users/User/Desktop/Kaul_lab_work/Cal_Par_counting_9_19/Results test image.csv")
summary(test$Area)
hist(test$Area)
summary(test$Circ.)
hist(test$Circ.)

scatter.smooth(test$Circ. ~ test$Area)

setwd("C:/Users/User/Downloads/incubator-mxnet-master/")
cd incubator-mxnet
make rpkg
source("git")

git clone --recursive https://github.com/apache/incubator-mxnet.git mxnet
cd mxnet/docs/install



####using img 1 and girdding at 100 micron, wich is 153.85 px
##make vector of all the grid cutoffs
cutoff = seq(1,2048, 154)
i = cutoff
for (i in cutoff){
  
  img1_nrm[i[1]:i[2],i[1]:i[2]]
  
}
test_subset <- img1_nrm[i[1]:i[2],i[1]:i[2]]
display(test_subset)


for (index in c(1:(2048/154))){
  subset
}


mat_split <- function(M, r, c){
  nr <- ceiling(nrow(M)/r)
  nc <- ceiling(ncol(M)/c)
  newM <- matrix(NA, nr*r, nc*c)
  newM[1:nrow(M), 1:ncol(M)] <- M
  
  div_k <- kronecker(matrix(seq_len(nr*nc), nr, byrow = TRUE), matrix(1, r, c))
  matlist <- split(newM, div_k)
  N <- length(matlist)
  mats <- unlist(matlist)
  dim(mats)<-c(r, c, N)
  return(mats)
}

test_matrix <- matrix(nrow = 20, ncol = 20, data = c(1:400))
mat_split(test_matrix, 5,5)
  
####mat_split works, matsplitter(data, row, col)
gridded <- mat_split(img1_nrm, 50, 50)
str(gridded)
display(gridded[,,251])
test_grid_bit <- gridded[,,251]
writeImage(test_grid_bit, 'test_grid_bit.tiff')

test_grid_bit2 <- gridded[,,252]
writeImage(test_grid_bit2, 'test_grid_bit2.tiff')
