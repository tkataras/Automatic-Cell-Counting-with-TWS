#!/usr/bin/python
###
# Author: Theo Kataras, Tyler Jang
# Date: 12/10/2021
#
# Input: The source directory
#        The classifier selected by the user for the full dataset
# Output: Randomly selected images to audit placed in Audit Images and Audit Counted
# Description: This program randomly selects images to be audited by the third act of the pipeline
###
import pandas as pd
import numpy as np
import os
import sys
import random

###
# Method: parse_it 
# Input: list of seperated relevent name elements from every image
# Output: Bisected file names based on split
# Description: TODO
###
def parse_it(file_names, object_num):
    newsid1_anum = []
    for i in range(0, len(file_names)):
        newsid1_anum.append(file_names[i][object_num])
    return newsid1_anum

###
# Method: sep_slidebook 
# Input: File names containng all relevant image info (animal #, slice #, field #)
# Output: Data frame with each type of info as it own column
# Description: Parses out individual grouping variables
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
# Input: Data from grouping of variables
# Output: List of unique image IDs contining specific grouping information
# Description: Creates one grouping object for each image that can be compared across other iterations of the images with slightly different file names
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

print("Starting audit.py")
# Method to change working directory from inputted ImageJ Macro
curr_dir = os.getcwd()
def set_dir(arg1):
    curr_dir = arg1
    os.chdir(curr_dir)
set_dir(sys.argv[1])

# Get the selected classifier by the user
selected_classifier = sys.argv[2]

is_projected = "False"
is_projected = sys.argv[3]

# Read in geno_full.csv
geno_file = "../testing_area/geno_full.csv"
geno = pd.read_csv(geno_file)
# Get the unique genotype labels
lvl_geno = np.unique(geno["geno"])
if len(lvl_geno) != 2:
    print("automatic analysis can only be done with 2 levels, for alterative analysis use _Final.csv files in classifier folders")

# Get full directory of files
images_dir = "../training_area/testing_area/Images"
full_files = os.listdir(images_dir)

# Determine number of draws by number of files in validation hand count folder
val_loc = "../training_area/Validation_Hand_Counts/"
val_files = os.listdir(val_loc)
draws = len(val_files)
draws_per_geno = int(draws/len(lvl_geno))

# Usig projected images
if is_projected == "True":
    # Get file information for projected images
    id1_df_sep = sep_slidebook(full_files, "-")
    id1_df_squish = squish(id1_df_sep)

    # Specify: original file names, info columns, squished ID
    newsid1_df = pd.DataFrame(columns=["newsid1"])
    for index in range(0, len(full_files)):
            new_row = pd.DataFrame([[full_files[index]]], columns=["newsid1"])
            newsid1_df = newsid1_df.append(new_row)

    # This df gives us access to varibles based on the images in several forms
    big_df = pd.concat([newsid1_df, id1_df_squish], axis=1)
    big_df = pd.concat([big_df, id1_df_sep], axis=1)
    big_df.columns = ["File_name", "Img_ID", "A_num", "S_num", "F_num"]

    # Now need to gather all images with matching img_ID 
    # Need to start working in directory that holds all image folders
    u_img = np.unique(big_df["Img_ID"])

    # Select the files for each genotype
    # Define experimental variable level 1 files
    ev0_files = {}
    for i in range(len(u_img)):
        if geno["geno"][i] == lvl_geno[0]:
            ev0_files[u_img[i]] = lvl_geno[0]

    # Define experimental variable level 2 files        
    ev1_files = {}
    for i in range(len(u_img)):
        if geno["geno"][i] == lvl_geno[1]:
            ev1_files[u_img[i]] = lvl_geno[1]

    # TODO Make it handle N number of levels
    # Randomly select images to be auditted
    audit_set = {}
    ev0_rand = random.sample((ev0_files.items()), draws_per_geno)
    ev1_rand = random.sample((ev1_files.items()), draws_per_geno)
    for elem in ev0_rand:
        audit_set[elem[0]] = elem[1]
    for elem in ev1_rand:
        audit_set[elem[0]] = elem[1]

    # Select all the projections of the selected images
    selected_images = []
    for id in audit_set:
        # Identify images belonging to each unique image ID
        all_current_ID = big_df.query('Img_ID == @id')
        max_len = all_current_ID.shape[0]
        # Project the image of the same ID onto one image
        for k in range(0, max_len):
            path = val_loc + list(all_current_ID["File_name"])[k]
            selected_images.append(path)
# Using non-projected images
else:  
    # Select the files for each genotype
    # Define experimental variable level 1 files
    ev0_files = {}
    for i in range(len(full_files)):
        if geno["geno"][i] == lvl_geno[0]:
            ev0_files[full_files[i]] = lvl_geno[0]
                
    #define experimental variable level 2 files        
    ev1_files = {}
    for i in range(len(full_files)):
        if geno["geno"][i] == lvl_geno[1]:
            ev1_files[full_files[i]] = lvl_geno[1]

    # Randomly select images to be auditted
    audit_set = {}
    ev0_rand = random.sample((ev0_files.items()), draws_per_geno)
    ev1_rand = random.sample((ev1_files.items()), draws_per_geno)
    for elem in ev0_rand:
        audit_set[elem[0]] = elem[1]
    for elem in ev1_rand:
        audit_set[elem[0]] = elem[1]
    selected_images = audit_set.keys()

###need to get these random variable numbers from oritional file directory, eg images, counted 
# TODO Temp comment out so I don't need to redo ROI stuff
"""
# Copy selected images into audit images directory
for file in selected_images:
    filename =  os.path.basename(file)
    print(filename)
    
    shutil.copyfile("../testing_area/Images/" + filename, os.path.join("../testing_area/Audit_Images/" + selected_classifier +"/", filename))
    shutil.copyfile("../testing_area/Weka_Output_Counted/" + selected_classifier +"/" + filename, os.path.join("../testing_area/Audit_Counted/"+ selected_classifier +"/", filename))

# Write a CSV for the geno data with images in alphabetical order
geno_csv = []
for key, value in sorted(audit_set.items()):
    geno_csv.append([value])
print(geno_csv)

# TODO Temp comment out so I don't need to redo ROI stuff
with open("../testing_area/geno_audit.csv", 'w+', newline ='') as file:
    write = csv.writer(file)
    write.writerow(["geno"])
    write.writerows(geno_csv)


hand_ini = pd.read_csv("../testing_area/Audit_Hand_Counts/roi_counts.csv", usecols=['Label'])
lvl_h = np.unique(hand_ini)
count_h = {}
for i in range(0, len(hand_ini)):
    if count_h.get(hand_ini.loc[i].at["Label"]) == None:
        count_h[hand_ini.loc[i].at["Label"]] = 1
    else:
        count_h[hand_ini.loc[i].at["Label"]] = count_h[hand_ini.loc[i].at["Label"]] + 1

print(count_h)
"""
print("Finished audit.py") 