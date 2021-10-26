# -*- coding: utf-8 -*-
"""
Created on Mon Oct 25 10:59:36 2021

@author: Theo
Audit: randomly selects number of images equal to validation set and copies images to Audit folder
inputs: genetypes.csv file for unseen data, location of Validation images folder
"""
import os
os.getcwd()
os.chdir("F:/Theo/full_backup_3_23_2021/Kaul_lab_work/bin_general/")
import csv
import numpy
import random
from shutil import copyfile
#copyfile(src, dst)


#read in genetype.csv
geno = open("F:/Theo/full_backup_3_23_2021/Kaul_lab_work/bin_general/data/Full_dataset/geno_full.csv")
geno2 = csv.reader(geno)

#variable name
header = []
header = next(geno2)
print(header)

#row information, holdes exp grouping variable for each image
rows = []
for row in geno2:
    rows.append(row)

g = []
for elements in rows:
    g.append(elements[1])

lvl_geno = numpy.unique(g)
#lvl_geno[1]


#read in file names from the counted/projected unseen dataset
folder_loc = "F:/Theo/full_backup_3_23_2021/Kaul_lab_work/bin_general/data/Full_dataset/Weka_Output_Counted/class19" 
files = []
for image in os.listdir(folder_loc):
    #print(image[-4:])
    if image[-4:] == ".png":
            files.append(image)

#determine number of draws by number of files in validation hand count folder
val_loc = "F:/Theo/full_backup_3_23_2021/Kaul_lab_work/bin_general/data/Validation_files/Validation_Hand_Counts/"
val_files = os.listdir(val_loc)
draws = len(val_files)
draws_per_geno = int(draws/len(lvl_geno))
draws_per_geno

#select the files for each genotype
#define experimental variable level 1 files
ev0_files = []
for i in range(len(files)):
    if g[i] == lvl_geno[0]:
        ev0_files.append(files[i])
        
#define experimental variable level 2 files        
ev1_files = []
for i in range(len(files)):
    if g[i] == lvl_geno[1]:
        ev1_files.append(files[i])

#make random selections for level 1
rand_ev0 = random.sample(ev0_files, draws_per_geno)
rand_ev1 = random.sample(ev1_files, draws_per_geno)

audit_set = rand_ev0 + rand_ev1
audit_set

for file in audit_set:
    shutil.copyfile("../data/Full_dataset/Weka_Output_Counted/class19" + file, "F:/full_backup_3_23_2021/Kaul_lab_work/bin_general/data/Full_dataset/Audit_images/")

#####this might be working, but file not found
