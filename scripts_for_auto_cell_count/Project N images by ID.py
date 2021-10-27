#!/usr/bin/python
###
# Author: Theo, Tyler Jang
# Date 10/20/2021
# This file is the pipeline.....
#
###
import os
import sys
import pandas as pd

# Method: trim_names 
# Input: file names
# Output: bisected file names based on split
# Description:useful if information in automatic file name from microscope is repetitive
###
def trim_names(file_names, half):
    #TODO isn't this to narrowly specific
    delim = "_XY"
    
    # Split files from delim
    splitFiles = []
    for file in file_names:
        splitFiles.append(file.split(delim))
    
    # Get the front of back half of the split string
    newsid1 = []
    for i in range(0, len(splitFiles)):
        if half == "front":
            newsid1.append(splitFiles[i][1])
        if half == "back":
            newsid1.append(splitFiles[i][0])
    return newsid1

###
# Method: parseit 
# Input: list of seperated relevent name elements from every image
# Output: TODO
# Description: 
###
def parseit(file_names, object_num):
    newsid1_anum = []
    for i in range(0, len(file_names)):
        newsid1_anum.append(file_names[i][object_num])
    return newsid1_anum
###
# Method: Sep_slidebook 
# Input: file names containng all relevant image info (animal #, slice #, field #)
# Output: data frame with each type of info as it own column
# Description: parses out individual grouping variables
###
def sep_slidebook(file_names, delim):
    # Split files from delim
    splitFiles = []
    for file in file_names:
        splitFiles.append(file.split(delim))
    maxLen = len(splitFiles[1])
    
    # These are what you need to adjust for different names of images!!!!####
    newsid1_anum = parseit(splitFiles, 1)
    newsid1_snum = parseit(splitFiles, 2)
    newsid1_fnum = parseit(splitFiles, maxLen - 1)
    
    # Sometimes another seperation step is required
    fnumsid1_s = []
    for file in newsid1_fnum:
        fnumsid1_s.append(list(file))

    newsid1_fnum1 = parseit(fnumsid1_s, 0)
    newsid1_fnum2 = parseit(fnumsid1_s, 1)
    # Recombine seperated objects
    newsid1_fnum3 = []
    for index in range(0, len(newsid1_fnum1)):
        newsid1_fnum3.append(newsid1_fnum1[index] + newsid1_fnum2[index])

    # Make a dataframe
###
# Method: squish 
# Input: data from of grouping variables
# Output: list of unique image IDs contining specific grouping information
# Description: creates one grouping object for each image that can be compared across other iterations of the images with slightly different file names
###
def squish(input_df):
    print("squish hi")


# Start of main
# Method to change working directory from inputted ImageJ Macro
currDir = os.getcwd()
def setDir(arg1):
    currDir = arg1
    os.chdir(currDir)
setDir(sys.argv[1])

# Input and Output file directories
id_for_in_dir = "../training_area/Weka_Output_Thresholded/"
id_for_out_dir = "../training_area/Weka_Output_Projected/"

# Get the classifiers/files contained in these directories
in_dir_list = os.listdir(id_for_in_dir)
file_list = os.listdir(id_for_in_dir + "/" + in_dir_list[1] +"/")
out_dir_list = os.listdir(id_for_out_dir)


##getting images names, can pick any folder with all images in question to do this
id1 = file_list

# TODO why is it front in R?
newsid1 = trim_names(id1, half="back")
id1_df_sep = sep_slidebook(newsid1, "-")
#id1_df_squish <- squish(input_df = id1_df_sep)

