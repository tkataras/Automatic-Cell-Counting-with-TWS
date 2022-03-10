#!/usr/bin/python
###
# Author: Theo Kataras, Tyler Jang
# Date 3/10/2022
# 
# Input: A set of thresholded, projected images
# Output: A set of merged images
# Description: This file in the pipeline merges projected images 
#              into one image so they can be counted.
###
import os
import sys
import pandas as pd
import numpy as np
import imageio

# Method: trim_names 
# Input: File names
# Output: Bisected file names based on split
# Description:useful if information in automatic file name from microscope is repetitive
###
def trim_names(file_names, half):
    #TODO isn't this to narrowly specific, file versions differ names
    delim = "_XY"
    
    # Split files from delim
    split_files = []
    for file in file_names:
        split_files.append(file.split(delim))
    
    # Get the front of back half of the split string
    newsid1 = []
    for i in range(0, len(split_files)):
        if half == "front":
            newsid1.append(split_files[i][1])
        if half == "back":
            newsid1.append(split_files[i][0])
    return newsid1

###
# Method: parse_it 
# Input: Projected image file names
# Output: List of seperated relevent name elements from every image
# Description: Gets the key identifying information for projected images so they
#              can be grouped together.
###
def parse_it(file_names, object_num):
    newsid1_anum = []
    for i in range(0, len(file_names)):
        newsid1_anum.append(file_names[i][object_num])
    return newsid1_anum

###
# Method: sep_slidebook 
# Input: file names containng all relevant image info (animal #, slice #, field #)
# Output: data frame with each type of info as it own column
# Description: parses out individual grouping variables
###
def sep_slidebook(file_names, delim):
    # Split files from delim
    split_files = []
    for file in file_names:
        split_files.append(file.split(delim))
    max_len = len(split_files[1])
    
    # These are what you need to adjust for different names of images!!!!####
    newsid1_anum = parse_it(split_files, 1)
    newsid1_snum = parse_it(split_files, 2)
    newsid1_fnum = parse_it(split_files, max_len - 1)
    
    # Sometimes another seperation step is required
    fnumsid1_s = []
    for file in newsid1_fnum:
        fnumsid1_s.append(list(file))

    newsid1_fnum1 = parse_it(fnumsid1_s, 0)
    newsid1_fnum2 = parse_it(fnumsid1_s, 1)
    # Recombine seperated objects
    newsid1_fnum3 = []
    for index in range(0, len(newsid1_fnum1)):
        newsid1_fnum3.append(newsid1_fnum1[index] + newsid1_fnum2[index])

    # Make a dataframe
    id1_df = pd.DataFrame(columns=["newsid1_anum", "newsid1_snum", "newsid1_fnum3"])
    for index in range(0, len(newsid1_anum)):
        new_row = pd.DataFrame([[newsid1_anum[index], newsid1_snum[index], newsid1_fnum3[index]]], columns=["newsid1_anum", "newsid1_snum", "newsid1_fnum3"])
        id1_df = id1_df.append(new_row)
    return id1_df

### 
# Method: squish 
# Input: data from of grouping variables
# Output: list of unique image IDs contining specific grouping information
# Description: creates one grouping object for each image that can be compared
#              across other iterations of the images with slightly different 
#              file names.
###
def squish(input_df):
    id1_df_squish = []
    m = input_df.to_numpy()
    for i in range(0, input_df.shape[0]):
        curr_str = ""
        for j in range(0, input_df.shape[1]):
            curr_str = curr_str + m[i][j] + "-"
        id1_df_squish.append(curr_str)

    # Convert list to dataframe
    id1_df_squish_df = pd.DataFrame(columns=["id1_df_squish"])
    for index in range(0, len(id1_df_squish)):
        new_row = pd.DataFrame([[id1_df_squish[index]]], columns=["id1_df_squish"])
        id1_df_squish_df = id1_df_squish_df.append(new_row)
    return id1_df_squish_df

# Start of main
print("Starting Project N images by ID.py")
# Method to change working directory from inputted ImageJ Macro
curr_dir = os.getcwd()
def set_dir(arg1):
    curr_dir = arg1
    os.chdir(curr_dir)
set_dir(sys.argv[1])

