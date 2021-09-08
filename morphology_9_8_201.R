####morphology measures


#datain_mo <- read.csv("F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/working_images/new_val_train_etc/full_data_run_8bit/counted/class4/Results_before remove val.csv")
datain_mo <- read.csv("F:/Theo/full_backup_3_23_2021/Kaul_lab_work/bin_general/Data/Full_dataset/counted2/class19/Results.csv")

#these calculations will include validation files

#available data
names(datain_mo)
head(datain_mo)

#*#*#*##* gonna remove the greater than 2 point counts, its not relevant here, there are few
sum(datain_mo$points > 1) # this = 10


datain_mo <- datain_mo[datain_mo$points < 2,]
dim(datain_mo)

lm_all_res <- lm(datain_mo$points ~ datain_mo$Area)
summary(lm_all_res)
plot(datain_mo$points ~ datain_mo$Area)

hist(datain_mo$Area[datain_mo$points == 1], xlim=c(0,200))

hist(datain_mo$Area[datain_mo$points == 0], xlim=c(0,200))
hist(datain_mo$Area[datain_mo$points == 0], xlim=c(0,200), ylim= c(0,2000))

##going to have to add geno, i think i can use the inv managemnt commands



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





a <- trim_names(datain_mo$Label)
b <- sep_slidebook(a)

b <- data.frame(b)



wtn = c(442, 460, 462,878, 899, 898)
gpn = c(426, 428, 443, 306, 307, 319)


datain_mo$geno[b$newsid1_anum %in% wtn] = "wt"
datain_mo$geno[b$newsid1_anum %in% gpn] = "gp"
head(datain_mo)



datain_mo_wt <- datain_mo[datain_mo$geno == "wt",]
datain_mo_gp <- datain_mo[datain_mo$geno == "gp",]

t.test(datain_mo_wt$Area[datain_mo_wt$points == 0], datain_mo_gp$Area[datain_mo_gp$points == 0])
t.test(datain_mo_wt$Area[datain_mo_wt$points == 1], datain_mo_gp$Area[datain_mo_gp$points == 1])

#look at over geno vs area
t.test(datain_mo$Area ~ as.factor(datain_mo$geno))
#size vs count
t.test(datain_mo$Area ~ as.factor(datain_mo$points))
boxplot(datain_mo$Area ~ as.factor(datain_mo$points))
#cir vs count
t.test(datain_mo$Circ. ~ as.factor(datain_mo$points))
boxplot(datain_mo$Circ. ~ as.factor(datain_mo$points))


#circ
t.test(datain_mo_wt$Circ.[datain_mo_wt$points == 0], datain_mo_gp$Circ.[datain_mo_gp$points == 0])
t.test(datain_mo_wt$Circ.[datain_mo_wt$points == 1], datain_mo_gp$Circ.[datain_mo_gp$points == 1])#sig
boxplot(datain_mo_wt$Circ.[datain_mo_wt$points == 1], datain_mo_gp$Circ.[datain_mo_gp$points == 1])
t.test(datain_mo$Circ. ~ as.factor(datain_mo$geno))
boxplot(datain_mo$Circ. ~ as.factor(datain_mo$geno))

hist(datain_mo$Circ.[datain_mo$points == 1], xlim=c(0,0.4))

hist(datain_mo$Circ.[datain_mo$points == 0], xlim=c(0,0.4))

hist(datain_mo$Circ.[datain_mo$points == 0], xlim=c(0,0.4), ylim=c(0,600))





