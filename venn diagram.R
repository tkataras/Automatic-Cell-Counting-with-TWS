### venn diagram
# install.packages("venneuler")
library(venneuler)
# MyVenn <- venneuler(c(A=74344,B=33197,C=26464,D=148531,"A&B"=11797, 
#                       "A&C"=9004,"B&C"=6056,"A&B&C"=2172,"A&D"=0,"A&D"=0,"B&D"=0,"C&D"=0))
# MyVenn$labels <- c("A\n22","B\n7","C\n5","D\n58")
# plot(MyVenn)
# text(0.59,0.52,"1")
# text(0.535,0.51,"3")
# text(0.60,0.57,"2")
# text(0.64,0.48,"4") 
# 
# 
# ###2 circles
# MyVenn2 <- venneuler(c(A=40,B=20,"A&B"=10))
# MyVenn2$labels <- c("A\n40","B\n20")
# 
# plot(MyVenn2)

install.packages("VennDiagram")
require(VennDiagram)
# venn.diagram(list(B = 1:1800, A = 1571:2020),fill = c("red", "green"),
#              alpha = c(0.5, 0.5), cex = 2,cat.fontface = 4,lty =2, fontfamily =1, 
#              filename = "trial2.png");
# 
# venn.diagram(list(B = c("a",'b',"c","d","e","f","g"), A = c("a",'b',"c","d","e","f","h")),fill = c("red", "green"),
#              alpha = c(0.5, 0.5), cex = 2,cat.fontface = 4,lty =2, fontfamily =1, 
#              filename = "trial3.png");
# 
# venn.diagram(list(B = c(30:51), A = c(-10:40)),fill = c("red", "green"),
#              alpha = c(0.5, 0.5), cex = 2,cat.fontface = 4,lty =2, fontfamily =1, 
#              filename = "trial4.png");



datain <- read.csv("C:/Users/User/Desktop/Kaul_lab_work/daniel venn/female cortex for venn.csv")

venn.diagram(list(B = datain$gp120, A = datain$LCN2ko.gp120),fill = c("red", "green"),
             alpha = c(0.5, 0.5), cex = 2,cat.fontface = 4,lty =2, fontfamily =1, main ="female cortex A_lcn2ko",
             filename = "f_c_lcn2ko.png");

venn.diagram(list(B = datain$gp120, A = datain$CCR5ko.gp120),fill = c("red", "green"),
             alpha = c(0.5, 0.5), cex = 2,cat.fontface = 4,lty =2, fontfamily =1, main ="female cortex A_ccr5ko", 
             filename = "f_c_ccr5ko.png");

venn.diagram(list(B = datain$gp120, A = datain$CCR5ko.LCN2ko.gp120),fill = c("red", "green"),
             alpha = c(0.5, 0.5), cex = 2,cat.fontface = 4,lty =2, fontfamily =1, main ="female cortex A_ccr5ko_lcn2ko", 
             filename = "f_c_lcn2ccr5ko.png");


# venn.diagram(list(B = datain$gp120, A = datain$LCN2ko.gp120, C = datain$CCR5ko.gp120, D = datain$CCR5ko.LCN2ko.gp120),fill = c("red", "green", "blue", "yellow"),
#              alpha = c(0.5, 0.5,0.5, 0.5), cex = 2,cat.fontface = 4,lty =2, fontfamily =1, main ="female cortex A_Lcn2 B_gp120  C_ccr5ko D_double", 
#              filename = "f_c_all.png");



datain2 <- read.csv("C:/Users/User/Desktop/Kaul_lab_work/daniel venn/Female hippo for venn.csv")


venn.diagram(list(B = datain2$gp120, A = datain2$LCN2ko.gp120),fill = c("red", "green"),
             alpha = c(0.5, 0.5), cex = 2,cat.fontface = 4,lty =2, fontfamily =1, main ="female hippo A_lcn2ko" ,
             filename = "f_h_lcn2ko.png");

