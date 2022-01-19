#!/usr/bin/python
###
# Author: Tyler Jang, Theo Kataras
# Date: 1/19/2021
# 
#
# Inputs: 
# Outputs: 
###
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import os
import sys
from sklearn.metrics import f1_score, roc_curve
from sklearn.metrics import roc_auc_score

print("Start of roc_curve.py\n")
# Method to change working directory from inputted ImageJ Macro
curr_dir = os.getcwd()
def set_dir(arg1):
    curr_dir = arg1
    os.chdir(curr_dir)
set_dir(sys.argv[1])

# Get the selected classifier by the user
selectedClassifier = sys.argv[2]

# Input file 
results_file = "../training_area/Weka_Output_Counted/" + selectedClassifier + "/" + selectedClassifier + "_Results.csv"
results = pd.read_csv(results_file)
# Output location
result_out = "../training_area/Results/"

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

results["Label"] = label_col

#print(results)
#results.to_csv("test.csv")

# Get the true or false count
binary_y = np.array(results["points"])
# Need to mark 2 as a 1 so it is not a multiclass array 
binary_y[binary_y == 2] = 1

y_score = np.array(results["Mean"])

# NOTE in the method implementation, threshold will be made to have a value of max(y_score) + 1 to ensure it has a data point that is fpr, tpr = 0
fpr, tpr, thresholds = roc_curve(binary_y, y_score, pos_label=1, drop_intermediate=False)

print(thresholds)
auc = roc_auc_score(binary_y, y_score, multi_class="ovo")
print("AUC = " + str(auc))
#precision = tpr / (tpr + fpr)
#recall = tpr / 
# F1 = f1_score(binary_y, y_score)
#print(F1)

plt.title("Receiver Operating Characteristic")
plt.plot(thresholds, fpr, color="blue", marker=".", label="False Positive")
plt.plot(thresholds, tpr, color="red", marker=".", label="True Positive")

# Set x axis limit
plt.xlim([0.5, 1])
# Axis labels
plt.xlabel('Threshold')
plt.ylabel('Rate')
plt.legend()
plt.show()

plt.savefig("roc_curve.png")
print("Finished roc_curve.py\n")
