#!/usr/bin/python
###
# Author: Tyler Jang, Theo Kataras
# Date: 4/21/2022
#
# Inputs: Results csv file containing the probability of each object
# Outputs: A plot for threshold optimization and a ROC plot.
# This file creates a threshold optimization and ROC curve plot for each classifier 
###
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import os
import sys
from sklearn.metrics import average_precision_score, precision_recall_curve, roc_curve, roc_auc_score

print("Start of roc_curve.py\n")
# Method to change working directory from inputted ImageJ Macro
curr_dir = os.getcwd()
def set_dir(arg1):
    curr_dir = arg1
    os.chdir(curr_dir)
set_dir(sys.argv[1])

# Input and Output location
result_out = "../training_area/Weka_Output_Counted/"
class_list = os.listdir(result_out)

# Generate a plot for every ROC
for selectedClassifier in class_list:
    print(selectedClassifier)
    # Input file 
    results_file = result_out + selectedClassifier + "/" + selectedClassifier + "_Results.csv"
    results = pd.read_csv(results_file)

    # File with the false negative information
    false_negative_file = result_out + selectedClassifier + "/" + selectedClassifier + "_Final.csv"

    # Reformat ROI names for use by selecting file name only, removing point name
    label_col = []
    to_delete = []
    for i in range(0, len(results)):
        row_name = results.loc[i].at["Label"]
        row_name = row_name.split(":")

        # Remove the one line to represent the image
        if len(row_name) == 1:
            to_delete.append(i)
        else:
            row_name = row_name[0]
            label_col.append(row_name)

    # Remove lines representing a whole image      
    results = results.drop(index = to_delete)

    # Rename labels without their point name
    results["Label"] = label_col

    # Get the number of false negatives
    false_neg_dataframe = pd.read_csv(false_negative_file)
    false_neg = false_neg_dataframe["fn"]
    total_false_neg = false_neg.sum()
    
    # Represent the false negatives as their own rows in the dataframe
    for increment in range(0, total_false_neg):
        new_row = pd.DataFrame([["hello there", 0, 1]], columns=["Label", "Mean", "points"])
        results = pd.concat([results, new_row], ignore_index=True)

    # Get the true or false autocount
    binary_y = np.array(results["points"])

    # Handle the only empty image case, and 100% true positive case
    if len(np.unique(binary_y)) == 1:
        print("Only positive or negative samples in the result, no graph generated")
        continue

    # Need to mark 2 as a 1 so it is not a multiclass array 
    binary_y[binary_y >= 2] = 1

    y_score = np.array(results["Mean"])

    # NOTE in the method implementation, threshold will be made to have a value of max(y_score) + 1 to ensure it has a data point that is fpr, tpr = 0
    fpr, tpr, thresholds = roc_curve(binary_y, y_score, pos_label=1, drop_intermediate=False)

    # Calculate the area under the curve
    if len(np.unique(binary_y)) == 1:
        print("No false positives, or only false positives. Skipping AUC calculation")
    else:
        auc = roc_auc_score(binary_y, y_score, multi_class="ovo")
        print("AUC = " + str(auc))

    # Calculate Precision and Recall
    # NOTE This doesn't have drop intermediate functionality=False, so it only shows thresholds that lead to good results, thus the graphs have different number of thresholds
    precision, recall, pr_thresholds = precision_recall_curve(binary_y, y_score, pos_label=1)

    # Average precision recall score (AP)
    # TODO this seems kinda useless
    print("AP = " + str(average_precision_score(binary_y, y_score)))

    # Method precision_recall_curve adds a single interger to the end of these arrays that must be removed
    recall = recall[0:-1]
    precision = precision[0:-1]
    
    # Plot true positive and false positive rates
    plt.figure(figsize=(9,7))
    plt.subplot(2,2,1)
    plt.title(selectedClassifier + " Threshold Optimization")
    plt.plot(thresholds, fpr, color="red", marker=".", label="False Positive")
    plt.plot(thresholds, tpr, color="blue", marker=".", label="True Positive")

    # Set axis limit
    plt.xlim([0.5, 1])
    plt.ylim([0, 1])

    # Axis labels
    plt.xlabel("Threshold")
    plt.ylabel("Rate")
    plt.legend()

    # Show the ROC Curve
    plt.subplot(2,2,2)
    plt.plot(fpr, tpr, color="blue", marker=".", label="ROC Curve")
    plt.plot([0, 1], [0, 1], linestyle="--")

    # Axis limits and labels
    plt.xlim([0, 1])
    plt.ylim([0, 1])
    plt.xlabel("False Positive Rate")
    plt.ylabel("True Positive Rate")

    # Title
    plt.title(selectedClassifier + " Receiver Operating Characteristic")

    # Plot recall vs precision for each threshold
    plt.subplot(2,2,3)
    plt.plot(pr_thresholds, recall, color="blue", marker=".", label="Recall")
    plt.plot(pr_thresholds, precision, color="red", marker=".", label="Precision")
    plt.xlabel("Threshold")
    plt.ylabel("Rate")
    plt.xlim([0.5, 1])
    plt.ylim([0, 1])
    plt.title("Recall and Precision Threshold Optimization")
    plt.legend()

    # Recall vs precision for each threshold
    plt.subplot(2,2,4)
    plt.plot(recall, precision, color="black", marker=".", label="Recall vs Precision")
    plt.title("Recall vs Precision for each threshold")
    plt.xlabel("Recall")
    plt.ylabel("Precision")
    plt.xlim([0, 1])
    plt.ylim([0, 1])

    # Create and save the graph made, then close it for saving memory
    plt.tight_layout()
    plt.savefig(result_out + selectedClassifier + "/" + selectedClassifier + "_roc_curve.pdf", bbox_inches="tight")
    plt.clf()
    plt.close()

print("\nFinished roc_curve.py")