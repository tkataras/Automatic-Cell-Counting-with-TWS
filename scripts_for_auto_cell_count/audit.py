#!/usr/bin/python
###
# Author: Theo Kataras, Tyler Jang
# Date: 12/1/2021
#
# Input: The source directory
#        The classifier selected by the user for the full dataset
# Output: Randomly selected images to audit placed in Audit Images and Audit Counted
# Description: This program randomly selects images to be audited by the third act of the pipeline
###
import pandas as pd
import numpy as np
import os
import sys
import random
import shutil
import csv

print("Starting audit.py")
# Method to change working directory from inputted ImageJ Macro
curr_dir = os.getcwd()
def setDir(arg1):
    curr_dir = arg1
    os.chdir(curr_dir)
setDir(sys.argv[1])

# Get the selected classifier by the user
selected_classifier = sys.argv[2]
#read in genotype.csv
geno_file = "../training_area/testing_area/geno_full.csv"

geno = pd.read_csv(geno_file)
# Get the unique genotype labels
lvl_geno = np.unique(geno["geno"])
if len(lvl_geno) != 2:
    print("automatic analysis can only be done with 2 levels, for alterative analysis use _Final.csv files in classifier folders")

# Read in file names from the counted/projected experimental dataset
folder_loc = "../training_area/testing_area/Weka_Output_Counted/" +  selected_classifier
files = []
for image in os.listdir(folder_loc):
    if image[-4:] == ".png" or image[-4:] == ".jpg":
            files.append(image)

# Determine number of draws by number of files in validation hand count folder
# TODO is this supposed to be validation hand counts folder?
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
audit_set = {}
ev0_rand = random.sample((ev0_files.items()), draws_per_geno)
ev1_rand = random.sample((ev1_files.items()), draws_per_geno)
for elem in ev0_rand:
    audit_set[elem[0]] = elem[1]
for elem in ev1_rand:
    audit_set[elem[0]] = elem[1]

###need to get these random variable numbers from oritional file directory, eg images, counted 
# TODO Temp so I don't need to redo ROI stuff
"""
# Copy selected images into audit images directory
for file in audit_set.keys():
    filename =  os.path.basename(file)
    print(filename)
    
    shutil.copyfile("../training_area/testing_area/Images/" + filename, os.path.join("../training_area/testing_area/Audit_Images/" + selected_classifier +"/", filename))
    shutil.copyfile("../training_area/testing_area/Weka_Output_Counted/" + selected_classifier +"/" + filename, os.path.join("../training_area/testing_area/Audit_Counted/"+ selected_classifier +"/", filename))
"""
# Write a CSV for the geno data with images in alphabetical order
geno_csv = []
for key, value in sorted(audit_set.items()):
    geno_csv.append([value])
print(geno_csv)

# TODO Temp so I don't need to redo ROI stuff
"""
with open("../training_area/testing_area/geno_audit.csv", 'w+', newline ='') as file:
    write = csv.writer(file)
    write.writerow(["geno"])
    write.writerows(geno_csv)
"""
"""
hand_ini = pd.read_csv("../training_area/testing_area/Audit_Hand_Counts/roi_counts.csv", usecols=['Label'])
lvl_h = np.unique(hand_ini)
count_h = {}
for i in range(0, len(hand_ini)):
    if count_h.get(hand_ini.loc[i].at["Label"]) == None:
        count_h[hand_ini.loc[i].at["Label"]] = 1
    else:
        count_h[hand_ini.loc[i].at["Label"]] = count_h[hand_ini.loc[i].at["Label"]] + 1

print(count_h)
"""
print("Finished audit.py") 