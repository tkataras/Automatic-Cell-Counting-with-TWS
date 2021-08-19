##INVENTORY_MANAGEMENT

##making the inventory

inputdir_all <-"F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/automatic_segmentation/run_1/counted_images/counted_projected_min_size_20_wt_gp/" #all the wt and gp images i have, 100
inputdir_all <- dir(inputdir_all)
id1 <- inputdir_all
in_d1 <- "F:/Theo/iba_7_2020_autocount/working images/substack32_37/all wt and gp images in dataset/"

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

# 
# inputdir_wtgp <-"F:/Theo/iba_7_2020_autocount/working images/substack32_37/all wt and gp images in dataset/" #all the images i have, 222
# inputdir_wtgp <- dir(inputdir_wtgp)
# wtgp_names <- trim_names(inputdir_wtgp)
# wtgp_sep <- sep_slidebook(wtgp_names)
# wtgp_squish <- squish(wtgp_sep)
# duplicated(wtgp_squish)

#write.csv(newsid1, "F:/Theo/iba_7_2020_autocount/working images/substack32_37/new training/random_quarters/new_male_only_6_24/names.csv")


##filling the inventory from existing folders




##need to have no repeated elements in name before send to squish
sep_slidebook <- function(x, sep = "-"){

  newsid1 <- x
  newsid1_s <- strsplit(newsid1, sep)
  

  #look at what elements you are working with
  head(newsid1_s,3)
  
  max_l <- length(newsid1_s[[1]])
  
  
  
  ##parseit takes a list of seperated relevent nam eelements from every image
  parseit <-function(x,object_num){
    newsid1_anum <- NA
    for (i in 1:length(x)){
      newsid1_anum <- c(newsid1_anum, x[[i]][object_num])
    }
    newsid1_anum <- newsid1_anum[-1]
    
  }
    ###these are what you need to adjust for different names of images!!!!####
  newsid1_anum <- parseit(x = newsid1_s, object_num = 2)
  newsid1_snum <- parseit(x = newsid1_s, object_num = 3)
  newsid1_fnum <- parseit(x = newsid1_s, object_num = max_l)
  
  fnumsid1_s <- strsplit(newsid1_fnum, "") #### sometimes another seperation step is required
 
  
  
  newsid1_fnum1 <- parseit(x = fnumsid1_s, object_num = 1)
  newsid1_fnum2 <- parseit(x = fnumsid1_s, object_num = 2)
  newsid1_fnum3 <- paste(newsid1_fnum1,newsid1_fnum2, sep = "") # for clarity, seperated objects can be recombined in order with paste()
  
  
  
  ####making the data frames-----------
  
  
  id1_df <- cbind(newsid1_anum, newsid1_snum, newsid1_fnum3)
  head(id1_df)
  

 

  
#return(id1_df_squish)
return(id1_df)
}


id1_df_sep <- sep_slidebook(x = newsid1)
head(id1_df_sep)
###mashing name together to do matching easily

squish <- function(input_df){

id1_df_squish <- NA
for (i in 1:dim(input_df)[1]) {
  id1_df_squish[i] <- paste0(input_df[i,], sep = "_", collapse = "")  
}
return(id1_df_squish)
}##simple function to combine rows of the df with info

id1_df_squish <- squish(input_df = id1_df_sep)


big_df <- cbind(inputdir_all, id1_df_squish,id1_df_sep) ##specify: original file names, info columns, squished ID
colnames(big_df) <- c("file_name", "img_ID", "a_num","S_num", "F_num")
big_df <- data.frame(big_df)

###for this to work, inventory should be unique,  this is a chance to find and manually fix file naming errors
sum(duplicated(id1_df_squish))

length(unique(id1_df_squish))

