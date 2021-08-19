library("EBImage")
library("OpenImageR")

datain <- "C:/Users/User/Desktop/Kaul_lab_work/Rohan/LAV2378-s75-051116-Iba-PSD95-10x-cortex-F3_XY1525225462_Z0_T0_C1test.tiff"
image <- readImage((datain))

#generating the sub images, currently divides into 100 sections of equal size?
subimages <- untile(image, nim=c(10,10))
str(subimages)


#display(subimages[,,1])

#saving the sub images in a folder
save.image()