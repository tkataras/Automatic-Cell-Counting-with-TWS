#!/usr/bin/python
###
# Author: Tyler Jang, Theo Kataras
# Date 2/9/2022
#
# Inputs: genotype csv file, hand count results file from count over roi,
# results of count over dir in each classifier folder. 
# Outputs: csv table with accuracy measurements for each classifier.
# Description: This file compares statistical information about each classifier
# against each other.
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
def set_dir(arg1):
    curr_dir = arg1
    os.chdir(curr_dir)
set_dir(sys.argv[1])

# Input the genotype data as a .csv file
geno_file = "../training_area/genotype.csv"

# File output location
output_count = "../training_area/Weka_Output_Counted/"
result_out = "../training_area/Results/"

# Get the list of classifiers
class_list = os.listdir(output_count)

# Holds all accuracy values for classifiers
result_summary_file = pd.DataFrame(columns=["class", "precision", "recall", "F1", "accuracy", "MAE", "MPE"]) 

# Getting in the results of count_from_roi.ijm
hand_ini = pd.read_csv("../training_area/Results/roi_counts.csv", usecols=['Label'])

# Reformat ROI names for use by selecting file name only, removing point name
for i in range(0, len(hand_ini)):
    row_name = hand_ini.loc[i].at["Label"]
    row_name = row_name.split(":")[0]
    row_name = row_name.split(".")[0]
    hand_ini.loc[i, "Label"] = row_name

# Get the unique image names
lvl_h = np.unique(hand_ini)

# TODO May mess with non fluoset names
lvl_h = sorted(lvl_h, key=str.swapcase)

# Get the hand counts for each unique image
count_h = {}
for i in range(0, len(hand_ini)):
    if count_h.get(hand_ini.loc[i].at["Label"]) == None:
        # Start the count at 0 since there is 1 more line than hand counts in the file to represent the full image
        count_h[hand_ini.loc[i].at["Label"]] = 0
    else:
        count_h[hand_ini.loc[i].at["Label"]] = count_h[hand_ini.loc[i].at["Label"]] + 1

