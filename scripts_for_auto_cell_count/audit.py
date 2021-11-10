#!/usr/bin/python
"""
Created on Mon Oct 25 10:59:36 2021

@author: Theo, Tyler
Audit: randomly selects number of images equal to validation set and copies images to Audit folder
inputs: genetypes.csv file for unseen data, location of Validation images folder
"""
import pandas as pd
import numpy as np
import os
import sys
import random
import shutil


# Method to change working directory from inputted ImageJ Macro
currDir = os.getcwd()
def setDir(arg1):
    currDir = arg1
    os.chdir(currDir)
setDir(sys.argv[1])

# Get the selected classifier by the user
selectedClassifier = sys.argv[2]
#read in genotype.csv
geno_file = "../training_area/testing_area/geno_full.csv"


geno = pd.read_csv(geno_file)
# Get the unique genotype labels
lvl_geno = np.unique(geno)
if len(lvl_geno) != 2:
    print("automatic analysis can only be done with 2 levels, for alterative analysis use _Final.csv files in classifier folders")

#read in file names from the counted/projected experimental dataset
folder_loc = "../training_area/testing_area/Weka_Output_Counted/" +  selectedClassifier
files = []
for image in os.listdir(folder_loc):
    if image[-4:] == ".png":
            files.append(image)

####TODO make rest of this work, i am this far

#determine number of draws by number of files in validation hand count folder
val_loc = "../training_area/Validation_Hand_Counts/"
val_files = os.listdir(val_loc)
draws = len(val_files)
draws_per_geno = int(draws/len(lvl_geno))

#select the files for each genotype
#define experimental variable level 1 files
ev0_files = []
for i in range(len(files)):
    if geno["geno"][i] == lvl_geno[0]:
        ev0_files.append(files[i])
            
#define experimental variable level 2 files        
ev1_files = []
for i in range(len(files)):
    if geno["geno"][i] == lvl_geno[1]:
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
    filename =  os.path.basename(file)
    print(filename)
    shutil.copyfile("../training_area/testing_area/images/" + filename, os.path.join("../training_area/testing_area/Audit_Images/" + selectedClassifier +"/", filename))
    shutil.copyfile("../training_area/testing_area/Weka_Output_Counted/" + selectedClassifier +"/" + filename, os.path.join("../training_area/testing_area/Audit_Counted/"+ selectedClassifier +"/", filename))

print("Finished audit.py")