venn.diagram(list(B = datain2$gp120, A = datain2$CCR5ko.gp120),fill = c("red", "green"),
             alpha = c(0.5, 0.5), cex = 2,cat.fontface = 4,lty =2, fontfamily =1, main ="female hippo A_ccr5ko" ,
             filename = "f_h_ccr5ko.png");

venn.diagram(list(B = datain2$gp120, A = datain2$CCR5ko.LCN2ko.gp120),fill = c("red", "green"),
             alpha = c(0.5, 0.5), cex = 2,cat.fontface = 4,lty =2, fontfamily =1, main ="female hippo A_lcn2ko_ccr5ko" ,
             filename = "f_h_lcn2ccr5ko.png");


datain3 <- read.csv("C:/Users/User/Desktop/Kaul_lab_work/daniel venn/male cortex for venn.csv")

venn.diagram(list(B = datain3$gp120, A = datain3$LCN2ko.gp120),fill = c("red", "green"),
             alpha = c(0.5, 0.5), cex = 2,cat.fontface = 4,lty =2, fontfamily =1, main ="male cortex A_lcn2ko" ,
             filename = "m_c_lcn2ko.png");


venn.diagram(list(B = datain3$gp120, A = datain3$CCR5ko.gp120),fill = c("red", "green"),
             alpha = c(0.5, 0.5), cex = 2,cat.fontface = 4,lty =2, fontfamily =1, main ="male cortex A_ccr5ko" ,
             filename = "m_c_ccr5ko.png");

venn.diagram(list(B = datain3$gp120, A = datain3$CCR5ko.LCN2ko.gp120),fill = c("red", "green"),
             alpha = c(0.5, 0.5), cex = 2,cat.fontface = 4,lty =2, fontfamily =1, main ="male cortex A_lcn2ko_ccr5ko" ,
             filename = "m_c_lcn2ccr5ko.png");


datain4 <- read.csv("C:/Users/User/Desktop/Kaul_lab_work/daniel venn/male hippo for venn.csv")

venn.diagram(list(B = datain4$gp120, A = datain4$LCN2ko.gp120),fill = c("red", "green"),
             alpha = c(0.5, 0.5), cex = 2,cat.fontface = 4,lty =2, fontfamily =1, main ="male hippo A_lcn2ko" ,
             filename = "m_h_lcn2ko.png");

venn.diagram(list(B = datain4$gp120, A = datain4$CCR5ko.gp120),fill = c("red", "green"),
             alpha = c(0.5, 0.5), cex = 2,cat.fontface = 4,lty =2, fontfamily =1, main ="male hippo A_ccr5ko" ,
             filename = "m_h_ccr5ko.png");

venn.diagram(list(B = datain4$gp120, A = datain4$CCR5ko.LCN2ko.gp120),fill = c("red", "green"),
             alpha = c(0.5, 0.5), cex = 2,cat.fontface = 4,lty =2, fontfamily =1, main ="male hippo A_lcn2ko_ccr5ko" ,
             filename = "m_h_lcn2ccr5ko.png");

#male gp120 hippo, female gp120 hippo
##male hippo = datain4, f = datain2
venn.diagram(list(B = datain4$gp120, A = datain2$gp120),fill = c("red", "green"),
             alpha = c(0.5, 0.5), cex = 2,cat.fontface = 4,lty =2, fontfamily =1, main ="B-male hippo gp120 A_f_h_gp120" ,
             filename = "test.png");

#male vs f all 

datainfc <- read.csv("C:/Users/User/Desktop/Kaul_lab_work/daniel venn/female cortex for venn.csv")
datainfh <- read.csv("C:/Users/User/Desktop/Kaul_lab_work/daniel venn/Female hippo for venn.csv")
datainmc <- read.csv("C:/Users/User/Desktop/Kaul_lab_work/daniel venn/male cortex for venn.csv")
datainmh <- read.csv("C:/Users/User/Desktop/Kaul_lab_work/daniel venn/male hippo for venn.csv")

#cortex
length(datainfc$gp120)
length(datainmc$gp120)
length(intersect(datainfc$gp120,datainmc$gp120))