first_stage = True
# If in the second stage of the pipeline, use the specified classifier
if len(sys.argv) == 3:
    # Input and Output file directories
    id_for_in_dir = "../training_area/testing_area/Weka_Output_Thresholded/" + sys.argv[2] + "/"
    id_for_out_dir = "../training_area/testing_area/Weka_Output_Projected/" + sys.argv[2] + "/"
    first_stage = False
else:
    # Input and Output file directories
    id_for_in_dir = "../training_area/Weka_Output_Thresholded/"
    id_for_out_dir = "../training_area/Weka_Output_Projected/"

if first_stage:
    # Get the classifiers/files contained in these directories
    in_dir_list = os.listdir(id_for_in_dir)
    file_list = os.listdir(id_for_in_dir + "/" + in_dir_list[1] +"/")
    out_dir_list = os.listdir(id_for_out_dir)

    # Getting images names, can pick any folder with all images in question to do this
    newsid1 = file_list
    id1_df_sep = sep_slidebook(newsid1, "-")
    id1_df_squish = squish(id1_df_sep)

    # Specify: original file names, info columns, squished ID
    newsid1_df = pd.DataFrame(columns=["newsid1"])
    for index in range(0, len(newsid1)):
            new_row = pd.DataFrame([[newsid1[index]]], columns=["newsid1"])
            newsid1_df = newsid1_df.append(new_row)

    # This df gives us access to varibles based on the images in several forms
    big_df = pd.concat([newsid1_df, id1_df_squish], axis=1)
    big_df = pd.concat([big_df, id1_df_sep], axis=1)
    big_df.columns = ["File_name", "Img_ID", "A_num", "S_num", "F_num"]

    # Now need to gather all items with matching img_ID 
    u_img = np.unique(big_df["Img_ID"])

    # Project the n images in each classifier
    for image in range(0, len(in_dir_list)):
        rel_path = id_for_in_dir + in_dir_list[image]
        img_file_names = os.listdir(rel_path)
        out_loc = out_dir_list[image]
        
        # For each image of the same unique ID number
        for id in range(0, len(u_img)):
            # Identify images belonging to each unique image ID
            all_current_ID = big_df.query('Img_ID == @u_img[@id]')

            # Sum projected as equal to the number of layers in the image
            projected = 0
            max_len = all_current_ID.shape[0]
            # Project the image of the same ID onto one image
            for k in range(0, max_len):
                path = rel_path + "/" + list(all_current_ID["File_name"])[k]
                projected = projected + imageio.imread(path)
            file_out_loc = id_for_out_dir + out_dir_list[image] + "/" + list(all_current_ID["File_name"])[0]
            imageio.imwrite(file_out_loc, projected)
# Second half of the pipeline
else:
    # Get the classifiers/files contained in these directories
    in_dir_list = os.listdir(id_for_in_dir)

    # Getting images names, can pick any folder with all images in question to do this
    newsid1 = in_dir_list
    id1_df_sep = sep_slidebook(newsid1, "-")
    id1_df_squish = squish(id1_df_sep)

    # Specify: original file names, info columns, squished ID
    newsid1_df = pd.DataFrame(columns=["newsid1"])
    for index in range(0, len(newsid1)):
            new_row = pd.DataFrame([[newsid1[index]]], columns=["newsid1"])
            newsid1_df = newsid1_df.append(new_row)

    # This df gives us access to varibles based on the images in several forms
    big_df = pd.concat([newsid1_df, id1_df_squish], axis=1)
    big_df = pd.concat([big_df, id1_df_sep], axis=1)
    big_df.columns = ["File_name", "Img_ID", "A_num", "S_num", "F_num"]

    # Now need to gather and project all items with matching img_ID 
    # Need to start working in directory that holds all image folders
    u_img = np.unique(big_df["Img_ID"])

    # Project the n images in the classifier
    for id in range(0, len(u_img)):
        # Identify images belonging to each unique image ID
        all_current_ID = big_df.query('Img_ID == @u_img[@id]')

        # Sum projected as equal to the number of layers in the image
        projected = 0
        max_len = all_current_ID.shape[0]
        # Project the image of the same ID onto one image
        for k in range(0, max_len):
            path = id_for_in_dir + "/" + list(all_current_ID["File_name"])[k]
            projected = projected + imageio.imread(path)
        file_out_loc = id_for_out_dir + "/" + list(all_current_ID["File_name"])[0]
        imageio.imwrite(file_out_loc, projected)

print("Finished Projecting N images by ID")