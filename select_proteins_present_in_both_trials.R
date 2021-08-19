#rebecca sorting proteins. want rpesent in both


#need to point this at your full data file
data <- read.csv("C:/Users/User/Downloads/proteinGroups dna pulldown maxquant_1.csv")

#
head(data)

#this willc create a list of proteins present with positive values in both replicates
both <- data$Protein.ID[data$Intensity.GnRH..LH.Trial.1 > 0 & data$Intensity.GnRH.Trial.2 > 0]


head(both)



length(both)
dim(data)

write.csv(both, 'names_in_both.csv')
