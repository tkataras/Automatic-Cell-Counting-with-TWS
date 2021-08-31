#generate geno file





trim_names <- function(file_names){
  id1 <- file_names
  sid1 <- strsplit(id1, " - ")
  
  
  newsid1 <- NA
  for (i in 1:length(sid1)){
    newsid1 <- c(newsid1, tail(sid1[[i]],1))
  }
  newsid1 <- newsid1[-1]
}
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
squish <- function(input_df){
  
  id1_df_squish <- NA
  for (i in 1:dim(input_df)[1]) {
    id1_df_squish[i] <- paste0(input_df[i,], sep = "_", collapse = "")  
  }
  return(id1_df_squish)
}##simple function to combine rows of the df with info
get_match_id <- function(sub_inv,full_inv){
  match_id <- NA
  
  
  
  for (i in 1: length(sub_inv) ){
    pineapple <- grep(sub_inv[i],full_inv)
    if (sum(pineapple) == 0) {print("not found")} else match_id[i] <- pineapple
  }
  match_id <- match_id[complete.cases(match_id)]
}



full2_dir <- dir("F:/Theo/full_backup_3_23_2021/Kaul_lab_work/bin_general/Data/Full_dataset/counted2/class19/")[1:42]
full2_sep <-(sep_slidebook(trim_names(full_dir)))[1:42,]
full2_sep[,1]

wtn = c(442, 460, 462,878, 899, 898)
gpn = c(426, 428, 443, 306, 307, 319)

geno <- rep(NA,42)




geno[full2_sep[,1] %in% wtn ] = "wt"

geno[full2_sep[,1] %in% gpn ] = "gp"

write.csv(geno, "F:/Theo/full_backup_3_23_2021/Kaul_lab_work/bin_general/Data/Full_dataset/geno_full.csv")

wt_imgs <- final_blah[d$a_num %in% wtn, ]
dim(wt_imgs)
gp_imgs <- final_blah[d$a_num %in% gpn, ]
dim(gp_imgs)

final_blah$geno[d$a_num %in% wtn] = "wt"
final_blah$geno[d$a_num %in% gpn] = "gp"