# -*- coding: utf-8 -*-
"""
Created on Fri Oct 22 09:25:36 2021

@author: Theo, Tyler
File architect: creates the correct number of classifier folders in output folders
"""
import os
import sys

print("Starting file_architect.py")
# Method to change working directory from inputted ImageJ Macro
currDir = os.getcwd()
def setDir(arg1):
    currDir = arg1
    os.chdir(currDir)
setDir(sys.argv[1])

test_stage = False
if len(sys.argv) == 3:
    class_list_pre_trim = []
    class_list_pre_trim.append(sys.argv[2])

    #set the location of the source folder where the folder is installed. 
    SOURCE = "../training_area/testing_area/"
    CLASS_ORIGIN =  SOURCE + "Classifiers/"
    test_stage = True
else:
    #set the location of the source folder where the folder is installed. 
    SOURCE = "../training_area/"
    #locate classifiers
    CLASS_ORIGIN =  SOURCE + "Classifiers/"
    #determing the number of classifiers
    class_list_pre_trim = os.listdir(CLASS_ORIGIN)

#trim the classifier names of the ".model" at the end
class_list = []
for x in class_list_pre_trim:
    name = x.split('.model')
    class_current = [(name[0])]
    class_list += class_current
print(class_list)
    
#make folders in locations
OUTPUT = SOURCE + "Weka_Output/"
OUTPUT_prob = SOURCE + "Weka_Probability/"
OUTPUT_prob2 = SOURCE + "Weka_Probability_Projected/"
OUTPUT_thresh = SOURCE + "Weka_Output_Thresholded/"
OUTPUT_project = SOURCE + "Weka_Output_Projected/"
OUTPUT_count = SOURCE + "Weka_Output_Counted/"

#create classifier folders in each prescribed location if it doesn't already exist
for class_ID in class_list:
    print(class_ID)
    if not os.path.isdir(OUTPUT + class_ID):
        os.mkdir(OUTPUT + class_ID)
    if not os.path.isdir(OUTPUT_prob + class_ID):
        os.mkdir(OUTPUT_prob + class_ID)    
    if not os.path.isdir(OUTPUT_prob2 + class_ID):
        os.mkdir(OUTPUT_prob2 + class_ID)    
    if not os.path.isdir(OUTPUT_thresh + class_ID):
        os.mkdir(OUTPUT_thresh + class_ID)
    if not os.path.isdir(OUTPUT_project + class_ID):
        os.mkdir(OUTPUT_project + class_ID)
    if not os.path.isdir(OUTPUT_count + class_ID):
        os.mkdir(OUTPUT_count + class_ID)


# Generate classifier subfolders for audit directories
if test_stage:
    if not os.path.isdir(SOURCE + "Audit_Images/"):
        os.mkdir(SOURCE + "Audit_Images/")
    if not os.path.isdir(SOURCE + "Audit_Images/" + class_list[0]):
        os.mkdir(SOURCE + "Audit_Images/" + class_list[0])

    if not os.path.isdir(SOURCE + "Audit_Hand_Counts/"):
        os.mkdir(SOURCE + "Audit_Hand_Counts/")
    if not os.path.isdir(SOURCE + "Audit_Hand_Counts/" + class_list[0]):
        os.mkdir(SOURCE + "Audit_Hand_Counts/" + class_list[0])

    if not os.path.isdir(SOURCE + "Audit_Counted/"):
        os.mkdir(SOURCE + "Audit_Counted/")
    if not os.path.isdir(SOURCE + "Audit_Counted/" + class_list[0]):
        os.mkdir(SOURCE + "Audit_Counted/" + class_list[0])
    
print("Finished file_architect.py")