####NEED TO ADJUST FOR MESSY NAMES from the old training on paired images
big_df$img_ID
for (i in 1:length(big_df$img_ID)){
holding <- big_df$img_ID[i]
hold2 <- strsplit(holding, split = "")
hold3 <- hold2[[1]][9:length(hold2[[1]])]
hold4 <- paste(hold3, sep = "", collapse = "")
big_df$img_ID_clean[i] <- hold4
}


# dups <- id1_df_squish[duplicated(id1_df_squish)]
# 
# 
# ##i think will need to set requirement to just hav eno dups in full experimental inventory. will write code to show which files are duplicates****
# 
# ####add duplicate into to the squish ID
# new_id1_df_squish <- id1_df_squish
# i = 3
# for (i in 1:length(dups)){
#   id_num <- grep(dups[i], id1_df_squish)
#   
#   counter <- 0
#   for (j in 1:length(id_num)){
#     
#     counter <- counter +1
#     obj_num <- id_num[j]
#     new_id1_df_squish[obj_num] <- paste(id1_df_squish[obj_num],counter, sep = "")
#   }
#   
# }
# 


###the smaller folder to check

inputdir_val <- "F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/working_images/roi_after_Npt3/"
inputdir_val <- dir(inputdir_val)


newsid2 <- trim_names(inputdir_val)

id2_df_sep <- sep_slidebook(x = newsid2)
id2_df_squish <- squish(input_df = id2_df_sep)

#finding matches bewteen the full image roster and the validation image folder

##look for files in id2 in id1, print line numbers in id1
get_match_id <- function(sub_inv,full_inv){
match_id <- NA
for (i in 1: length(sub_inv) ){
  pineapple <- grep(sub_inv[i],full_inv)
  if (sum(pineapple) == 0) {print("not found")} else match_id[i] <- pineapple
}
match_id <- match_id[complete.cases(match_id)]
}

match_id <- get_match_id(id2_df_squish,id1_df_squish)
length(match_id)

id1[-match_id]

meep <- na.omit(id1_df_squish[match_id])
length(id1)
dim(big_df)
big_df_hcount <- data.frame(big_df[match_id,])
dim(big_df)
dim(big_df_hcount)


wtn = c(442, 460, 462,878, 899, 898)
gpn = c(426, 428, 443, 306, 307, 319)
bothn <- c(wtn, gpn)
m_imgs_wt_gp <- big_df_hcount[big_df_hcount$a_num %in% bothn, ]
dim(m_imgs_wt_gp)

##m_imgs_wt_gp is all counted images by Hina
inputdir_mecount <- "F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/working_images/roi_after_Npt3/"
inputdir_mecount <- dir(inputdir_mecount)

newsid_me <- trim_names(inputdir_mecount)
idme_df_sep <- sep_slidebook(x = newsid_me)
idme_df_squish <- squish(input_df = idme_df_sep)

length(idme_df_squish)
both_counted <- get_match_id(idme_df_squish,m_imgs_wt_gp$img_ID)

#what did hina count that i didnt??? should be 2
missing_counts <- m_imgs_wt_gp[-both_counted,]
#428 s42 F4, and 428 s57 F1

id2_df_sep_df <- data.frame(id2_df_sep)

wt_counted <- id2_df_sep_df[id2_df_sep_df$newsid1_anum %in% wtn,]
dim(wt_counted)
gp_counted <- id2_df_sep_df[id2_df_sep_df$newsid1_anum %in% gpn,]
dim(gp_counted)
rbind(wt_counted,gp_counted)


wt_counted <- id2_df_sep_df[id2_df_sep_df$newsid1_anum %in% wtn,]


newsid2


dim(m_imgs_wt_gp)
dim(big_df_hcount[big_df_hcount$a_num %in% wtn, ])
write.csv(big_df_hcount, "F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/working_images/counted_images_wt_gp_7_12_2021.csv")
#making use variable

use <- rep(NA,length(id1))


assign <- function(use,match_id, how){
for (i in match_id){
  if (is.na(use[i])){use[i] = how}
  else{print(paste( id1[i] , "already used as", use[i],"!!!"))}
}
return(use)
}


