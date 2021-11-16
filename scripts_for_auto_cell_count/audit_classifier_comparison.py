#!/usr/bin/python
###
# Author: Tyler Jang, Theo Kataras
# Date 11/16/2021
#
# Inputs: 
# Outputs: 
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

# Get the selected classifier 
selectedClassifier = sys.argv[2]

# Input the genotype data as a .csv file
geno_file = "../training_area/testing_area/geno_audit.csv"

# Input Hand Counts
hand_count_dir = "../training_area/testing_area/Audit_Hand_Counts/"

# File output location
OUTPUT_count = "../training_area/testing_area/Weka_Output_Counted/" + selectedClassifier + "/"
result_out = "../training_area/testing_area/"

class_list = os.listdir(OUTPUT_count)

# Dataframe to store results
your_boat = pd.DataFrame(columns=["class", "prec", "reca", "F1", "F1_g_tt_p", "mean_F1_gp", "mean_F1_wt", "p_g_tt_p", "r_g_tt_p"]) #holds all accuracy values for classifiers

### adding in the results of the hand_count_from_roi.ijm, this will not change by folder, and is generated manually by saving results in Imagej from Count ROI
hand_ini = pd.read_csv("../training_area/testing_area/Audit_Hand_Counts/roi_counts.csv", usecols=['Label'])
lvl_h = np.unique(hand_ini)
count_h = {}
for i in range(0, len(hand_ini)):
    if count_h.get(hand_ini.loc[i].at["Label"]) == None:
        count_h[hand_ini.loc[i].at["Label"]] = 1
    else:
        count_h[hand_ini.loc[i].at["Label"]] = count_h[hand_ini.loc[i].at["Label"]] + 1
hand_final = count_h

class_res_loc = hand_count_dir + selectedClassifier + "/" + selectedClassifier + "_testing_Results.csv"
class_results = pd.read_csv(class_res_loc)

print(class_results)
##if else loop for determining true positive, false positive and false negative cell counts
##from levels present in the classifier results output, this should be the same each time, BUT IT WoNT BE IF ONE IMAGE HAS NO CELL OBJECtS
##need to go into the counted folder and pull out all image names, meaning ignorming the Results.csv files. images from tru_count with be .png
files = []
for image in os.listdir(OUTPUT_count):
    if image[-4:] == ".png":
        files.append(image)

final_blah = pd.DataFrame(columns=["name", "tp", "fp", "fn", "avg_area", "avg_circularity"])

for image in range (0, len(files)):
    current_img = files[image]
    print(current_img)
    dftc = class_results[class_results["Label"].isin([current_img])]
    print(dftc)
    # If the images are all empty
    if dftc.size == 0:
        name = files[image]
        tp = 0
        fp = 0
        fn = count_h[lvl_h[image]]
        avg_area = 0
        avg_circular = 0
        this_row = pd.DataFrame([[name, tp, fp, fn, avg_area, avg_circular]], columns=["name", "tp", "fp", "fn", "avg_area", "avg_circularity"])
    else: 
        fp = 0
        tp = 0
        fn = 0

print("Finished Audit Classifier Comparison")