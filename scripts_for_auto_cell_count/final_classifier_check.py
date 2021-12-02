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
from scipy.stats.stats import pearsonr

print("Starting finalClassifierCheck.py\n")
# Method to change working directory from inputted ImageJ Macro
curr_dir = os.getcwd()
def setDir(arg1):
    curr_dir = arg1
    os.chdir(curr_dir)
setDir(sys.argv[1])
    
# Get the selected classifier by the user
selectedClassifier = sys.argv[2]

# Input the genotype data as a .csv file
geno_file = "../training_area/testing_area/geno_full.csv"

# File output location
output_count = "../training_area/testing_area/Weka_Output_Counted/"
class_list_temp = os.listdir(output_count + selectedClassifier)

class_list = []
# Select only the images in the classifier
for img in class_list_temp:
    if img[-4:] == ".png" or img[-4:] == ".jpg" or img[-5:] == ".tiff":
        class_list.append(img)

unique_img = np.unique(class_list)

class_res_loc = output_count + selectedClassifier + "/" + selectedClassifier + "_Results_test_data.csv"
class_results = pd.read_csv(class_res_loc)

img_counts = pd.DataFrame(columns=["Label", "Counts"])
cell_list = list(class_results["Label"])
#iterate through each classifier 
for f in range(0, len(unique_img)):
    this_count = cell_list.count(unique_img[f]) - 1
    new_row = pd.DataFrame([[unique_img[f], this_count]], columns=["Label", "Counts"])
    img_counts = img_counts.append(new_row)

geno = pd.read_csv(geno_file)

# Get the unique genotype labels
lvl_geno = np.unique(geno["geno"])
if len(lvl_geno) != 2:
    print("Automatic analysis can only be done with 2 levels, for alterative analysis results file in classifier folder")

geno_list = []
for numRows in range(0, len(img_counts["Label"])):
    geno_list.append(geno["geno"][numRows])

img_counts["geno"] = geno_list

# Save current img counts to the counted classifier folder as csv file
img_counts.to_csv(output_count + selectedClassifier + "/" + selectedClassifier + "_final.csv")

# Calculate the Welch 2 Sample T-test   
# TODO won't this crash on only 1 level?
group_one = img_counts.query('geno == @lvl_geno[0]')
group_two = img_counts.query('geno == @lvl_geno[1]')
t_test_calc = scipy.stats.ttest_ind(group_one["Counts"], group_two["Counts"], equal_var=False, nan_policy="omit")

# Calculate the mean counts
print(str(lvl_geno[0]) + " Mean Counts: " + str(np.mean(group_one["Counts"])))
print(str(lvl_geno[1]) + " Mean Counts: " + str(np.mean(group_two["Counts"])))

# Calculate the Standard Deviation 
print(str(lvl_geno[0]) + " Standard Deviation: " + str(np.std(group_one["Counts"])))
print(str(lvl_geno[1]) + " Standard Deviation: " + str(np.std(group_two["Counts"])))

# Calculate the Confidence Interval
print(str(lvl_geno[0]) + " 95% Confidence Interval: ")
print(scipy.stats.norm.interval(alpha=0.95, loc=np.mean(group_one["Counts"])))
print(str(lvl_geno[1]) + " 95% Confidence Interval: ")
print(scipy.stats.norm.interval(alpha=0.95, loc=np.mean(group_two["Counts"])))

# Write the T Test results
print("T-test statistic: " + str(t_test_calc[0]))
print("P-Value: " + str(t_test_calc[1]))

print("\nFinished finalClassifierCheck.py")