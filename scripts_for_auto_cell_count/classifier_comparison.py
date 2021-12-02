#!/usr/bin/python
###
# Author: Tyler Jang, Theo Kataras
# Date 12/1/2021
#
# Inputs: genotype csv file, hand count results file from count over roi, results of count over dir in each classifier folder 
# Outputs: csv table with accuracy measurements for each classifier
# Description: This file compares statistical information about each classifier against each other
###
import pandas as pd
import numpy as np
import os
import sys
import time
import scipy.stats

print("Start of classifier_comparison.py\n")
# Method to change working directory from inputted ImageJ Macro
curr_dir = os.getcwd()
def setDir(arg1):
    curr_dir = arg1
    os.chdir(curr_dir)
setDir(sys.argv[1])

# Input the genotype data as a .csv file
geno_file = "../training_area/genotype.csv"

# File output location
# TODO I just changed this to work with the probability data, so the files will end up in the projected probability folders
output_count = "../training_area/Weka_Output_Counted/"
result_out = "../training_area/Results/"

# Get the list of classifiers
class_list = os.listdir(output_count)

# Holds all accuracy values for classifiers
your_boat = pd.DataFrame(columns=["class", "prec", "reca", "F1", "F1_geno_ttest_pval", "mean_F1_ev0", "mean_F1_ev1", "perc_geno_ttest_pval", "recall_geno_ttest_pval"]) 

# Getting in the results of count_from_roi.ijm
hand_ini = pd.read_csv("../training_area/Results/roi_counts.csv", usecols=['Label'])
lvl_h = np.unique(hand_ini)
count_h = {}
for i in range(0, len(hand_ini)):
    if count_h.get(hand_ini.loc[i].at["Label"]) == None:
        count_h[hand_ini.loc[i].at["Label"]] = 1
    else:
        count_h[hand_ini.loc[i].at["Label"]] = count_h[hand_ini.loc[i].at["Label"]] + 1

