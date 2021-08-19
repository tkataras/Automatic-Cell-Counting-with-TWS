input_data="C:/Users/User/Desktop/Kaul_lab_work/IFNAR1_438-S41-GFAP-MAP2-02142018-cortex-10x-F1GFAP Mask Statistics"
input_dataq="C:/Users/User/Desktop/Kaul_lab_work/IFNAR1_438-S41-GFAP-MAP2-02142018-cortex-10x-F1MAP2 Mask Statistics"


#####changing the spaces in file name to _ and adding extension
input_data2 <- gsub('($)', '.txt', input_data, perl = F) 
input_data2q <- gsub('($)', '.txt', input_dataq, perl = F) 

###introduce input data
datain <- read.table(input_data2, sep="\n", header = F, fill = )
head(datain)
dim(datain)
class(datain)
datain[1,1]
datain2 <- read.table(input_data2q, sep="\n", header = F, fill = )

datain <- rbind(datain, datain2)

#####slide, basic pattern can be used to turn other preamble info to a list
slidei <- seq(1,dim(datain)[1],7)
slide <- as.character(NA)
slidej <- 1

for(i in slidei){
  slide[slidej] <- as.character(unlist(datain[i,1]))
  slidej = (slidej+1)}


head(slide)
class(slide)

####image

imagei <- seq(2,dim(datain)[1],7)
image <- as.character(NA)
imagej <- 1
i <-1
for(i in imagei){
  image[imagej] <- as.character(unlist(datain[i,1]))
  imagej = (imagej+1)}


####mask
maski <- seq(3,dim(datain)[1],7)
mask <- as.character(NA)
maskj <- 1

for(i in maski){
  mask[maskj] <- as.character(unlist(datain[i,1]))
  maskj = (maskj+1)}


#####time
timei <- seq(4,dim(datain)[1],7)
time <- as.character(NA)
timej <- 1

for(i in timei){
  time[timej] <- as.character(unlist(datain[i,1]))
  timej = (timej+1)}

#####data
datai <- seq(7,dim(datain)[1],7)
data <- as.character(NA)
dataj <- 1

for(i in datai){
  data[dataj] <- as.character(unlist(datain[i,1]))
  dataj = (dataj+1)}



data_list <- strsplit(data,"\t")

class(data_list)
head(data_list)


data_rows <- 1:length(data_list)

m <- matrix(0, ncol = 30, nrow = 2)
l <- length(data_list[[1]])
data_frame <- matrix(0, ncol=l, nrow = length(time))
  
  
i = 1
for(i in data_rows){data_frame[i,] <- data_list[[i]]}


#####getting row names
char_names <- as.character(datain[6,])
names <- strsplit(char_names,"\t")
colnames(data_frame) <- unlist(names)


######adding back in the preamble info
#final_frame <- matrix(0, ncol = dim(data_frame)[2], nrow = dim(data_frame[1]))

####fixing mask




final_frame2 <- cbind(slide, image, time, mask, data_frame)
final_frame <- as.data.frame(final_frame2)
final_frame$mask
  
  
head(final_frame)
tail(final_frame)


colnames(final_frame)
dim (final_frame)
class(final_frame)


