##the nomomancer


inputdir1 <-"F:/Theo/iba_7_2020_autocount/working images/Theo_hand_count_11_2020/"
inputdir2 <- "F:/Theo/iba_7_2020_autocount/working images/single_image_backup/"
  
id1 <- dir(inputdir1)
id2 <- dir(inputdir2)
#head(id2)

sid1 <- strsplit(id1, " - ")

#first directory-----------


newsid1 <- NA
for (i in 1:length(sid1)){
  newsid1 <- c(newsid1, tail(sid1[[i]],1))
}
newsid1 <- newsid1[-1]

##second dir
sid2 <- strsplit(id2, " - ")


newsid2 <- NA
for (i in 1:length(sid2)){
  newsid2 <- c(newsid2, tail(sid2[[i]],1))
}
newsid2 <- newsid2[-1]


###now need to trim the entries
newsid1_s <- strsplit(newsid1, "-")
#head(newsid1_s)




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




####now for the second dir #########################################---------




###now need to trim the entries
newsid2_s <- strsplit(newsid2, "-")
#head(newsid2_s)



#animal num
newsid2_anum <- NA
for (i in 1:length(newsid2_s)){
  newsid2_anum <- c(newsid2_anum, newsid2_s[[i]][2])
}
newsid2_anum <- newsid2_anum[-1]
length(newsid2_anum)

#slice num
newsid2_snum <- NA
for (i in 1:length(newsid2_s)){
  newsid2_snum <- c(newsid2_snum, newsid2_s[[i]][3])
}
newsid2_snum <- newsid2_snum[-1]


#field num
newsid2_fnum <- NA
for (i in 1:length(newsid2_s)){
  newsid2_fnum <- c(newsid2_fnum, newsid2_s[[i]][8])
}
newsid2_fnum <- newsid2_fnum[-1]
length(newsid2_fnum)

newsid2_fnum


fnumsid2_s <- strsplit(newsid2_fnum, ".tif")

newsid2_fnum2 <- NA
for (i in 1:length(newsid2_s)){
  newsid2_fnum2 <- c(newsid2_fnum2, fnumsid2_s[[i]][1])
}
newsid2_fnum2 <- newsid2_fnum2[-1]

newsid2_fnum3 <- NA
for (i in 1:length(newsid2_fnum2)){
  newsid2_fnum3[i] <- substr(newsid2_fnum2[i], start = 1, stop = 2) }
newsid2_fnum3

####making the data frames-----------


id1_df <- cbind(newsid1_anum, newsid1_snum, newsid1_fnum3)
head(id1_df)

id2_df <- cbind(newsid2_anum, newsid2_snum, newsid2_fnum3)
head(id2_df)


###mashing name together to do matching easily

id1_df_squish <- NA
for (i in 1:length(sid1)) {
  id1_df_squish[i] <- paste0(id1_df[i,], sep = "_", collapse = "")  
}


id2_df_squish <- NA
for (i in 1:length(sid2)) {
  id2_df_squish[i] <- paste0(id2_df[i,], sep = "_", collapse = "")  
}



#now i can compare the lists
#give me sum of equal files

length(id1_df_squish)
length(id2_df_squish)
(id1_df_squish == id2_df_squish)

agrep(id1_df_squish,id2_df_squish)



# 
# library(utils)
# answer<-winDialog("yesno", "was the suggestion useful?")
# if (answer=='YES') {print('good!')} else {print('sorry')}
# 



