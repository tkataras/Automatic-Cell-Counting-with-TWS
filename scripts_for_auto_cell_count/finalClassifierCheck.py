#!/usr/bin/python
###
# Author: Tyler Jang, Theo Kataras
# Date 11/5/2021
# This file is the pipeline for comparing classifier accuracy on validation data
#
# Inputs: genotype file, hand count results file from Cout Roi, results of The Count.IJM in each classifier folder 
# Outputs: csv table with accuracy measurements for each classifier
###
import pandas as pd
import numpy as np
import os
import sys
import scipy.stats

# Method to change working directory from inputted ImageJ Macro
currDir = os.getcwd()
def setDir(arg1):
    currDir = arg1
    os.chdir(currDir)
setDir(sys.argv[1])
    
# Get the selected classifier by the user
selectedClassifier = sys.argv[2]


# Input the genotype data as a .csv file
geno_file = "../training_area/testing_area/geno_full.csv"

# File output location
OUTPUT_count = "../training_area/testing_area/Weka_Output_Counted/"
result_out = "../training_area/testing_area/Results/" #this isnt called at all -TK
class_list_temp = os.listdir(OUTPUT_count + selectedClassifier)

class_list = []
# Select only the images in the classifier
for img in class_list_temp:
    if img[-4:] == ".png":
        class_list.append(img)

unique_img = np.unique(class_list)

print("Got to start iterating over classifier images")
class_res_loc = OUTPUT_count + selectedClassifier + "/" + selectedClassifier + "_Results_test_data.csv"
class_results = pd.read_csv(class_res_loc)

imgCounts = pd.DataFrame(columns=["Label", "Counts"])
cellList = list(class_results["Label"])
#iterate through each classifier 
for f in range(0, len(unique_img)):
    thisCount = cellList.count(unique_img[f]) - 1
    newRow = pd.DataFrame([[unique_img[f], thisCount]], columns=["Label", "Counts"])
    imgCounts = imgCounts.append(newRow)

geno = pd.read_csv(geno_file)

# Get the unique genotype labels
lvl_geno = np.unique(geno["geno"])
if len(lvl_geno) != 2:
    print("Automatic analysis can only be done with 2 levels, for alterative analysis results file in classifier folder")

genoList = []
for numRows in range(0, len(imgCounts["Label"])):
    genoList.append(geno["geno"][numRows])

imgCounts["geno"] = genoList

# Save current img counts to the counted classifier folder as csv file
imgCounts.to_csv(OUTPUT_count + selectedClassifier + "/" + selectedClassifier + "_final.csv")

# Calculate the Welch 2 Sample T-test   
groupOne = imgCounts.query('geno == @lvl_geno[0]')
groupTwo = imgCounts.query('geno == @lvl_geno[1]')
t_test_calc = scipy.stats.ttest_ind(groupOne["Counts"], groupTwo["Counts"], equal_var=False, nan_policy="omit")

print("T-test statistic: " + str(t_test_calc[0]))
print("P-Value: " + str(t_test_calc[1]))