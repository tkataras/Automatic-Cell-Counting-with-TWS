#!/usr/bin/python
"""
Created on Mon Oct 25 10:59:36 2021

@author: Theo, Tyler
Audit: randomly selects number of images equal to validation set and copies images to Audit folder
inputs: genetypes.csv file for unseen data, location of Validation images folder
"""
import os
from shutil import copyfile
import sys
import csv
import numpy
import random

# Method to change working directory from inputted ImageJ Macro
currDir = os.getcwd()
def setDir(arg1):
    currDir = arg1
    os.chdir(currDir)
setDir(sys.argv[1]) 

os.chdir(sys.argv[1])


# Input the genotype data as a .csv file
geno_file = "../training_area/genotype.csv"

#read in genetype.csv
geno = open("../training_area/geno_full.csv")
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

#read in file names from the counted/projected unseen dataset
folder_loc = "../training_area/testing_area/Weka_Output_Counted/classifier1" 
files = []
for image in os.listdir(folder_loc):
    #print(image[-4:])
    if image[-4:] == ".png":
            files.append(image)

#determine number of draws by number of files in validation hand count folder
val_loc = "../training_area/Validation_Hand_Counts/"
val_files = os.listdir(val_loc)
draws = len(val_files)
draws_per_geno = int(draws/len(lvl_geno))

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
LEV0 = len(ev0_files)
LEV1 = len(ev1_files)


rand_ev0 = random.sample(range(0,LEV0), draws_per_geno)
rand_ev1 = random.sample(range(0,LEV1), draws_per_geno)

###need to get these random variable numbers from oritional file directory, eg images, counted 

# Build the list of randomly selected images to be auditted
audit_set = []
for index in rand_ev0:
    audit_set.append(ev0_files[index])

for index in rand_ev1:
    audit_set.append(ev1_files[index])

# Copy selected images into audit images directory
for file in audit_set:
    filename = "../training_area/testing_area/images/" + os.path.basename(file)
    print(filename)
    copyfile(filename, os.path.join("../training_area/testing_area/Audit_Images", filename))
#####this might be working, but file not found