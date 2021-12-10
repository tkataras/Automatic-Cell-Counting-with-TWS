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
    precision_df = pd.DataFrame(index=range(len(lvl_geno)), columns=lvl_geno)
    recall_df = pd.DataFrame(index=range(len(lvl_geno)), columns=lvl_geno)
    F1_df = pd.DataFrame(index=range(len(lvl_geno)), columns=lvl_geno)

    # Set up ANOVA calculation
    for index in range(0, len(lvl_geno)):
        # Get the current condition
        curr_group = lvl_geno[index]
        group_n.append(img_counts.query('geno == @curr_group'))

        # Set up values of current condition as a dataframe
        curr_precision = list(group_n[index]["precision2"])
        curr_precision = pd.DataFrame(curr_precision, columns=[curr_group])

        curr_recall = list(group_n[index]["recall2"])
        curr_recall = pd.DataFrame(curr_recall, columns=[curr_group])

        curr_F1 = list(group_n[index]["F1_2"])
        curr_F1 = pd.DataFrame(curr_F1, columns=[curr_group])

        # Append current condition values to ANOVA dataframe
        precision_df.loc[:,[curr_group]] = curr_precision[[curr_group]]
        recall_df.loc[:,[curr_group]] = curr_recall[[curr_group]]
        F1_df.loc[:,[curr_group]] = curr_F1[[curr_group]]
        
        # Remove NA rows from dataframe, the size of each condition should be equal
        precision_df = precision_df.dropna()
        recall_df = recall_df.dropna()
        F1_df = F1_df.dropna()
    """
        # Calculate ANOVA
        precision_f_val, precision_p_val = scipy.stats.f_oneway(*precision_df.iloc[:,0:len(lvl_geno)].T.values)
        recall_f_val, recall_p_val = scipy.stats.f_oneway(*recall_df.iloc[:,0:len(lvl_geno)].T.values)
        F1_f_val, F1_p_val = scipy.stats.f_oneway(*F1_df.iloc[:,0:len(lvl_geno)].T.values)

        # Write out ANOVA results
        print(curr_class + " ANOVA Precision F-Value over " + str(len(lvl_geno)) + " conditions = " + str(precision_f_val))
        print(curr_class + " ANOVA Precision P-Value over " + str(len(lvl_geno)) + " conditions = " + str(precision_p_val))
        print(curr_class + " ANOVA Recall F-Value over " + str(len(lvl_geno)) + " conditions = " + str(recall_f_val))
        print(curr_class + " ANOVA Recall P-Value over " + str(len(lvl_geno)) + " conditions = " + str(recall_p_val))
        print(curr_class + " ANOVA F1 F-Value over " + str(len(lvl_geno)) + " conditions = " + str(F1_f_val))
        print(curr_class + " ANOVA F1 P-Value over " + str(len(lvl_geno)) + " conditions = " + str(F1_p_val) + "\n")
  """
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

print("\nFinished finalClassifierCheck.py")