new_use<- assign(use,match_id = match_id, how = "v")

#so the process is: trim, sep, squish, get_match_id, assign

##inputdir train
inputdir_train <- "F:/Theo/iba_7_2020_autocount/working images/substack32_37/new training/random_quarters/new_male_only_6_24/training/"
inputdir_train <- dir(inputdir_train)


newsid2 <- trim_names(inputdir_train)
id2_df_sep <- sep_slidebook(x = newsid2)
id2_df_squish <- squish(input_df = id2_df_sep)
match_id2 <- get_match_id(id2_df_squish,id1_df_squish) ##got a "not mult of replacement length message

newst_use <- assign(new_use,match_id2, how = "t")


##unused files

unused <- id1[is.na(newst_use)]
length(unused)


write.csv(big_df,"F:/Theo/iba_7_2020_autocount/working images/substack32_37/new training/random_quarters/new_male_only_6_24/big_df_7_8_2021.csv")

new_big_df <- read.csv("F:/Theo/iba_7_2020_autocount/working images/substack32_37/new training/random_quarters/new_male_only_6_24/big_df_7_8_2021.csv")
newest_big_df <- cbind(new_big_df[1:53,],newst_use[1:53]) ###getting only the males
names(newest_big_df)[7] <- "newst_use"
# newest_big_df_m <- newest_big_df[newest_big_df$sex == "m",]
# dim(newest_big_df_m)

unused <- newest_big_df[is.na(newest_big_df$newst_use),]
dim(unused)



##marking remaining unsuitable images
sample(unused$file_name,1)


#newest_big_df[newest_big_df$a_num == "428" && newest_big_df$S_num == "S72",]

file_names_df = newest_big_df
num = 3
factor = "wt"
out_loc = "F:/Theo/iba_7_2020_autocount/working images/substack32_37/new training/random_quarters/new_male_only_6_24/holder_folder/"
how = "h"
in_dir 

sample_it <- function(file_names_df,num,factor, out_loc,how, in_dir){
  
  #getting a subset of the big df that is only the factor in question(eg. genotype) AND unused as of the current newst_use variable on the df
  sample_from <- file_names_df[file_names_df$geno == factor & is.na(file_names_df$newst_use),]
  
  out <- sample_from[sample(nrow(sample_from), num), ]
  ##copy the files
  for (i in 1:length(out)){
    file.copy(paste(in_dir,out$file_name[i],sep = ""), out_loc)
  }
  ###update the use variable
  
  matches <- get_match_id(out$img_ID,file_names_df$img_ID)
  newest_use <- assign(file_names_df$newst_use,matches,how)
}
# ### when adding to existing folders, new files can be identified by the time of creation listed in windows explorer etc.
# most_new_use <- sample_it(newest_big_df,3,"wt","F:/Theo/iba_7_2020_autocount/working images/substack32_37/new training/random_quarters/new_male_only_6_24/training/","t", in_d1 )
# newest_big_df$newst_use <- most_new_use
# most_new_use <- sample_it(newest_big_df,3,"gp","F:/Theo/iba_7_2020_autocount/working images/substack32_37/new training/random_quarters/new_male_only_6_24/training/","t", in_d1 )
# newest_big_df$newst_use <- most_new_use
# most_new_use <- sample_it(newest_big_df,2,"wt","F:/Theo/iba_7_2020_autocount/working images/substack32_37/new training/random_quarters/new_male_only_6_24/validation/","t", in_d1 )
# newest_big_df$newst_use <- most_new_use
# most_new_use <- sample_it(newest_big_df,2,"gp","F:/Theo/iba_7_2020_autocount/working images/substack32_37/new training/random_quarters/new_male_only_6_24/validation/","t", in_d1 )
# newest_big_df$newst_use <- most_new_use
# most_new_use <- sample_it(newest_big_df,2,"gp","F:/Theo/iba_7_2020_autocount/working images/substack32_37/new training/random_quarters/new_male_only_6_24/images/","full_data", in_d1 )
# newest_big_df$newst_use <- most_new_use
# 
# write.csv(newest_big_df, "F:/Theo/iba_7_2020_autocount/working images/substack32_37/big_df_6_30_11am_only_males.csv")


