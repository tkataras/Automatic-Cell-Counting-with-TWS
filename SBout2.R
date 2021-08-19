SBout2 <- function(input_data="C:/Users/User/Desktop/Kaul_lab_work/daniel_12_7/Neuropil Mask Statistics Females.txt", outfile_name = "output_5_24_sort", out_loc = "C:/Users/User/Desktop/Kaul_lab_work/5_24"){
  
input_data2 <- gsub('($)', '.txt', input_data, perl = F) 
  
  datain <- read.table(input_data2, sep="\n", header = F, fill = )
  
  nrow = 7
  
  #####slide, basic pattern can be used to turn other preamble info to a list
  slidei <- seq(1,dim(datain)[1],nrow) # makes i a sequence w/ length of whole data set, interval of nrow(ex. 7), starting at first row
  slide <- as.character(NA) #initializes the variable that will hold all slide values
  slidej <- 1 #allows new data to be added sequentially
  
  for(i in slidei){
    slide[slidej] <- as.character(unlist(datain[i,1]))
    slidej = (slidej+1)}
  
  
  
  ####image
  
  imagei <- seq(2,dim(datain)[1],nrow)
  image <- as.character(NA)
  imagej <- 1
  i <-1
  for(i in imagei){
    image[imagej] <- as.character(unlist(datain[i,1]))
    imagej = (imagej+1)}
  
  
  ####mask
  maski <- seq(3,dim(datain)[1],nrow)
  mask <- as.character(NA)
  maskj <- 1
  
  for(i in maski){
    mask[maskj] <- as.character(unlist(datain[i,1]))
    maskj = (maskj+1)}
  
  
  #####time
  timei <- seq(4,dim(datain)[1],nrow)
  time <- as.character(NA)
  timej <- 1
  
  for(i in timei){
    time[timej] <- as.character(unlist(datain[i,1]))
    timej = (timej+1)}
  
  #####data
  datai <- seq(7,dim(datain)[1],nrow)
  data <- as.character(NA)
  dataj <- 1
  
  for(i in datai){
    data[dataj] <- as.character(unlist(datain[i,1]))
    dataj = (dataj+1)}
  
  
  
  data_list <- strsplit(data,"\t") #seperates long row of data
  
  data_cols <- 1:length(data_list) #determines length of row of data
  
  
  l <- length(data_list[[1]])
  data_frame <- matrix(0, ncol=l, nrow = length(time)) #initializes data from to be filled with data more quickly
  
  
  i=1
  for(i in data_cols){data_frame[i,] <- data_list[[i]]}
  
  
  data_frame_n<-apply(data_frame, MARGIN = 2, as.numeric) ###making data frame values numbers instead of factors/char (margin = 2 means column, 1=row)
  
  
  
  
  #####getting column names
  char_names <- as.character(datain[nrow - 1,])
  names <- strsplit(char_names,"\t")
  colnames(data_frame_n) <- unlist(names)
  
  
  ######adding back in the preamble info
  #final_frame <- matrix(0, ncol = dim(data_frame)[2], nrow = dim(data_frame[1]))
  
  ##making explicit row number(somthing i may have to move to start of fcn)
  rn <- as.numeric(unlist(c(1:length(time))))
  
  
  final_frame <- data.frame(rn, slide, image, time, mask, data_frame_n)
  
  
  
  colnames(final_frame[(ncol(final_frame)-ncol(data_frame)):ncol(final_frame)]) <- unlist(names) #explicitly sets names for the data section of final data frame
  
  
  all_Ctl_rn <- c(grep("*Ctrl*",final_frame$image, ignore.case = T)) #specifies control rows by presence of "ctl"
  
  all_Ctl <-data.frame(final_frame[all_Ctl_rn,])
  
  
  all_igg_rn <- c(grep("*IgG*",final_frame$image, ignore.case = T))
  all_igg <- data.frame(final_frame[all_igg_rn,])
  
  #final_frame_only_slides <- final_frame[final_frame$rn != all_Ctl_rn & final_frame$rn != all_igg_rn,]

  
  final_frame_only_slidesa <- final_frame[ !(final_frame$rn %in% all_Ctl_rn),]
  final_frame_only_slides <- final_frame_only_slidesa[ !(final_frame_only_slidesa$rn %in% all_igg_rn),]

  
  final_frame_out <- rbind(final_frame_only_slides, all_Ctl, all_igg)
  
  infile_name <- unlist(strsplit(input_data, "/"))
  outfile_name_final <- paste(infile_name[length(infile_name)],outfile_name, sep = "_")
  
  write.csv(final_frame_out, paste(out_loc,outfile_name_final, sep = ""))
  
  
  
}


  