venn.diagram(list(B = datainfc$gp120, A = datainmc$gp120),fill = c("red", "green"),
             alpha = c(0.5, 0.5), cex = 1,cat.fontface = 4,lty =2, fontfamily =1, main ="Cortex gp120" ,
             category.names=c("", ""), cat.pos = c(30,-30),inverted = T, filename = "gp120cor2.png");


venn.diagram(list(B = datainfc$LCN2ko.gp120, A = datainmc$LCN2ko.gp120),fill = c("red", "green"),
             alpha = c(0.5, 0.5), cex = 2,cat.fontface = 4,lty =2, fontfamily =1, main ="Cortex Lcn2ko gp120" ,
             category.names=c("", ""), cat.pos = c(60,-60),inverted = T,filename = "gp120lcn2kocor2.png");

venn.diagram(list(B = datainfc$CCR5ko.gp120, A = datainmc$CCR5ko.gp120),fill = c("red", "green"),
             alpha = c(0.5, 0.5), cex = 2,cat.fontface = 4,lty =2, fontfamily =1, main ="Cortex Ccr5ko gp120" ,
             category.names=c("", ""),filename = "gp120ccr5kocor2.png");

venn.diagram(list(B = datainfc$CCR5ko.LCN2ko.gp120, A = datainmc$CCR5ko.LCN2ko.gp120),fill = c("red", "green"),
             alpha = c(0.5, 0.5), cex = 2,cat.fontface = 4,lty =2, fontfamily =1, main ="Cortex Ccr5ko Lcn2ko gp120" ,
             category.names=c("", ""), cat.pos = c(30,-30),inverted = T,filename = "gp120doublecor2.png");

#hippo
venn.diagram(list(B = datainfh$gp120, A = datainmh$gp120),fill = c("red", "green"),
             alpha = c(0.5, 0.5), cex = 2,cat.fontface = 4,lty =2, fontfamily =1, main ="Hippo gp120" ,
             category.names=c("", ""),filename = "gp120hip2.png");

venn.diagram(list(B = datainfh$LCN2ko.gp120, A = datainmh$LCN2ko.gp120),fill = c("red", "green"),
             alpha = c(0.5, 0.5), cex = 2,cat.fontface = 4,lty =2, fontfamily =1, main ="Hippo Lcn2ko gp120" ,
             category.names=c("", ""),filename = "gp120lcn2kohip2.png");

venn.diagram(list(B = datainfh$CCR5ko.gp120, A = datainmh$CCR5ko.gp120),fill = c("red", "green"),
             alpha = c(0.5, 0.5), cex = 2,cat.fontface = 4,lty =2, fontfamily =1, main ="Hippo Ccr5ko gp120" ,
             category.names=c("", ""),filename = "gp120ccr5kohip2.png");

venn.diagram(list(B = datainfh$CCR5ko.LCN2ko.gp120, A = datainmh$CCR5ko.LCN2ko.gp120),fill = c("red", "green"),
             alpha = c(0.5, 0.5), cex = 2,cat.fontface = 4,lty =2, fontfamily =1, main ="Hippo Ccr5ko Lcn2ko gp120" ,
             category.names=c("", ""),filename = "gp120doublehip2.png");

# venn.diagram(list(B = datainfh$CCR5ko.LCN2ko.gp120, A = datainmh$CCR5ko.LCN2ko.gp120),fill = c("red", "green"),
#              alpha = c(0.5, 0.5), cex = 2,cat.fontface = 4,lty =2, fontfamily =1, main ="B_fh_double A_mh_double" ,
#              category.names=c("fem_double", "male_double"), filename = "names_test2.png");










##prints b on left
venn.diagram(list(B = datainfc$CCR5ko.LCN2ko.gp120, A = datainmc$CCR5ko.LCN2ko.gp120),fill = c("red", "green"),
             alpha = c(0.5, 0.5), cex = 2,cat.fontface = 4,lty =2, fontfamily =1, main ="test B_fc_double A_mc_double" ,
             filename = "testgp120doublecor.png");

