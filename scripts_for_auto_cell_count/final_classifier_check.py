#!/usr/bin/python
###
# Author: Tyler Jang, Theo Kataras
# Date 2/9/2022
#
# Inputs: genotype file, hand count results csv, results of auto counting in each classifier folder 
# Outputs: csv table with accuracy measurements for the selected classifier
# This file finds the statistical performance of the selected classifier on the entire image dataset
###
import pandas as pd
import numpy as np
import os
import sys
import scipy.stats

print("Starting finalClassifierCheck.py\n")
# Method to change working directory from inputted ImageJ Macro
curr_dir = os.getcwd()
def set_dir(arg1):
    curr_dir = arg1
    os.chdir(curr_dir)
set_dir(sys.argv[1])
    
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

# Remove file extensions and point deliminator 
for i in range(0, len(class_list)):
    row_name = class_list[i]
    row_name = row_name.split(":")[0]
    row_name = row_name.split(".")[0]
    class_list[i] = row_name

# Get the unique image names
unique_img = np.unique(class_list)
class_res_loc = output_count + selectedClassifier + "/" + selectedClassifier + "_Results_test_data.csv"
class_results = pd.read_csv(class_res_loc)

# Replace label column to remove file extensions and point
label_col = class_results["Label"]
for i in range(0, len(class_results)):
    row_name = class_results.loc[i].at["Label"]
    row_name = row_name.split(":")[0]
    row_name = row_name.split(".")[0]
    #label_col.loc[i] = row_name
    class_results.loc[i, "Label"] = row_name

img_counts = pd.DataFrame(columns=["Label", "Counts"])
cell_list = list(class_results["Label"])
# Iterate through each image and its count for the selected classifier 
for f in range(0, len(unique_img)):
    this_count = cell_list.count(unique_img[f]) - 1
    new_row = pd.DataFrame([[unique_img[f], this_count]], columns=["Label", "Counts"])
    img_counts = img_counts.append(new_row)
print(cell_list)
geno = pd.read_csv(geno_file)

# Get the unique genotype labels
lvl_geno = np.unique(geno["geno"])

# Only 1 level
if len(lvl_geno) == 1:
    print("Analysis with 1 level")
    geno_list = []
    for numRows in range(0, len(img_counts["Label"])):
        geno_list.append(geno["geno"][numRows])

    img_counts["geno"] = geno_list

    # Save current img counts to the counted classifier folder as csv file
    img_counts.to_csv(output_count + selectedClassifier + "/" + selectedClassifier + "_final.csv")

    # Calculate the 1 Sample T-test   
    group_one = img_counts.query('geno == @lvl_geno[0]')
    t_test_calc = scipy.stats.ttest_1samp(group_one["Counts"],  popmean=1, nan_policy="omit")
 
    # Calculate the mean counts
    print(str(lvl_geno[0]) + " Mean Counts: " + str(np.mean(group_one["Counts"])))
 
    # Calculate the Standard Deviation 
    print(str(lvl_geno[0]) + " Standard Deviation: " + str(np.std(group_one["Counts"])))

    # Calculate the Confidence Interval
    print(str(lvl_geno[0]) + " 95% Confidence Interval: ")
    print(scipy.stats.norm.interval(alpha=0.95, loc=np.mean(group_one["Counts"])))

    # Write the T Test results
    print("T-test statistic: " + str(t_test_calc[0]))
    print("P-Value: " + str(t_test_calc[1]))
    print("Total Count: " + str(np.sum(group_one["Counts"])))
# 2+ levels
elif len(lvl_geno) > 2:
    geno_list = []
    for numRows in range(0, len(img_counts["Label"])):
        geno_list.append(geno["geno"][numRows])

    img_counts["geno"] = geno_list

    # Save current img counts to the counted classifier folder as csv file
    img_counts.to_csv(output_count + selectedClassifier + "/" + selectedClassifier + "_final.csv")
    # Create as many groups as there are levels
    group_n = []
    counts_df = pd.DataFrame(index=range(len(geno_list)), columns=lvl_geno)
    # Set up ANOVA calculation
    for index in range(0, len(lvl_geno)):
        # Get the current condition
        curr_group = lvl_geno[index]
        group_n.append(img_counts.query('geno == @curr_group'))
        
        # Set up values of current condition as a dataframe
        curr_counts = list(group_n[index]["Counts"])
        curr_counts = pd.DataFrame(curr_counts, columns=[curr_group])

        # Append current condition values to ANOVA dataframe
        counts_df.loc[:,[curr_group]] = curr_counts[[curr_group]]
        
    # Remove NA rows from dataframe, the size of each condition should be equal
    counts_df = counts_df.dropna()
            
    # Calculate ANOVA
    counts_f_val, counts_p_val = scipy.stats.f_oneway(*counts_df.iloc[:,0:len(lvl_geno)].T.values)

    # Print mean counted, standard deviation, and confidence interval
    for group in lvl_geno:
        print(str(group) + " Mean Counts: " + str(np.mean(counts_df[str(group)])))
        print(str(group) + " Standard Deviation: " + str(np.std(counts_df[str(group)])))
        print(str(group) + " 95% Confidence Interval: ")
        print(scipy.stats.norm.interval(alpha=0.95, loc=np.mean(counts_df[str(group)])))

    # Write out ANOVA results
    print(selectedClassifier + " ANOVA Object Count F-Value over " + str(len(lvl_geno)) + " conditions = " + str(counts_f_val))
    print(selectedClassifier + " ANOVA Object Count P-Value over " + str(len(lvl_geno)) + " conditions = " + str(counts_p_val))
    print("Total counts are inside the final csv")
# Else, only two levels
else:
    geno_list = []
    for numRows in range(0, len(img_counts["Label"])):
        geno_list.append(geno["geno"][numRows])

    img_counts["geno"] = geno_list

    # Save current img counts to the counted classifier folder as csv file
    img_counts.to_csv(output_count + selectedClassifier + "/" + selectedClassifier + "_final.csv")

    # Calculate the Welch 2 Sample T-test   
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
    total_count = np.sum(group_one["Counts"]) + np.sum(group_two["Counts"])
    print("Total Count: " + str(total_count))

print("\nFinished finalClassifierCheck.py")