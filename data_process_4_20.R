data.process <- function(input_data="C:/Users/User/Desktop/Kaul_lab_work/IFNAR1_438-S41-GFAP-MAP2-02142018-cortex-10x-F1GFAP Mask Statistics", num_slides=,  sav.loc="./"){
  


###### ERROR CHECK, adding "/"
if(!is.character(sav.loc)) stop("sav.loc must be a character string")
split.string = unlist(strsplit(sav.loc,""))
l = length(split.string)
lastchar = split.string[l]
if(lastchar!="/") input_data = paste0(sav.loc,"/")

##### DATA MANIP, making sure input has "/" and creating outfile name based on the infile name
# input_data file should be the "****_allValidPairs"
inputlist = strsplit(input_data,"/") 
inputsplit = inputlist[[1]] # could use unlist command
l = length(inputsplit)
outfile_name = paste0(inputsplit[l],"_processed",chr_want) ###advisable to add date
######

#####changing the spaces in file name to _ and adding extension
 
input_data2 <- gsub('($)', '.txt', input_data, perl = F) 

###introduce input data
datain <- read.table(input_data2, sep="\n", header = F, fill = )




read.table(textConnection(gsub(",", "\t", readLines(input_data2))), fill = T)
out1b <- read.table(text = gsub(",", "\t", readLines(input_data2)), fill=TRUE)


head(out1b, 25)
head(datain, 25)

data1 <- datain[1:7,]

x <- datain[6,]
y <- datain[7,]
unlist(x)
grep("*e*",x2)

class(x2)

x2 <- as.character(x)
y2 <- as.character(y)

x3 <- strsplit(x2,"\t")
y3 <- strsplit(y2,"\t")
x4 <- unlist(x3)
y4 <- unlist(y3)


length(x4)
length(y4)

new_data <- as.data.frame(rbind(x4,y4))
new_data[,5]
dim(new_data)
class(new_data)

new_data2 <- gsub("\\s","_", new_data[1,], ignore.case = T)
length(new_data2)


lengthi <- c(1:length(new_data[1,]))
for(i in lengthi){
  new_data2[i] <- gsub("\\s","_", new_data[1,i], ignore.case = T)
  
}

new_data3 <-new_data[2,]
colnames(new_data3) <- new_data2



new_data3








test <- readLines()
data2 <- gsub('\t',';',data1[6])
data3 <- strsplit(data[6],split=";")
dim(data)


row_index <- 1
row_cutoff <- 8
length_datain <-length(datain)
for(row_index in length_datain){
  while row_index < row_cutoff
    
  else  row_cutoff <- row_cutoff + 7 
  
}


}






