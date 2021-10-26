#!/usr/bin/python
import pandas as pd
import numpy as np
import os

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


#iterate through each classifier 
for f in range(0, len(class_list)):
    class_res_loc = counted_folder_dir + os.listdir(OUTPUT_count)[f] + "/Results.csv"
    class_results = pd.read_csv(class_res_loc)
    curr_class = os.listdir(OUTPUT_count)[f]
    print(curr_class)

    ##if else loop for determining true positive, false positive and false negative cell counts
    ##from levels present in the classifier results output, this should be the same each time, BUT IT WoNT BE IF ONE IMAGE HAS NO CELL OBJECtS
    #need to go into the counted folder and pull out all image names, meaning ignorming the Restuls.csv files. images from tru_count with be .png
    folder_loc = counted_folder_dir + os.listdir(OUTPUT_count)[f]
    print(folder_loc)

    files = []
    for image in os.listdir(folder_loc):
        if image[-4:] == ".png":
            files.append(image)

    img_names = files

    # TODO need to make a data frame
    final_blah = pd.DataFrame(columns=["name", "tp", "fp", "fn"])
    print(final_blah)

    for image in range(0, len(img_names)):
        current_img_plus_png = img_names[image]
        
        dftc = class_results[class_results["Label"].isin([current_img_plus_png])]
        
        #if dftc["Labels"] == None:
            # TODO convert this to working code
            #name = img_names[i]
           ## tp = 0
            #fp = 0
            #fn = as.numeric(hand_final$count_h[i])
            #this_row <- cbind(name,tp, fp, fn) 
        #else: 
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
        #print(fp)
        #print(tp)
        #print(fn)
        #for each image add total number hand count - sum(dftc$points), the sum points must always be less than hand_final$count 
        ## dtfc$points only counts the markers that fall within cell objects, hand_final$counts is the sum of all points in total. 
        #when this is not true(eg there are negative values) check the image names of the hand count!!
        missed = count_h[lvl_h[image]] - sum(dftc["points"]) 
        fn = fn + missed
        print(missed)
        name = img_names[image]

        #TODO somehow make it equivalent
        this_row = pd.DataFrame([[name, tp, fp, fn]], columns=["name", "tp", "fp", "fn"])
        final_blah = final_blah.append(this_row)

    #final_blah <-rbind(final_blah, this_row)
    ##need to calculate Precision and recall
    print(final_blah)

    tot_tp = sum(final_blah["tp"])
    tot_fp = sum(final_blah["fp"])
    tot_fn = sum(final_blah["fn"])
    
    print(tot_tp)
    print(tot_fp)
    print(tot_fn)
print("end")
