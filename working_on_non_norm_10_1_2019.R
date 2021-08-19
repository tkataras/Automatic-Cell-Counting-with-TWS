#### trying to get non normaized data to RMA norm instead of quantile
non_norm <- read.csv("./non_norm.csv")
dim(non_norm)
dim(exprl)
dim(na.omit(non_norm))

head(non_norm)
str(non_norm)


non_norm2 <- read.csv("./non_norm2.csv")
head(non_norm2)
test <- data.frame(non_norm2)
head(test)
dim(test)
dim(exprl)

test2 <- test[test[]]



whead <- data.frame(non_norm)

head(whead)
tail(whead)
wheadp <- whead$PROBE_ID
length(wheadp)
tail(wheadp)
t