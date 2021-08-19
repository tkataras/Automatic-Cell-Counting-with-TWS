#####looking at size restriction for all validation images





###need to add the genotype and sex info, also the final auto count from tp+fp, i do so in excell
#####this makes the table comparing all classifiers
your_boat <- NA
for (i in 1:15){

  class_dir <- ("F:/Theo/iba_7_2020_autocount/working images/substack32_37/new training/random_quarters/new_male_only_6_24/classifiers/")
  output_dir <- paste(c(class_dir,"class", i,"_mask/"), collapse = "")
  input_file <- "Results.csv"
  combo <- paste(c(output_dir,input_file), collapse = "")
  
  ###the part above works for using a regular expression to iterate through all the folders with classifiers
  #the important part here is for final+blah2 to be the final table with geno info added
  
  results <- read.csv(combo)
  
  your_boat <- rbind(your_boat, results)
}
dim(your_boat)
head(your_boat)
miss_area <- your_boat$Area[your_boat$points == 0]
length(miss_area)
hit_area <- your_boat$Area[your_boat$points == 1]
length(hit_area)

hist(miss_area, breaks = 60, xlim = range(0,100))

hist(hit_area, breaks = 60, xlim = range(0,300))
write.csv(your_boat, "F:/Theo/iba_7_2020_autocount/working images/substack32_37/new training/random_quarters/new_male_only_6_24/classifiers/Results_all_class_val_7_6_2021.csv")

sum(as.numeric((miss_area >= 25)), na.rm = T)
sum(as.numeric((hit_area >= 25)), na.rm = T)

sum(as.numeric((miss_area >= 30)), na.rm = T)
sum(as.numeric((hit_area >= 30)), na.rm = T)
min(your_boat$Area, na.rm = T)
