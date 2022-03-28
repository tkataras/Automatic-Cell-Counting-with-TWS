#!/usr/bin/python
###
# Author: Theo Kataras, Tyler Jang
# Date 3/10/2022
# 
# Input: A set of thresholded, projected images
# Output: A set of merged images
# Description: This file in the pipeline merges projected probability images 
#              into one image so they can be counted.
###
import os
import sys
import pandas as pd
import numpy as np
import imageio

###
# Method: trim_names 
# Input: File names
# Output: Bisected file names based on split
# Description:useful if information in automatic file name from microscope is repetitive
###
def trim_names(file_names, half):
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
    
    # These are what you need to adjust for different names of images
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
print("Starting project_probability.py")
# Method to change working directory from inputted ImageJ Macro
curr_dir = os.getcwd()
def set_dir(arg1):
    curr_dir = arg1
    os.chdir(curr_dir)
set_dir(sys.argv[1])

first_stage = True

print(len(sys.argv))
print(len(sys.argv))
# If in the second stage of the pipeline, use the specified classifier
if len(sys.argv) == 3:
    # Input and Output file directories
    id_for_in_dir = "../testing_area/Weka_Probability/" + sys.argv[2] + "/"
    id_for_out_dir = "../testing_area/Weka_Probability_Projected/" + sys.argv[2] + "/"
    first_stage = False
else:
    # Input and Output file directories
    id_for_in_dir = "../training_area/Weka_Probability/"
    id_for_out_dir = "../training_area/Weka_Probability_Projected/"

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

    # Gather all items with matching img_ID 
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

            # Projected as equal to the maximum probability at each pixel location
            path = rel_path + "/" + list(all_current_ID["File_name"])[0]
            temp_image = imageio.imread(path)
            x_axis = len(temp_image)
            y_axis = len(temp_image[0])
            projected = temp_image
            max_len = all_current_ID.shape[0]

            # Project the image of the same ID onto one image
            for k in range(0, max_len):
                path = rel_path + "/" + list(all_current_ID["File_name"])[k]
                curr_probability = imageio.imread(path)
                # For each row
                for y_inc in range(y_axis):
                    # For each column
                    for x_inc in range(x_axis):
                        if projected[x_inc][y_inc] < curr_probability[x_inc][y_inc]:
                            projected[x_inc][y_inc] = curr_probability[x_inc][y_inc]
            file_out_loc = id_for_out_dir + out_dir_list[image] + "/" + list(all_current_ID["File_name"])[0]
            imageio.imwrite(file_out_loc, projected)
            projected = [[0] * y_axis] * x_axis
# Second half of the pipeline TODO Make it project onto probability map
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

    # Gather all items with matching img_ID 
    u_img = np.unique(big_df["Img_ID"])

    # Project the n images in the classifier
    for id in range(0, len(u_img)):
        # Identify images belonging to each unique image ID
        all_current_ID = big_df.query('Img_ID == @u_img[@id]')

        # Projected as equal to the maximum probability at each pixel location
        path = id_for_in_dir + "/" + list(all_current_ID["File_name"])[0]
        temp_image = imageio.imread(path)
        x_axis = len(temp_image)
        y_axis = len(temp_image[0])
        projected = temp_image
        max_len = all_current_ID.shape[0]
        
        # Project the image of the same ID onto one image
        for k in range(0, max_len):
            path = id_for_in_dir + "/" + list(all_current_ID["File_name"])[k]
            curr_probability = projected + imageio.imread(path)
            # For each row
            for y_inc in range(y_axis):
                # For each column
                for x_inc in range(x_axis):
                    # Set the max probability of each pixel as the projected result
                    if projected[x_inc][y_inc] < curr_probability[x_inc][y_inc]:
                        projected[x_inc][y_inc] = curr_probability[x_inc][y_inc]
        # Write projected image to file output
        file_out_loc = id_for_out_dir + "/" + list(all_current_ID["File_name"])[0]
        imageio.imwrite(file_out_loc, projected)
        projected = [[0] * y_axis] * x_axis
            
print("Finished project_probability.py")