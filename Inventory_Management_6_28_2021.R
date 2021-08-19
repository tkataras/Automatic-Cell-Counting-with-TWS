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




##need to have no repeated elements in name before send to squish
sep_slidebook <- function(x, sep = "-"){

  newsid1 <- x
  newsid1_s <- strsplit(newsid1, sep)
  

  #look at what elements you are working with
  head(newsid1_s,3)
  
  
  
  
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





###the smaller folder to check

inputdir_val <- "F:/Theo/iba_7_2020_autocount/working images/substack32_37/new training/random_quarters/new_male_only_6_24/validation/"
inputdir_val <- dir(inputdir_val)


newsid2 <- trim_names(inputdir_val)
id2_df_sep <- sep_slidebook(x = newsid2)
id2_df_squish <- squish(input_df = id2_df_sep)

#finding matches bewteen the full image roster and the validation image folder


match_id <- NA
for (i in 1: length(id2_df_squish) ){
  pineapple <- grep(id2_df_squish[i],id1_df_squish)
  if (sum(pineapple) == 0) {} else match_id[i] <- pineapple
}
match_id <- match_id[complete.cases(match_id)]
length(match_id)


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

#so the process is: trim, sep, squish, match, assign

