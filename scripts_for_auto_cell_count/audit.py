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
import csv

# Method to change working directory from inputted ImageJ Macro
currDir = os.getcwd()
def setDir(arg1):
    currDir = arg1
    os.chdir(currDir)
setDir(sys.argv[1])

# Output file location
OUTPUT_count = "../training_area/Audit_Counted/"

# Get the selected classifier by the user
selectedClassifier = sys.argv[2]
#read in genotype.csv
geno_file = "../training_area/testing_area/geno_full.csv"

geno = pd.read_csv(geno_file)
# Get the unique genotype labels
lvl_geno = np.unique(geno)
if len(lvl_geno) != 2:
    print("automatic analysis can only be done with 2 levels, for alterative analysis use _Final.csv files in classifier folders")

# Read in file names from the counted/projected experimental dataset
folder_loc = "../training_area/testing_area/Weka_Output_Counted/" +  selectedClassifier
files = []
for image in os.listdir(folder_loc):
    if image[-4:] == ".png":
            files.append(image)

####TODO make rest of this work, i am this far

# Determine number of draws by number of files in validation hand count folder
val_loc = "../training_area/Validation_Hand_Counts/"
val_files = os.listdir(val_loc)
draws = len(val_files)
draws_per_geno = int(draws/len(lvl_geno))

# Select the files for each genotype
# Define experimental variable level 1 files
ev0_files = {}
for i in range(len(files)):
    if geno["geno"][i] == lvl_geno[0]:
        ev0_files[files[i]] = lvl_geno[0]
            
#define experimental variable level 2 files        
ev1_files = {}
for i in range(len(files)):
    if geno["geno"][i] == lvl_geno[1]:
        ev1_files[files[i]] = lvl_geno[1]

#make random selections for level 1
LEV0 = len(ev0_files)
LEV1 = len(ev1_files)

# Randomly select images to be auditted
# TODO may grab same image twice, I'm not sure
audit_set = {}
for incremenet in range(0, draws_per_geno):
    ev0_key, ev0_value = random.choice(list(ev0_files.items()))
    ev1_key, ev1_value = random.choice(list(ev1_files.items()))
    audit_set[ev0_key] = ev0_value
    audit_set[ev1_key] = ev1_value

###need to get these random variable numbers from oritional file directory, eg images, counted 

""" Temp so I don't need to redo ROI stuff
# Copy selected images into audit images directory
for file in audit_set.keys():
    filename =  os.path.basename(file)
    print(filename)
    
    shutil.copyfile("../training_area/testing_area/images/" + filename, os.path.join("../training_area/testing_area/Audit_Images/" + selectedClassifier +"/", filename))
    shutil.copyfile("../training_area/testing_area/Weka_Output_Counted/" + selectedClassifier +"/" + filename, os.path.join("../training_area/testing_area/Audit_Counted/"+ selectedClassifier +"/", filename))
"""
# Write a CSV for the geno data with images in alphabetical order
genoCSV = []
for key, value in sorted(audit_set.items()):
    genoCSV.append([value])
print(genoCSV)
with open("geno_audit.csv", 'w+', newline ='') as file:
    write = csv.writer(file)
    write.writerow(["geno"])
    write.writerows(genoCSV)

hand_ini = pd.read_csv("../training_area/testing_area/Audit_Hand_Counts/roi_counts.csv", usecols=['Label'])
lvl_h = np.unique(hand_ini)
count_h = {}
for i in range(0, len(hand_ini)):
    if count_h.get(hand_ini.loc[i].at["Label"]) == None:
        count_h[hand_ini.loc[i].at["Label"]] = 1
    else:
        count_h[hand_ini.loc[i].at["Label"]] = count_h[hand_ini.loc[i].at["Label"]] + 1

print(count_h)
print("Finished audit.py") 