#inputdir ful data
inputdir_full <- "F:/Theo/iba_7_2020_autocount/working images/substack32_37/new training/random_quarters/new_male_only_6_24/images/"
inputdir_full <- dir(inputdir_full)


newsid2 <- trim_names(inputdir_full)
id2_df_sep <- sep_slidebook(x = newsid2)
id2_df_squish <- squish(input_df = id2_df_sep)
match_id2 <- get_match_id(id2_df_squish,id1_df_squish) ##got a "not mult of replacement length message

newst_use <- assign(newst_use,match_id2, how = "full_data")

b <- newest_big_df[is.na(newest_big_df$newst_use) & newest_big_df$geno == "wt",]
dim(b)
sample(1:20,1)
b[11,]

c <- newest_big_df[is.na(newest_big_df$newst_use) & newest_big_df$geno == "gp",]
dim(c)
sample(1:15,1)
c[c(6,3,15),]
c[1,]

##looking for duplicates between images, training and validation
inputdir_full <- "F:/Theo/iba_7_2020_autocount/working images/substack32_37/new training/random_quarters/new_male_only_6_24/images/"
inputdir_full <- dir(inputdir_full)
inputdir_t <- "F:/Theo/iba_7_2020_autocount/working images/substack32_37/new training/random_quarters/new_male_only_6_24/training/"
inputdir_t <- dir(inputdir_t)
inputdir_v <- "F:/Theo/iba_7_2020_autocount/working images/substack32_37/new training/random_quarters/new_male_only_6_24/validation/"
inputdir_v <- dir(inputdir_v)
all_files <-c(inputdir_full,inputdir_t,inputdir_v)
trimmed <- trim_names(all_files)

seped <- sep_slidebook(x = trimmed)
squished <- squish(input_df = seped)
squished
sum(duplicated(squished))
squished[duplicated(squished)]

m_ID <- get_match_id(squished,newest_big_df$img_ID) ##got a "not mult of replacement length message

can_u <- newest_big_df[-m_ID,]
dim(can_u) ## is 20
can_u_gp <- can_u[can_u$geno == "gp",]
dim(can_u_gp)
sample(1:7,2)
can_u_gp[c(4,2),]
sample(1:7,1)
can_u_gp[c(5),]
can_u_wt <- can_u[can_u$geno == "wt",]
dim(can_u_wt)
sample(1:13,1)
can_u_wt[5,]


imgs <- "F:/Theo/iba_7_2020_autocount/working images/substack32_37/new training/random_quarters/new_male_only_6_24/validation//"
imgs <- dir(imgs)


newsid2 <- trim_names(imgs)
id2_df_sep <- sep_slidebook(x = newsid2)
imgs_squish <- squish(input_df = id2_df_sep)



roi <- "F:/Theo/iba_7_2020_autocount/working images/substack32_37/new training/random_quarters/new_male_only_6_24/validation_roi/"
roi <- dir(roi)

newsid2 <- trim_names(roi)
id2_df_sep <- sep_slidebook(x = newsid2)
roi_squish <- squish(input_df = id2_df_sep)



match_id_img_roi <- get_match_id(roi_squish,imgs_squish) ##got a "not mult of replacement length message
uncounted <- imgs_squish[-match_id_img_roi]


##making folders ####
getwd()
setwd("F:/Theo/iba_7_2020_autocount/working images/substack32_37/new training/random_quarters/new_male_only_6_24/classifiers/min_size_25/")
n= 10
nm = "class"
nm2= "_mask"
for (i in 11:15){
  dir.create(paste(getwd(),"/",nm,i,nm2,sep = ""))
}