venn.diagram(list(B = datainfc$CCR5ko.LCN2ko.gp120, A = datainmc$CCR5ko.LCN2ko.gp120),fill = c("red", "green"),
             alpha = c(0.5, 0.5), cex = 2,cat.fontface = 4,lty =2, fontfamily =1, main ="test B_fc_double A_mc_double" ,
             cat.pos = 180,rotation.degree = 180,filename = "test2gp120doublecor.png");

venn.diagram(list(B = datainfc$CCR5ko.LCN2ko.gp120, A = datainmc$CCR5ko.LCN2ko.gp120),fill = c("red", "green"),
             alpha = c(0.5, 0.5), cex = 2,cat.fontface = 4,lty =2, fontfamily =1, main ="test B_fc_double A_mc_double" ,
             cat.pos = c(30,-30),inverted = T,filename = "test3gp120doublecor.png");



#trying venneuler
MyVenn2 <- venneuler(c(A=40,B=20,"A&B"=10))
MyVenn2$labels <- c("A\n40","B\n20")
 
plot(MyVenn2)

MyVenn2 <- venneuler(c(A=20,B=40,"A&B"=10))
MyVenn2$labels <- c("A\n40","B\n20")

plot(MyVenn2)


#####calculate.overlap will tell us what overlaps
ctest <- calculate.overlap(list(B = datainfc$CCR5ko.LCN2ko.gp120, A = datainmc$CCR5ko.LCN2ko.gp120))
                  

######working on venn diagrams again, 8/6/2019
datain_mc <- read.csv("C:/Users/User/Documents/male cortex for venn 8_6_2019.csv")
datain_fc <- read.csv("C:/Users/User/Documents/female cortex for venn 8_6_2019.csv")

venn.diagram(list(B = datain_fc$LCN2ko, A = datain_mc$LCN2ko),fill = c("red", "green"),
             alpha = c(0.5, 0.5), cex = 2,cat.fontface = 4,lty =2, fontfamily =1, main ="Cortex LCN2ko" ,
             filename = "LCN2ko_8_6.png");

venn.diagram(list(B = datain_fc$CCR5ko, A = datain_mc$CCR5ko),fill = c("red", "green"),
             alpha = c(0.5, 0.5), cex = 2,cat.fontface = 4,lty =2, fontfamily =1, main ="Cortex CCR5ko" ,inverted = T,
             filename = "CCR5ko_8_6.png");

venn.diagram(list(B = datain_fc$CCR5ko.LCN2ko, A = datain_mc$CCR5ko.LCN2ko),fill = c("red", "green"),
             alpha = c(0.5, 0.5), cex = 2,cat.fontface = 4,lty =2, fontfamily =1, main ="Cortex CCR5ko LCN2ko" ,inverted = T,
             filename = "CCR5ko_LCN2ko_8_6.png");



datain_mh <- read.csv("C:/Users/User/Documents/male hippo 8_6.csv")
datain_fh <- read.csv("C:/Users/User/Documents/female hippo 8_6.csv")

venn.diagram(list(B = datain_fh$LCN2ko, A = datain_mh$LCN2ko),fill = c("red", "green"),
             alpha = c(0.5, 0.5), cex = 2,cat.fontface = 4,lty =2, fontfamily =1, main ="Hippo LCN2ko" ,
             filename = "hippo_LCN2ko_8_6.png");

venn.diagram(list(B = datain_fh$CCR5ko, A = datain_mh$CCR5ko),fill = c("red", "green"),
             alpha = c(0.5, 0.5), cex = 2,cat.fontface = 4,lty =2, fontfamily =1, main ="Hippo CCR5ko" ,inverted = T,
             filename = "hippo_CCR5ko_8_6.png");

venn.diagram(list(B = datain_fh$CCR5ko.LCN2ko, A = datain_mh$CCR5ko.LCN2ko),fill = c("red", "green"),
             alpha = c(0.5, 0.5), cex = 2,cat.fontface = 4,lty =2, fontfamily =1, main ="Hippo CCR5ko LCN2ko" ,
             filename = "hippo_CCR5ko_LCN2ko_8_6.png");



