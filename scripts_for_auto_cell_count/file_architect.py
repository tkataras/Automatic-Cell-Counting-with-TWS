# -*- coding: utf-8 -*-
"""
Created on Fri Oct 22 09:25:36 2021

@author: Theo, Tyler
File architect: creates the correct number of classifier folders in output folders
"""
import os
import sys

# Method to change working directory from inputted ImageJ Macro
currDir = os.getcwd()
def setDir(arg1):
    currDir = arg1
    os.chdir(currDir)
setDir(sys.argv[1])

if len(sys.argv) == 3:
    class_list_pre_trim = []
    class_list_pre_trim.append(sys.argv[2])

    #set the location of the source folder where the folder is installed. 
    SOURCE = "../training_area/testing_area/"
    CLASS_ORIGIN =  SOURCE + "Classifiers/"
else:
    #set the location of the source folder where the folder is installed. 
    SOURCE = "../training_area/"
    #locate classifiers
    CLASS_ORIGIN =  SOURCE + "Classifiers/"
    #determing the number of classifiers
    class_list_pre_trim = os.listdir(CLASS_ORIGIN)

print("in file architect py")


type(class_list_pre_trim)


#trim the classifier names of the ".model" at the end
class_list = []
for x in class_list_pre_trim:
    name = x.split('.model')
    class_current = [(name[0])]
    class_list += class_current
print(class_list)
    
#make folders in locations
OUTPUT = SOURCE + "Weka_Output/"
OUTPUT_thresh = SOURCE + "Weka_Output_Thresholded/"
OUTPUT_project = SOURCE + "Weka_Output_Projected/"
OUTPUT_count = SOURCE + "Weka_Output_Counted/"

    
#create classifier folders in each prescribed location
for class_ID in class_list:
    print(class_ID)
    os.mkdir(OUTPUT + class_ID)
    os.mkdir(OUTPUT_thresh + class_ID)
    os.mkdir(OUTPUT_project + class_ID)
    os.mkdir(OUTPUT_count + class_ID)