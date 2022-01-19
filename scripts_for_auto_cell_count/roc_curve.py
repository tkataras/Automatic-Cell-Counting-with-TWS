#!/usr/bin/python
###
# Author: Tyler Jang, Theo Kataras
# Date: 1/19/2021
# 
#
# Inputs: 
# Outputs: 
###
from unittest import result
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import os
import sys
import time
import scipy.stats

from sklearn.datasets import make_classification
from sklearn.neighbors import KNeighborsClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import roc_curve
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
for i in range(0, len(results)):
    row_name = results.loc[i].at["Label"]
    row_name = row_name.split(":")[0]
    label_col.append(row_name)

results["Label"] = label_col

def plot_roc_curve(fpr, tpr):
    plt.plot(fpr, tpr, color='orange', label='ROC')
    plt.plot([0, 1], [0, 1], color='darkblue', linestyle='--')
    plt.xlabel('False Positive Rate')
    plt.ylabel('True Positive Rate')
    plt.title('Receiver Operating Characteristic (ROC) Curve')
    plt.legend()
    plt.show()

binary_y = np.array(results["points"])
y_score = np.array(results["Mean"])

fpr, tpr, thresholds = roc_curve(binary_y, y_score, pos_label=0)
print(fpr)
print(tpr)
print(thresholds)

plt.plot(fpr, tpr, marker=".", label="ROC Curve")
# Axis labels
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')
plt.legend()
plt.show()