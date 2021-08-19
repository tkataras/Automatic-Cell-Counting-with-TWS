SBout <- function(input_data="C:/Users/User/Desktop/Kaul_lab_work/L2H 1689_MAP2+GFAP_s50_F1cortex Mask Statistics", outfile_name = "output_5_10", out_loc = "C:/Users/User/Desktop/Kaul_lab_work/", nrow = 7){
                  #input_dataq="C:/Users/User/Desktop/Kaul_lab_work/IFNAR1_438-S41-GFAP-MAP2-02142018-cortex-10x-F1MAP2 Mask Statistics", \
                  #"C:/Users/User/Desktop/Kaul_lab_work/IFNAR1_438-S41-GFAP-MAP2-02142018-cortex-10x-F1GFAP Mask Statistics"
  
  #if(length(inputdata > 1)){}
  
  #input_data= c("C:/Users/User/Desktop/Kaul_lab_work/IFNAR1_438-S41-GFAP-MAP2-02142018-cortex-10x-F1GFAP Mask Statistics","C:/Users/User/Desktop/Kaul_lab_work/IFNAR1_438-S41-GFAP-MAP2-02142018-cortex-10x-F1MAP2 Mask Statistics")
  
  #####changing the spaces in file name to _ and adding extension
  input_data2 <- gsub('($)', '.txt', input_data, perl = F) 
  #input_data2q <- gsub('($)', '.txt', input_dataq, perl = F) 
  
  ###introduce input data
  
  datain <- read.table(input_data2, sep="\n", header = F, fill = )
  #datain2 <- read.table(input_data2q, sep="\n", header = F, fill = )
  #datain3 <- rbind(datain, datain2)
  #datain <- datain3
  
  

  
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
  
  
  #################### splitting the image name into usable variables
  test <- gsub(" ", "_",image)
  
  test <- strsplit(image, split = "_")
  
  holder <- NA
  for(i in 1:length(test)){holder[i] <- length(unlist(test[i]))};mx <-max(holder) #finds longest name once broken down(longest length = mx)
  
  mt <- matrix(0, ncol=mx, nrow=length(test))#initializes matrix for storing name info
  
  
  for(i in 1:length(test)){mt[i,] <- unlist(test[i])}
  class(mt[1,1])
  
  unique(mt[,1]) # gets the unique image identifiers !!!can compare characters!!!
  unique(mt[,2])
  unique(mt[,3])
  unique(mt[,4])
  
  i = 1
  j = 1
  ctrlr <- NA
  for(i in 1:length(unique(final_frame$X1))){
  for(j in 1:length(final_frame$rn)){
  ctrlr[j] <- final_frame$rn[final_frame$X1 == unique(final_frame$X1)[i]]
  
  }}
  
  
  final_frame$Sum.Intensity..ADU...ch1.DAPI/final_frame$Area..microns².[final_frame$] 
  
  ctrl_rn <-final_frame$rn
  
  where final_frame$X2 == unique(final_frame$X2)[length(unique(final_frame$X2))] 
  
  
  i =1
  ctrl_rn <- NA
  for (i in 1:length(final_frame$rn)){ctrl_rn[i] <- final_frame$rn[final_frame$X1 == final_frame$X1[i] && final_frame$X2 == levels(final_frame$X2)[grep("ctrl", levels(final_frame$X2))]]}#### NEED REGULAR CTRL NAMES!!!!!!!!!!!!!
  
  ctrl <- levels(final_frame$X2)[grep("ctrl", levels(final_frame$X2))] #will always select the unique name including "ctrl"
  
  final_frame$rn[final_frame$X1 == final_frame$X1[i] && final_frame$X2 == "2nd ctrl"]
  
  #########################################################################################################################
  ------------------------------------------------------------------------------------------------------------------
#This takes a value from the ctrl rows and avgs it for all ctrl rows on single slide so it can be applied to correct rows via slide ID
      #install.packages("dplyr")
  library(dplyr)
newdata <- final_frame %>%
    filter(final_frame$X2 == ctrl) %>%
    group_by(X1) %>%
    transmute(means = mean(Area..microns².)) %>%
    as.data.frame()

uniquemeans = data.frame(unique(newdata$means), unique(newdata$X1))
names(uniquemeans) = c('means', 'X1')
  newerdata = final_frame %>%
    full_join(uniquemeans)
  
  DAPI_AN <- final_frame$Sum.Intensity..ADU...ch1.DAPI/newerdata$means
  ################################################################################################################################
  ---------------------------------------------------------------------------------------------------------------------------------
  
  unlist(test[1])
  
  rbind(test[1], test[2])
  
  length(unlist(test[1]))
  
  test2 <-strsplit(test, "_")
  l <-length(test2[[1]])
  data_frame2 <- matrix(NA, ncol=l+1, nrow = length(time))
  i=16
  for(i in 1:length(image)){
    for(j in 1:length(test2[[i]])){
    data_frame2[i,j] <- test2[[i]][j]}} ###trying to deal with not all rows being same length
  
  
  length(test2[[1]])

    strsplit(data_frameb[,2], " ")
  
  
  
  
  
  
  test2 <- strsplit(unlist(test), split = " ")
  test3 <- strsplit(unlist(test2), split = "_")
  
  test3 <-apply(unlist(test2)[2] test2[[]]
  
  testc <- data.frame()   
  
  
  l <- length([[test3]])
  testc <- matrix(0, ncol=l, nrow = length(time)) #initializes data from to be filled with data more quickly
  
  for(i in 1:length(image)){testc[i] <-strsplit(image[i], split = ":")}
  
                
  l <- length(data_list[[1]])
 data_frame <- matrix(0, ncol=l, nrow = length(time)) #initializes data from to be filled with data more quickly
                
                


                
                
                
                
                
                
                
                

                
  
  final_frame <- data.frame(rn, slide, mt, time, mask, data_frame_n)
  
  
  
  colnames(final_frame[(ncol(final_frame)-ncol(data_frame)):ncol(final_frame)]) <- unlist(names) #explicitly sets names for the data section of final data frame
  
  
  #######ANALYSIS
  
  ##normalization
  
  #making a new col for control values
  
  all_Ctl_rn <- c(grep("*Ctl*",final_frame$image, ignore.case = T)) #specifies control rows by presence of "ctl"
  all_Ctl <-data.frame(final_frame[all_Ctl_rn,])
  
  
  #ctrl <- NA
  #ctrli <- seq(1:(length(data)))
  #ctrlj <- 1
  
  #for(i in ctrli){
   # if (final_frame$rn[i] <= (all_Ctl$rn[ctrlj])+1){ctrl[i] <- all_Ctl[ctrlj,1] ##this specifies the row numbers of the related control row for each row
    #}else{ctrlj <- ctrlj+1 ; ctrl[i] <- all_Ctl[ctrlj,1]}
  #}
  
  
  ##############making new col for all igg values
  all_igg_rn <- c(grep("*IgG*",final_frame$image, ignore.case = T))
  all_igg <- data.frame(final_frame[all_igg_rn,])
  
  #igg <- NA
  #iggi <- seq(1:(length(data)))
  #iggj <- 1
  
  #for(i in iggi){
   # if (final_frame$rn[i] <= (all_igg$rn[iggj])){igg[i] <- all_igg[iggj,1] ##this specifies the row numbers of the related control row for each row
  #  }else{iggj <- iggj+1 ; igg[i] <- all_igg[iggj,1]}
  #}
  
  
  ## area normalization and other calculations
  DAPI_AN <- final_frame$Sum.Intensity..ADU...ch1.DAPI/final_frame$Area..microns².
  FITC_AN <- final_frame$Sum.Intensity..ADU...ch1.FITC/final_frame$Area..microns².
  
  final_frame_c <- data.frame(ctrl, final_frame,DAPI_AN,FITC_AN)
  
  FITC_Nsec <- (final_frame_c$FITC_AN - final_frame_c$FITC_AN[final_frame_c$ctrl])
  
  
  FITC_DAPI_Normalized <- (FITC_Nsec/DAPI_AN)######need to add this for GFAP, THE ONES FOR MAP2 are diff???
  
  CY3_AN <- final_frame$Sum.Intensity..ADU...ch1.CY3/final_frame$Area..microns². 
  final_frame_c <- data.frame(final_frame_c,CY3_AN)
  CY3_Nsec <- (final_frame_c$CY3_AN - final_frame_c$CY3_AN[final_frame_c$ctrl])
  CY3_DAPI_Normalized <- (CY3_Nsec/DAPI_AN)
  DAPI_Marcus <- CY3_AN/DAPI_AN #CY3 Area norm div by DAPI Area norm
  final_frame_c <- data.frame(final_frame_c,DAPI_Marcus)
  Nor_sec_Marcus <- (final_frame_c$DAPI_Marcus - final_frame_c$DAPI_Marcus[final_frame_c$ctrl]) #the ctrl normalized version of DAPI Marcus 
  
  final_frame_c <- data.frame(final_frame_c,FITC_Nsec, FITC_DAPI_Normalized, CY3_AN, CY3_Nsec, CY3_DAPI_Normalized, DAPI_Marcus, Nor_sec_Marcus)
  
  
  final_frame_noctrl <- final_frame_c[final_frame_c$rn != final_frame_c$ctrl & final_frame_c$rn != (final_frame_c$ctrl +1), ] ####cuts out the ctrl lines and the IGG lines after them
  final_frame_ctrl <- 
  
  summary(final_frame_noctrl)
  
  
  infile_name <- unlist(strsplit(input_data, "/"))
  outfile_name_final <- paste(infile_name[length(infile_name)],outfile_name, sep = "_")
  
  
  write.csv(final_frame_noctrl, paste(out_loc,outfile_name_final, sep = ""))
  
  
  
}







