##the Nom-inator

inputdir1 <-"F:/Theo/iba_7_2020_autocount/working images/substack32_37/all_images_sub_max_project/"

inputdir2 <- "F:/Theo/iba_7_2020_autocount/working images/substack32_37/substack sub max project 32_37 roi/"


outdir <- "F:/Theo/iba_7_2020_autocount/working images/substack32_37/substack sub max project 32_37 images with roi/"
  
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

#match id2 ID# in id1
match_id <- NA
for (i in 1: length(id1_df_squish) ){
pineapple <- grep(id1_df_squish[i],id2_df_squish)
if (sum(pineapple) == 0) {} else match_id[i] <- pineapple
}
match_id <- match_id[complete.cases(match_id)]
length(match_id)


#match id1 ID# in id2. use this to pick subset of matching images out of larger folder to 
match_id <- NA
for (i in 1: length(id2_df_squish) ){
  pineapple <- grep(id2_df_squish[i],id1_df_squish)
  if (sum(pineapple) == 0) {} else match_id[i] <- pineapple
}
match_id <- match_id[complete.cases(match_id)]
length(match_id)


#id2_df_squish[-match_id]
uncounted <- id2[-match_id]
uncounted <- id1[-match_id]


counted <- id1[match_id]

#choose random uncounted file
count_next <- sample(uncounted, 5, replace = F)



### finding out how many total images are wt or gp


wt = c(442, 460, 462,878, 899, 898)
gp = c(426, 428, 443, 306, 307, 319)

wt_imgs <- id1[newsid1_anum %in% wt ]
length(wt_imgs)

gp_imgs <- id1[newsid1_anum %in% gp ]
length(gp_imgs)

head(gp_imgs)

tail(wt_or_gp)

wt_or_gp <-c(wt_imgs,gp_imgs)
length(wt_or_gp)
#copying files
getwd()
setwd(inputdir1)
i = 6

i = 10
head(wt_or_gp)
for (i in 1:length(wt_or_gp)){
  file.copy(wt_or_gp[i], "F:/Theo/iba_7_2020_autocount/working images/substack32_37/all wt and gp images in dataset/")
}
str(wt_or_gp)
file.copy()

###geting 13 images in total wt,gp but NOT previously counted at all
newsid1 

##finding the counted ones in the bigger set


match_id <- NA
for (i in 1: length(newsid2) ){
  pineapple <- grep(newsid2[i],newsid1)
  if (sum(pineapple) == 0) {} else match_id[i] <- pineapple
}
match_id <- match_id[complete.cases(match_id)]
length(match_id)

not_counted <- id1[-match_id]
length(not_counted)
length(newsid1)

##13 uncounted images, the first 3 will go to validation, the next 10 to training
lucky13 <- sample(not_counted, 13, replace = F)

getwd()

for (i in 1:length(lucky13)){
  file.copy(lucky13[i], "F:/Theo/iba_7_2020_autocount/working images/substack32_37/holdig/")
}



# copy the files to the new folder
setwd(inputdir1)
getwd()

##this should copy all files in both folders to outdir
for (i in 1:length(counted)){
file.copy(counted[i], outdir)
}

# 
# library(utils)
# answer<-winDialog("yesno", "was the suggestion useful?")
# if (answer=='YES') {print('good!')} else {print('sorry')}
# 

###just wt adn gp


#animal numbers for wt and gp, wt: 442, 460, 462;878, 899, 898
#gp: 426, 428, 443; 306, 307, 319


wt = c(442, 460, 462,878, 899, 898)
gp = c(426, 428, 443, 306, 307, 319)

#gives me the files in d2 that werent in d1
holding <- id2_df_squish[-match_id]

#restricts that to only wt and gp120 files
#holding2 <- holding[newsid2_anum %in% wt | newsid2_anum %in% gp  ]
#length(holding2)




#pick 20, first 10 for training, next 10 for validation. going to randomly quarter the images
hold3 <- sample(holding2, 20, replace = F)

hold3_t <- hold3[1:10]
hold3_v <- hold3[11:20]

match_id2 <- NA
for (i in 1: length(hold3_v) ){
  match_id2[i] <- grep(hold3_t[i],id2_df_squish)
}


inputdir3 <- "F:/Theo/iba_7_2020_autocount/working images/substack32_37/all_images_sub_max_project/"

dir3files <- dir(inputdir3)
outdir2 <- "F:/Theo/iba_7_2020_autocount/working images/substack32_37/validation/"
setwd("F:/Theo/iba_7_2020_autocount/working images/substack32_37/all_images_sub_max_project/")
for (i in match_id2){
  file.copy(dir3files[i], outdir2)
}
