##INVENTORY_MANAGEMENT

##making the inventory

inputdir_all <-"F:/Theo/iba_7_2020_autocount/working images/substack32_37/all_images_sub_max_project/" #all the images i have, 222
inputdir_all <- dir(inputdir_all)
id1 <- inputdir_all


trim_names <- function(file_names){
  id1 <- file_names
sid1 <- strsplit(id1, " - ")
  
  
newsid1 <- NA
for (i in 1:length(sid1)){
  newsid1 <- c(newsid1, tail(sid1[[i]],1))
}
newsid1 <- newsid1[-1]
}

newsid1 <- trim_names(id1)


#write.csv(newsid1, "F:/Theo/iba_7_2020_autocount/working images/substack32_37/new training/random_quarters/new_male_only_6_24/names.csv")


##filling the inventory from existing folders


###the smaller folder to check

inputdir_val <- "F:/Theo/iba_7_2020_autocount/working images/substack32_37/new training/random_quarters/new_male_only_6_24/validation/"
inputdir_val <- dir(inputdir_val)

newsid2 <- trim_names(inputdir_val)


newsid1_s <- strsplit(x, "-")


##need to have no repeated elements in name before send to squish
squish_slidebook <- function(x, sep = "-"){

  newsid1 <- x
  newsid1_s <- strsplit(newsid1, sep)
  

  #look at what elements you are working with
  head(newsid1_s)
  
  
  
  
  ##parseit takes a list of seperated relevent nam eelements from every image
  parseit <-function(x,object_num){
    newsid1_anum <- NA
    for (i in 1:length(x)){
      newsid1_anum <- c(newsid1_anum, x[[i]][object_num])
    }
    newsid1_anum <- newsid1_anum[-1]
    
  }
    
  newsid1_anum <- parseit(x = newsid1_s, object_num = 2)
  newsid1_snum <- parseit(x = newsid1_s, object_num = 3)
  newsid1_fnum <- parseit(x = newsid1_s, object_num = 8)
  
  fnumsid1_s <- strsplit(newsid1_fnum, "") ####
  
  newsid1_fnum1 <- parseit(x = fnumsid1_s, object_num = 1)
  newsid1_fnum2 <- parseit(x = fnumsid1_s, object_num = 2)
  
  test <- strsplit(newsid1_fnum, "")[][1:2]
  
  listy <- lapply(fnumsid1_s, function (x) x[1:2])
  listless <- lapply(listy, FUN = paste0())
    paste(listy)
  
  #animal num
  newsid1_anum <- NA
  for (i in 1:length(newsid1_s)){
    newsid1_anum <- c(newsid1_anum, newsid1_s[[i]][2])
  }
  newsid1_anum <- newsid1_anum[-1]
  
  
  #slice num
  newsid1_snum <- NA
  for (i in 1:length(newsid1_s)){
    newsid1_snum <- c(newsid1_snum, newsid1_s[[i]][3])
  }
  newsid1_snum <- newsid1_snum[-1]
  
  #field num
  newsid1_fnum <- NA
  for (i in 1:length(newsid1_s)){
    newsid1_fnum <- c(newsid1_fnum, newsid1_s[[i]][8])
  }
  newsid1_fnum <- newsid1_fnum[-1]
  
  fnumsid1_s <- strsplit(newsid1_fnum, ".tif") ######this will change with file extension!!!
  
  newsid1_fnum2 <- NA
  for (i in 1:length(newsid1_s)){
    newsid1_fnum2 <- c(newsid1_fnum2, fnumsid1_s[[i]][1])
  }
  newsid1_fnum2 <- newsid1_fnum2[-1]
  
  
  newsid1_fnum3 <- NA
  for (i in 1:length(newsid1_fnum2)){
    newsid1_fnum3[i] <- substr(newsid1_fnum2[i], start = 1, stop = 2) }
  
  
  
  ####making the data frames-----------
  
  
  id1_df <- cbind(newsid1_anum, newsid1_snum, newsid1_fnum3)
  head(id1_df)
  

 
  ###mashing name together to do matching easily
  
  id1_df_squish <- NA
  for (i in 1:length(sid1)) {
    id1_df_squish[i] <- paste0(id1_df[i,], sep = "_", collapse = "")  
  }
  
  
return(id1_df_squish)
}


id1_df_squish <- squish_slidebook(x = newsid1_s)



id2_df_squish <- squish_slidebook(x = newsid2)