# Iterate through each classifier 
for f in range(0, len(class_list)):
    curr_class = os.listdir(output_count)[f]
    class_res_loc = output_count + curr_class + "/" + curr_class + "_Results.csv"
    class_results = pd.read_csv(class_res_loc)

    # Replace label column to remove file extensions and point
    for row in range(0, len(class_results)):
        row_name = class_results.loc[row, "Label"]
        row_name = row_name.split(":")[0]
        row_name = row_name.split(".")[0]
        class_results.loc[row, "Label"] = row_name

    # Store the images that were counted by the classifiers
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

        # Get the file itself without extension
        current_img_plus_png = current_img_plus_png.split(".")[0]

        # Get the information about the image automatic count
        dftc = class_results[class_results["Label"].isin([current_img_plus_png])]
        
        # Remove the row representing the full image
        dftc = dftc.iloc[:-1,:]

        # If the image is all empty, store this images results as all zero
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

            # Count points, except last row for overall image
            for auto_count in (dftc["points"]):   
                if auto_count == 0:
                    fp = fp + 1
                elif auto_count == 1:
                    tp = tp + 1
                else:
                    tp = tp + 1
                    fn = fn + auto_count - 1
        
        # Find the number of hand counts that were missed and add it to false negatives
        if dftc.size != 0:
            missed = count_h[lvl_h[image]] - sum(dftc["points"]) 
            fn = fn + missed      
            name = img_names[image]

        # Store data for final result
        this_row = pd.DataFrame([[name, tp, fp, fn, avg_area, avg_circular]], columns=["name", "tp", "fp", "fn", "avg_area", "avg_circularity"])
        final_result = final_result.append(this_row)
            
    # Method to catch divide by zeros 
    def catchDivideByZero(numer, denom):
        try:
            # Don't print the error message to stderr
            with np.errstate(divide='ignore', invalid='ignore'):
                return numer/denom
        except ZeroDivisionError:
            # Divide dataframe elements by elements that are not 0, those that are will be None values
            if isinstance(numer, pd.Series) and isinstance(denom, pd.Series):
                numer = list(numer)
                denom = list(denom)

                # Don't print the error message for the where statement evaluation
                with np.errstate(divide='ignore', invalid='ignore'):
                    return np.divide(numer, denom, out=None, where=(denom!=0))
            return None
    
    # Calculate the total precision and recall
    total_tp = sum(final_result["tp"])
    total_fp = sum(final_result["fp"])
    total_fn = sum(final_result["fn"])

    # Accuracy = tp / (tp + fp + fn)
    accuracy = catchDivideByZero(total_tp, total_tp + total_fp + total_fn)
    # Precision = tp/(tp + fp)
    precision = catchDivideByZero(total_tp, total_tp + total_fp)
    # Recall = tp/(tp + fn)
    recall = catchDivideByZero(total_tp, total_tp + total_fn)
    # F1 = 2 * (percision * recall / percision + recall)
    if precision != None and recall != None:
        result = catchDivideByZero(precision*recall, precision + recall)
    else:
        result = None    
    if result == None:
        F1 = None
    else:
        F1 = 2 * result
    
    # Absolute Error = (tp + fn) - (tp + fp)
    mean_absolute_error = ((total_tp + total_fn) - (total_tp + total_fp)) / len(img_names)

    # Percent Error = ((tp + fn) - (tp + fp)) / (tp + fn)
    mean_percent_error = (((total_tp + total_fn) - (total_tp + total_fp)) / (total_tp + total_fn)) / len(img_names)

    # Print resulting values to the log
    print(curr_class + " percision = " +  str(precision))
    print(curr_class + " recall = " +  str(recall))
    print(curr_class + " F1 = " +  str(F1))
    print(curr_class + " accuracy = " +  str(accuracy))
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
    precision2 = catchDivideByZero(final_result["tp"], (final_result["tp"] + final_result["fp"]))    
    recall2 = catchDivideByZero(final_result["tp"], (final_result["tp"] + final_result["fn"]))
    
    # Error handling to ensure type conversion from pandas series to numpy ndarray of numpy float64s
    if isinstance(precision2, pd.Series):
        precision2 = precision2.to_numpy(dtype=np.float64)
    if isinstance(recall2, pd.Series):
        recall2 = recall2.to_numpy(dtype=np.float64)
    
    if precision2 is not None and recall2 is not None:
        # Calculate F1_2
        F1_2 = []
        for index in range(0, len(precision2)):
            result = catchDivideByZero(list(precision2)[index] * list(recall2)[index], list(precision2)[index] + list(recall2)[index])
            if result == None:
                F1_2.append(None)
            else:
                F1_2.append(2 * result)
    else: 
        F1_2 = None

    # Error handling to ensure type conversion from pandas series to numpy ndarray of numpy float64s
    if isinstance(F1_2, pd.Series):
        F1_2 = F1_2.to_numpy(dtype=np.float64)

    # Insert precision2, recall2, and F1_2 into final csv
    final_result["precision2"] = precision2
    final_result["recall2"] = recall2
    final_result["F1_2"] = F1_2
        
    # Find the standard deviation of percision and recall
    if precision2 is not None:
        print(curr_class + " percision standard deviation = " + str(np.nanstd(precision2)))
    else:
        print(curr_class + " percision standard deviation = None")

    if recall2 is not None:
        print(curr_class + " recall standard deviation = " + str(np.nanstd(recall2)))   
    else:
        print(curr_class + " recall standard deviation = None")   

    # If only 1 level
    if len(lvl_geno) == 1:
        group_one = final_result.query('geno == @lvl_geno[0]')
        
        # Calculate 1 Sample T Test
        precision_mean = np.mean(group_one["precision2"])
        recall_mean = np.mean(group_one["recall2"])
        F1_mean = np.mean(group_one["F1_2"])

        precision_geno_ttest = None
        recall_geno_ttest = None 
        F1_geno_ttest = None

        # TODO remove the 1 sample T test since it only matters when user expects an expected mean
        # TODO I don't know what the popmean should be equal to, what is the expected mean of our pop vs actual mean
        if precision2 is not None:
            precision_geno_ttest = scipy.stats.ttest_1samp(group_one["precision2"], popmean=1, nan_policy="omit")
            print("Precision T Test " + str(precision_geno_ttest))
        if recall2 is not None:
            recall_geno_ttest = scipy.stats.ttest_1samp(group_one["recall2"], popmean=1, nan_policy="omit")
            print("Recall T Test " + str(recall_geno_ttest))
        if F1_2 is not None:
            F1_geno_ttest = scipy.stats.ttest_1samp(group_one["F1_2"], popmean=1, nan_policy="omit")
            print("F1 T Test " + str(F1_geno_ttest) + "\n")

        # TODO also write the F values out to log
        precision_geno_ttest_pval = None
        recall_geno_ttest_pval = None
        F1_geno_ttest_pval = None

        # Get the p values of each T test
        if precision2 is not None:
            precision_geno_ttest_pval = precision_geno_ttest[1]
        if recall2 is not None:
            recall_geno_ttest_pval = recall_geno_ttest[1]
        if F1_2 is not None:
            F1_geno_ttest_pval = F1_geno_ttest[1]

        # Get means of F1_2
        mean_F1_ev0 = None
        if F1_2 is not None:
            mean_F1_ev0 = np.nanmean(group_one["F1_2"])
  
        # Prepare output csv file
        row_row = pd.DataFrame([[curr_class, precision, recall, F1, accuracy, \
        mean_absolute_error, mean_percent_error, mean_F1_ev0, \
        precision_geno_ttest_pval, recall_geno_ttest_pval, \
        F1_geno_ttest_pval]], columns=["class", "precision", "recall", "F1",\
        "accuracy", "MAE", "MPE", "mean_F1_ev0", \
        "precision_geno_ttest_pval", "recall_geno_ttest_pval", \
        "F1_geno_ttest_pval"])
        
        result_summary_file = result_summary_file.append(row_row)
       
    # Else, if more than two levels
    elif len(lvl_geno) > 2:
        print("Automatic analysis with more than 2 levels")
        # Create as many groups as there are levels
        group_n = []
        precision_df = pd.DataFrame(index=range(len(geno_list)), columns=lvl_geno)
        recall_df = pd.DataFrame(index=range(len(geno_list)), columns=lvl_geno)
        F1_df = pd.DataFrame(index=range(len(geno_list)), columns=lvl_geno)

        # Set up ANOVA calculation
        for index in range(0, len(lvl_geno)):
            # Get the current condition
            curr_group = lvl_geno[index]
            group_n.append(final_result.query('geno == @curr_group'))

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
  
        # Store results in output csv file
        row_row = pd.DataFrame([[curr_class, precision, recall, F1, accuracy, mean_absolute_error, mean_percent_error, precision_f_val, precision_p_val, recall_f_val, recall_p_val, F1_f_val, F1_p_val]], columns=["class", "precision", "recall", "F1", "accuracy", "MAE", "MPE", "precision_F_value", "precision_P_value", "recall_F_value", "recall_P_value", "F1_F_value", "F1_P_value"])
        result_summary_file = result_summary_file.append(row_row)

    # Else there are only two levels
    else:    
        print()
        # Calculate the Welch 2 Sample T-test   
        group_one = final_result.query('geno == @lvl_geno[0]')
        group_two = final_result.query('geno == @lvl_geno[1]')
        precision_geno_ttest = None
        precision_geno_ttest_pval = None
        recall_geno_ttest = None 
        recall_geno_ttest_pval = None
        F1_geno_ttest = None
        F1_geno_ttest_pval = None
        
        if precision2 is not None:
            precision_geno_ttest = scipy.stats.ttest_ind(group_one["precision2"], group_two["precision2"], equal_var=False, nan_policy="omit")
            precision_geno_ttest_pval = precision_geno_ttest[1]

        if recall2 is not None:
            recall_geno_ttest = scipy.stats.ttest_ind(group_one["recall2"], group_two["recall2"], equal_var=False, nan_policy="omit")
            recall_geno_ttest_pval = recall_geno_ttest[1]

        if F1_2 is not None:
            F1_geno_ttest = scipy.stats.ttest_ind(group_one["F1_2"], group_two["F1_2"], equal_var=False, nan_policy="omit")
            F1_geno_ttest_pval = F1_geno_ttest[1]

        # Get means of F1_2
        mean_F1_ev0 = None
        mean_F1_ev1 = None
        if F1_2 is not None:
            mean_F1_ev0 = np.nanmean(group_one["F1_2"])
            mean_F1_ev1 = np.nanmean(group_two["F1_2"])

        # Prepare output csv file
        row_row = pd.DataFrame([[curr_class, precision, recall, F1, accuracy, mean_absolute_error, mean_percent_error, F1_geno_ttest_pval, mean_F1_ev0, mean_F1_ev1, precision_geno_ttest_pval, recall_geno_ttest_pval]], columns=["class", "precision", "recall", "F1", "accuracy", "MAE", "MPE", "F1_geno_ttest_pval", "mean_F1_ev0", "mean_F1_ev1", "precision_geno_ttest_pval", "recall_geno_ttest_pval"])
        result_summary_file = result_summary_file.append(row_row)

# Generating a unique result file based on time and date
curr_time = time.localtime(time.time())
date = str(curr_time.tm_mday) + "-" + str(curr_time.tm_hour) + "-" + str(curr_time.tm_min) + "-" + str(curr_time.tm_sec)
out_name = "All_Classifier_Comparison_" + date + ".csv"
result_summary_file.to_csv(result_out + out_name)

print("End of classifier_comparison.py")