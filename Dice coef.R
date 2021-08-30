dat <- read.csv("F:/Theo/iba_7_2020_autocount/Hina_IFNBKO_pair/working_images/new_val_train_etc/new_new_train/counted/masks_class19/class19_Final.csv")

DC <- (2*(dat$tp))/(2*(dat$tp)+ dat$fn + dat$fp)
mean(DC)


