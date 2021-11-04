#!/usr/bin/python
###
# Author: Tyler Jang, Theo Kataras
# Date 10/26/2021
# This file is the pipeline for comparing classifier accuracy on validation data
#
# Inputs: genotype file, hand count results file from Cout Roi, results of The Count.IJM in each classifier folder 
# Outputs: csv table with accuracy measurements for each classifier
###
import pandas as pd
import numpy as np
import os
import sys
import time
import scipy.stats

# Method to change working directory from inputted ImageJ Macro
currDir = os.getcwd()
def setDir(arg1):
    currDir = arg1
    os.chdir(currDir)
setDir(sys.argv[1])
    
selectedClassifier = sys.argv[2]
# Find the number of image names to get the count of each cell in each image

# Input the genotype data as a .csv file
geno_file = "../training_area/testing_area/geno_full.csv"

# File output location
OUTPUT_count = "../training_area/testing_area/Weka_Output_Counted/"
result_out = "../training_area/testing_area/Results/"

class_list = os.listdir(OUTPUT_count + selectedClassifier)

# Select only the images in the classifier
for img in class_list:
    if img.find(".csv") != -1:
        class_list.remove(img)

unique_img = np.unique(class_list)
print(class_list)
############################## now we have binary projected images to work with and need to compare to roi for each classifier

#initialize variables
#row_row = pd.DataFrame(columns=["class", "prec", "reca", "F1", "F1_g_tt_p", "mean_F1_gp,mean_F1_wt", "p_g_tt_p", "r_g_tt_p", "class"]) #holds row of accuracy values for each classifier one at a time
#your_boat = pd.DataFrame(columns=["class", "prec", "reca", "F1", "F1_g_tt_p", "mean_F1_gp", "mean_F1_wt", "p_g_tt_p", "r_g_tt_p"]) #holds all accuracy values for classifiers
#count_h <- NA # holds hand count number per image

###################now need to proces the results files


#iterate through the counted classifier folders folders, will save final output within each folder
#setting working dir, needs to contain all counted output folders


##processing hand count roi to get count per image

### adding in the results of the hand_count_from_roi.ijm, this will not change by folder, and is generated manually by saving results in Imagej from Count ROI

#location of folders holding The Count output

print("Got to start of iterating over classifier images")
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
print(len(imgCounts["Label"]))
print(imgCounts)

# Get the unique genotype labels
lvl_geno = np.unique(geno)
if len(lvl_geno) != 2:
    print("automatic analysis can only be done with 2 levels, for alterative analysis use _Final.csv files in classifier folders")

genoList = []
for numRows in range(0, len(imgCounts["Label"])):
    genoList.append(geno["geno"][numRows])

imgCounts["geno"] = genoList
print(imgCounts)

# TODO save current img counts to the counted folder as csv file with the classifier name. looks like classifier2_final.csv


# Calculate the Welch 2 Sample T-test   
groupOne = imgCounts.query('geno == @lvl_geno[0]')
groupTwo = imgCounts.query('geno == @lvl_geno[1]')
print(groupOne)

t_test_calc = scipy.stats.ttest_ind(groupOne["Counts"], groupTwo["Counts"], equal_var=False, nan_policy="omit")

print(t_test_calc)

"""""
    # Prepare output csv file
    row_row = pd.DataFrame([[curr_class, prec, reca, F1, F1_g_tt_p, mean_F1_gp, mean_F1_wt, p_g_tt_p, r_g_tt_p]], columns=["class", "prec", "reca", "F1", "F1_g_tt_p", "mean_F1_gp", "mean_F1_wt", "p_g_tt_p", "r_g_tt_p"])
    your_boat = your_boat.append(row_row)



currTime = time.localtime(time.time())
#generating a unique file name based on time and date
date = str(currTime.tm_mday) + "-" + str(currTime.tm_hour) + "-" + str(currTime.tm_min) + "-" + str(currTime.tm_sec)

out_name = "Full_Dataset_Results_" + date + ".csv"

#write.csv(your_boat, paste(result_out,out_name, sep = ""))
your_boat.to_csv(result_out + out_name)
"""