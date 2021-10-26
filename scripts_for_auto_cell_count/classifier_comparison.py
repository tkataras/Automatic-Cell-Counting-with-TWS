#!/usr/bin/python
###
# Author: Tyler Jang, Theo Kataras
# Date 10/25/2021
# This file is the pipeline for comparing classifier accuracy on validation data
#
# Inputs: genotype file, hand count results file from Cout Roi, results of The Count.IJM in each classifier folder 
# Outputs: csv table with accuracy measurements for each classifier
###
import pandas as pd
import numpy as np
import os
import sys
import time
import scipy.stats

# Method to change working directory from inputted ImageJ Macro
currDir = os.getcwd()
def setDir(arg1):
    currDir = arg1
    os.chdir(currDir)
setDir(sys.argv[1])

# Input the genotype data as a .csv file
geno_file = "../training_area/genotype.csv"

# File output location
OUTPUT_count = "../training_area/Weka_Output_Counted/"
result_out = "../training_area/Results/"

class_list = os.listdir(OUTPUT_count)

############################## now we have binary projected images to work with and need to compare to roi for each classifier

#initialize variables
#row_row = NA #holds row of accuracy values for each classifier one at a time
#your_boat = NA #holds all accuracy values for classifiers
#count_h <- NA # holds hand count number per image

###################now need to proces the results files


#iterate through the counted classifier folders folders, will save final output within each folder
#setting working dir, needs to contain all counted output folders


##processing hand count roi to get count per image

### adding in the results of the hand_count_from_roi.ijm, this will not change by folder, and is generated manually by saving results in Imagej from Count ROI
hand_ini = pd.read_csv("../training_area/Results/roi_counts.csv", usecols=['Label'])
lvl_h = np.unique(hand_ini)
count_h = {}
for i in range(0, len(hand_ini)):
    if count_h.get(hand_ini.loc[i].at["Label"]) == None:
        count_h[hand_ini.loc[i].at["Label"]] = 1
    else:
        count_h[hand_ini.loc[i].at["Label"]] = count_h[hand_ini.loc[i].at["Label"]] + 1
hand_final = count_h

#location of folders holding The Count output
counted_folder_dir = OUTPUT_count

print("Got to start of iterating over classifiers")
#iterate through each classifier 
for f in range(0, len(class_list)):
    class_res_loc = counted_folder_dir + os.listdir(OUTPUT_count)[f] + "/Results.csv"
    class_results = pd.read_csv(class_res_loc)
    curr_class = os.listdir(OUTPUT_count)[f]
    print(curr_class)

    ##if else loop for determining true positive, false positive and false negative cell counts
    ##from levels present in the classifier results output, this should be the same each time, BUT IT WoNT BE IF ONE IMAGE HAS NO CELL OBJECtS
    #need to go into the counted folder and pull out all image names, meaning ignorming the Results.csv files. images from tru_count with be .png
    folder_loc = counted_folder_dir + os.listdir(OUTPUT_count)[f]
    print(folder_loc)

    files = []
    for image in os.listdir(folder_loc):
        if image[-4:] == ".png":
            files.append(image)

    img_names = files

    final_blah = pd.DataFrame(columns=["name", "tp", "fp", "fn"])

    for image in range(0, len(img_names)):
        current_img_plus_png = img_names[image]
        
        dftc = class_results[class_results["Label"].isin([current_img_plus_png])]
        
        if dftc.size == 0:
            name = img_names[i]
            tp = 0
            fp = 0
            fn = count_h[lvl_h[image]]
            this_row = pd.DataFrame([[name, tp, fp, fn]], columns=["name", "tp", "fp", "fn"])
        else: 
            fp = 0
            tp = 0
            fn = 0

            for autoCount in (dftc["points"]):
                if autoCount == 0:
                    fp = fp + 1
                elif autoCount == 1:
                    tp = tp + 1
                else:
                    tp = tp + 1
                    fn = fn + autoCount - 1
        
        #for each image add total number hand count - sum(dftc$points), the sum points must always be less than hand_final$count 
        ## dtfc$points only counts the markers that fall within cell objects, hand_final$counts is the sum of all points in total. 
        #when this is not true(eg there are negative values) check the image names of the hand count!!
        missed = count_h[lvl_h[image]] - sum(dftc["points"]) 
        fn = fn + missed
        name = img_names[image]

        this_row = pd.DataFrame([[name, tp, fp, fn]], columns=["name", "tp", "fp", "fn"])
        final_blah = final_blah.append(this_row)
    # TODO I don't think this line of code should be here in the first place, it seems harmful
    #final_blah = final_blah.append(this_row)
    
    # Need to calculate precision and recall
    #print(final_blah)

    tot_tp = sum(final_blah["tp"])
    tot_fp = sum(final_blah["fp"])
    tot_fn = sum(final_blah["fn"])
    
    #print(tot_tp)
    #print(tot_fp)
    #print(tot_fn)

    # precision is tp/(tp + fp)
    prec = tot_tp/(tot_tp + tot_fp)
    #recall is tp/(tp + fn)
    reca = tot_tp/(tot_tp + tot_fn)
  
    F1 = 2*(prec*reca/(prec + reca))
    print(curr_class + " percision = " +  str(prec))
    print(curr_class + " recall = " +  str(reca))
    print(curr_class + " F1 = " +  str(F1))

      
    current_loc = counted_folder_dir + "/" + class_list[f]
    file_out_name = current_loc + "/" + curr_class + "_Final.csv"
    #writes out the final file to save the output
    final_blah.to_csv(file_out_name)
  
    # Add genotypes to csv file
    geno = pd.read_csv(geno_file)
    lvl_geno = np.unique(geno)
    genoList = []
    for numRows in range(0, len(final_blah["name"])):
        genoList.append(geno["geno"][numRows % 2])
    final_blah["geno"] = genoList


    #####this makes the table comparing all classifiers
  
    #precision and recall per image
    prec2 = final_blah["tp"]/(final_blah["tp"] + final_blah["fp"])    
    reca2 = final_blah["tp"]/(final_blah["tp"] + final_blah["fn"])

    # TODO This is throwing a divide by 0 error I want to ignore
    # This is temp fix, but a negative * positive can still cause divide by 0
    def catchDivideByZero(numer, denom):
        try:
            return numer/denom
        except ZeroDivisionError:
            return 0
    F1_2 = 2*(catchDivideByZero(prec2*reca2, prec2 + reca2)) 

    # Insert prec2, reca2, and F1_2 into final blah
    final_blah["prec2"] = prec2
    final_blah["reca2"] = reca2
    final_blah["F1_2"] = F1_2

    print(final_blah)

    if len(lvl_geno) > 2:
        print("automatic analysis can only be done with 2 levels, for alterative analysis use _Final.csv files in classifier folders")

    # TODO T test calc
    #p_g_tt <- t.test(final_blah$prec2 ~ final_blah$geno)
    #p_g_tt_p <- p_g_tt$p.value
    
    #p_g_tt = scipy.stats.ttest_ind(final_blah["prec2"], final_blah["geno"])
currTime = time.localtime(time.time())
print(currTime)
#generating a unique file name based on time and date
date = str(currTime.tm_mday) + "-" + str(currTime.tm_hour) + "-" + str(currTime.tm_min) + "-" + str(currTime.tm_sec)

out_name = "All_classifier_Comparison_" + date + ".csv"

#write.csv(your_boat, paste(result_out,out_name, sep = ""))
final_blah.to_csv(result_out + out_name)

print("end")