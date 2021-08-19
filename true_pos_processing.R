### followup to true_pos IJM, will detect number of images, how many hand counts per image, how many true positives

datain <- read.csv("F:/Theo/Sarah_January_2020_Coculture/Naive_Day_1/Results_c5w4_12_11_2020.csv")
head(datain)

img_names <- levels(as.factor(datain$Label))

img_num <- length(img_names)

tru_pos <- NA
hand_count_num <- NA


for(i in 1:img_num){
  tru_pos[i] <- sum(datain$X.Area[datain$Label == img_names[i]])/100
  }



for(i in 1:img_num){
  hand_count_num[i] <- length(datain$Label[datain$Label == img_names[i]])
}


output <- data.frame(img_names, as.numeric(tru_pos), hand_count_num)

head(output)
colnames(output) <- c("image_name", "True_positive", "hand_total_count")

write.csv(output, "F:/Theo/Sarah_January_2020_Coculture/Naive_Day_1/new_val_sharp_histeq_counted/true_pos_12_11_2020.csv")

