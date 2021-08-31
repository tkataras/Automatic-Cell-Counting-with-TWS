###Full dataset counting without accuracy 

counted_folder_dir <-"F:/Theo/full_backup_3_23_2021/Kaul_lab_work/bin_general/Data/Full_dataset/counted2/"
setwd(counted_folder_dir)
class <- list.files()





class_loc <- paste(counted_folder_dir,class,"/Results.csv",sep = "")
class_results <- read.csv(class_loc)



##biig if else loop baby!

##from levels present in the classifier results output, this should be the same each time
img_names <- levels(as.factor(class_results$Label))

count <- NA
for (i in 1:length(img_names)){
  count[i]<- sum(class_results$Label == img_names[i])
  
}

geno <- read.csv("F:/Theo/full_backup_3_23_2021/Kaul_lab_work/bin_general/Data/Full_dataset/geno_full.csv")

length(count)
length(geno$x)

t.test(count ~ geno$x)