# Iterate through each classifier 
for f in range(0, len(class_list)):
    curr_class = os.listdir(output_count)[f]
    class_res_loc = output_count + curr_class + "/" + curr_class + "_Results.csv"
    class_results = pd.read_csv(class_res_loc)

    ## If else loop for determining true positive, false positive and false negative cell counts
    ## from levels present in the classifier results output, this should be the same each time, BUT IT WoNT BE IF ONE IMAGE HAS NO CELL OBJECtS
    ## need to go into the counted folder and pull out all image names, meaning ignorming the Results.csv files. images from tru_count with be .png
    folder_loc = output_count + curr_class
    img_names = []
    for image in os.listdir(folder_loc):
        if image[-4:] == ".png" or image[-4:] == ".jpg" or image[-5:] == ".tiff":
            img_names.append(image)

    # Dataframe to store the results of autocounting performance
    final_result = pd.DataFrame(columns=["name", "tp", "fp", "fn", "avg_area", "avg_circularity"])
    
    # Go through each image to see how the classifier performed on that image
    for image in range(0, len(img_names)):
        current_img_plus_png = img_names[image]
        
        # Get the information about the image automatic count
        dftc = class_results[class_results["Label"].isin([current_img_plus_png])]
        
        # If the images are all empty, store this images results as all zero
        if dftc.size == 0:
            name = img_names[image]
            tp = 0
            fp = 0
            fn = count_h[lvl_h[image]]
            avg_area = 0
            avg_circular = 0
            this_row = pd.DataFrame([[name, tp, fp, fn, avg_area, avg_circular]], columns=["name", "tp", "fp", "fn", "avg_area", "avg_circularity"])
        else: 
            # Else images contain information, get the resulting automatic count information
            fp = 0
            tp = 0
            fn = 0
            avg_area = np.mean(dftc["Area"])
            avg_circular = np.mean(dftc["Circ."])
            for auto_count in (dftc["points"]):
                if auto_count == 0:
                    fp = fp + 1
                elif auto_count == 1:
                    tp = tp + 1
                else:
                    tp = tp + 1
                    fn = fn + auto_count - 1
        
        # For each image add total number hand count - sum(dftc$points), the sum points must always be less than count_h$count 
        # dtfc$points only counts the markers that fall within cell objects, count_h$counts is the sum of all points in total. 
        # When this is not true(e.g. there are negative values) check the image names of the hand count!!
        # TODO print statement for this above comment
        missed = count_h[lvl_h[image]] - sum(dftc["points"]) 
        fn = fn + missed
        name = img_names[image]

        # Store data for final result
        this_row = pd.DataFrame([[name, tp, fp, fn, avg_area, avg_circular]], columns=["name", "tp", "fp", "fn", "avg_area", "avg_circularity"])
        final_result = final_result.append(this_row)
            
    # Method to catch divide by zeros 
    def catchDivideByZero(numer, denom):
        try:
            return numer/denom
        except ZeroDivisionError:
            return None
    # Need to calculate precision and recall
    total_tp = sum(final_result["tp"])
    total_fp = sum(final_result["fp"])
    total_fn = sum(final_result["fn"])

    # Accuracy = tp / (tp + fp + fn)
    accuracy = catchDivideByZero(total_tp, total_tp + total_fp + total_fn)
    # Precision = tp/(tp + fp)
    prec = catchDivideByZero(total_tp, total_tp + total_fp)
    # Recall = tp/(tp + fn)
    reca = catchDivideByZero(total_tp, total_tp + total_fn)
    # F1 = 2 * (percision * recall / percision + recall)
    result = catchDivideByZero(prec*reca, prec + reca)
    if result == None:
        F1 = None
    else:
        F1 = 2 * result
    
    # Absolute Error = (tp + fn) - (tp + fp)
    mean_absolute_error = ((total_tp + total_fn) - (total_tp + total_fp)) / len(img_names)

    # Percent Error = ((tp + fn) - (tp + fp)) / (tp + fn)
    mean_percent_error = (((total_tp + total_fn) - (total_tp + total_fp)) / (total_tp + total_fn)) / len(img_names)

    # Print resulting values to the log
    print(curr_class + " percision = " +  str(prec))
    print(curr_class + " recall = " +  str(reca))
    print(curr_class + " accuracy = " +  str(accuracy))
    print(curr_class + " F1 = " +  str(F1))
    print(curr_class + " mean absolute error = " +  str(mean_absolute_error))
    print(curr_class + " mean percent error = " +  str(mean_percent_error))

    # Writes out the final file to save the output
    file_out_name = output_count + "/" + class_list[f] + "/" + curr_class + "_Final.csv"
    final_result.to_csv(file_out_name)
  
    # Add genotypes to csv file
    geno = pd.read_csv(geno_file)
    lvl_geno = np.unique(geno)
    geno_list = []
    for num_rows in range(0, len(final_result["name"])):
        geno_list.append(geno["geno"][num_rows])
    final_result["geno"] = geno_list
  
    # Precision and recall per image
    prec2 = final_result["tp"]/(final_result["tp"] + final_result["fp"])    
    reca2 = final_result["tp"]/(final_result["tp"] + final_result["fn"])
    
    # Calculate F1_2
    F1_2 = []
    for index in range(0, len(prec2)):
        result = catchDivideByZero(list(prec2)[index] * list(reca2)[index], list(prec2)[index] + list(reca2)[index])
        if result == None:
            F1_2.append(None)
        else:
            F1_2.append(2 * result)
    # Insert prec2, reca2, and F1_2 into final blah
    final_result["prec2"] = prec2
    final_result["reca2"] = reca2
    final_result["F1_2"] = F1_2
    
    # Find the standard deviation of percision and recall
    print(curr_class + " percision standard deviation = " + str(np.std(prec2)))
    print(curr_class + " recall standard deviation = " + str(np.std(reca2)) + "\n")   

    if len(lvl_geno) != 2:
        print("Automatic analysis can only be done with 2 levels, for alterative analysis use _Final.csv files in classifier folders")
        print("Program will default to the first two levels for analysis")

    # Calculate the Welch 2 Sample T-test   
    group_one = final_result.query('geno == @lvl_geno[0]')
    group_two = final_result.query('geno == @lvl_geno[1]')

    perc_geno_ttest = scipy.stats.ttest_ind(group_one["prec2"], group_two["prec2"], equal_var=False, nan_policy="omit")
    reca_geno_ttest = scipy.stats.ttest_ind(group_one["reca2"], group_two["reca2"], equal_var=False, nan_policy="omit")
    F1_geno_ttest = scipy.stats.ttest_ind(group_one["F1_2"], group_two["F1_2"], equal_var=False, nan_policy="omit")
    
    # Get the p values of each T test
    perc_geno_ttest_pval = perc_geno_ttest[1]
    recall_geno_ttest_pval = reca_geno_ttest[1]
    F1_geno_ttest_pval = F1_geno_ttest[1]

    # Get means of F1_2
    mean_F1_ev0 = np.nanmean(group_one["F1_2"])
    mean_F1_ev1 = np.nanmean(group_two["F1_2"])

    # Prepare output csv file
    row_row = pd.DataFrame([[curr_class, prec, reca, F1, F1_geno_ttest_pval, mean_F1_ev0, mean_F1_ev1, perc_geno_ttest_pval, recall_geno_ttest_pval]], columns=["class", "prec", "reca", "F1", "F1_geno_ttest_pval", "mean_F1_ev0", "mean_F1_ev1", "perc_geno_ttest_pval", "recall_geno_ttest_pval"])
    your_boat = your_boat.append(row_row)

# Generating a unique result file based on time and date
curr_time = time.localtime(time.time())
date = str(curr_time.tm_mday) + "-" + str(curr_time.tm_hour) + "-" + str(curr_time.tm_min) + "-" + str(curr_time.tm_sec)
out_name = "All_classifier_Comparison_" + date + ".csv"
your_boat.to_csv(result_out + out_name)

print("End of classifier_comparison.py")