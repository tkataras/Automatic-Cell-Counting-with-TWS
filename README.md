# ACCT: Automatic-Cell-Counting-with-TWS
A user friendly program for automated object counting using Trainable WEKA Segmentation.

## Table of Contents
1. [Installation Guide](#installation-guide)
2. [Prerequisites](#prerequisites)
3. [Software Dependencies](#software-dependencies)
4. [How To Use](#how-to-use)
6. [Creating hand count markers](#creating-hand-count-markers)
7. [Critical Notes](#critical-notes)

# Installation Guide
First you will have to acquire this directory, which can be done through a terminal such as Git, Ubuntu, or Microsoft Powershell with the following line of code.
```
git clone https://github.com/tkataras/Automatic-Cell-counting-with-TWS.git
```
If you are not familiar with terminals, you can also click the green code button and select __Download ZIP__, then unzip the files in a desired location.

Next, ensure you have downloaded the software located in the [Prerequisites](#prerequisites) section.


Finally, you will have to manually copy and paste certain files into the __plugins__ folder of your Fiji instalation of Imagej. 

Find where you downloaded Fiji in your file directory. Next, navigate to scripts for auto cell count then copy and paste the following files into your Fiji.app/plugins directory. This is so you can run the program from ImageJ using the graphical user interface and macro menu.
```
ACCT_1.ijm
ACCT_2.ijm
BS_TWS_apply_prob.bsh
apply_TWS_one_classifier_prob.bsh
```

# Prerequisites:
-Current version of FIJI distribution of Imagej https://imagej.net/software/fiji/

-Python https://www.python.org/ftp/python/3.10.0/python-3.10.0-amd64.exe

-Currently the ImageScience package for FIJI must NOT be installed or have been installed on the FIJI installation in use
 


# Software Dependencies
__Windows:__ In order to install the neccessary Python packages, the Python Scripts folder must be added to the terminal's knowelege of working areas designated by the PATH file.

If you are unfamiliar with Python, the easiest way to do this is to do the following steps:

Locate the Python install directory through the Windows search in Explorer

Copy the address of the scripts folder from the location bar at the top of the explorer window

Access Edit system environment variables in the control panel, select Environment variables, select Path, Edit and new

Paste the copied python scrips location into the new path line

Open Windows Powershell from the search menu and the packages can be installed by copying the install scripts line by line and right clicking on the working line of the termnial to paste.

__Linux/Mac:__ Open your terminal and copy paste the following into the command line.
```
pip3 install numpy
pip3 install scipy
pip3 install pandas
pip3 install python-time
pip3 install imageio
pip3 install sklearn
```

# How To Use

By downloading our Github repository you will have a set of folders for demo and for experimental use.

## Manual Input Files
```
For consistency of inpyt, all inut images should be in .PNG format
TODO should be able to handle .JPG and .tiff, just need to test it
```
Place the entire set of images you would like counted inside of __testing_area/images__.

Place the set of images you would like to use as images to train the classifiers inside of __training_area/training_images__.

Place the set of images you would like use for validation of the machine learning classifiers in __training_area/Validation_data__.

These three sets should have no overlapping images for the most statstically valid automatic counts.

You will also need to create a .csv file storing the experimental condition data for your images. ACCT is set up to handle two condition comparisons automatically. Currently, this is neccessary even if you only have one condition. We refer to these files as genotype.csv for the validation data, and geno_full.csv for the experimental data.
```
genotype.csv 
```
Place this file inside of __training_area/__. 

The file will look similar to this with "geno" as a specified header and your conditions for each image of your training set in alphabetical order written in each row.

<img src = "figures/genotypeCSV.PNG">

```
geno_full.csv
```
Place this file inside of __testing_area/__. It will look similar to the other genotype file but will have rows for every image in your complete dataset with rows containing the condition/group of the image the row represents.
```
User generated classifiers through Trainable Weka Segmentation
```
Place these classifiers inside of __training_area/Classifiers__. These should be __.model__ files.

## Image Protocols
Images should be of the same dimensions.

Images should be free of major artifacts (Optional but recommended).

Images should be in .png format.
TODO (Haven't tested yet) Images could also be .jpg or .tiff

Each image _must_ have a unique file name.

Image file names should not contain the following symbols as they are used for other purposes.
```
.     (except for the symbol starting the file extension)
:
```

Projected images should have the following identifying characteristics to know which projections associate with each other: ... __TODO__

## How to create classifiers using Weka
ACCT uses Weka Classifiers to count images, which the user will initially need to create. In order to generate classifiers..... __TODO__

The program expects at least 2 classifiers to compare performance against.

## Stage 1
From the ImageJ bar, navigate and select __Plugins >> ACCT 1__. You may need to scroll down for a period of time.
<img src = "figures/selectACCT1.png">


__1.1__ The first step is to initiate the pipeline. You will be prompted to locate the installation location of the pipeline, as this will vary by user preference. This is so that our program knows where you have downloaded it. Select the directory/folder named __scripts_for_auto_cell_count__.

<img src = "figures/selectSource.PNG">

__1.2__ The pipeline will ask if you want to run Trainable Weka Segmentation. This will individually apply classifiers to the validation data and output the accuracy statistics using hand count placement .roi files and the supplied genotypes.csv file. This stage needs to only be run once for a set of validation images, but you may want to repeatedly run later stages, such as stage __1.4__, to optimize your results. Thus, we give the option to skip this stage. By default, it is set to run.

<img src = "figures/selectWeka.png">

__If not done yet, to generate your own genotype.csv file: TODO__

__1.3__ Our data includes paired images in individual fields of view for increased context when counting, so intermediate stage are included to identify and project these image pairs for the final automatic count. If your data does not include paired images, do not select this option below:

<img src = "figures/selectMultipleSegmentation.PNG">

__1.4__ To count the number of objects in your data, the program defaults to a pixel minimum and maximum object size. These cuttoffs will have significant effects on accuracy and vary completely by application. You will be prompted to select these values. This has to be left to the user since the size of the objects they want counted will vary between different users.

<img src = "figures/sizeValues.png">

After the pipeline completes a run, run times will vary by hardware capacity, open the __All\_Classifier\_Comparison\_(current time).csv__ file to compare the performance of the various classifiers. This is a summary of the overall statistical performance of each classifier.

More statistical information will be printed to the log window.

This will be located under __training_area/Results__.

If you desire even more detailed statistical information about each individual classifier:
1. Reciever operator curves are also automatically generated for each classifier and located inside of __training_area/Weka_Output_Counted/classifier#/classifier#\_roc\_curve.pdf__.
2. The number of true positives, false positives, and false negatives for each individual image for each individual classifier can be found in __training_area/Weka_Output_Counted/classifier#/classifier#\_Final.csv__.
3. The morphological data and the correctness of each individual object counted for each individual image for each indivdual classifier can be found in __training_area/Weka_Output_Counted/classifier#/classifier#\_Results.csv__.

As an example, the output in log will look like this.

<img src = "figures/act1ExpectedOut.PNG">

## Stage 2
From the ImageJ bar, navigate and select __Plugins >> ACCT 2__

__2.1__ Once again, the program must know where it is downloaded. Select the directory/folder named __scripts_for_auto_cell_count__. [scripts_for_auto_cell_count](scripts_for_auto_cell_count)
TODO maybe add links to each folder inside of this README?


<img src = "figures/selectSource.PNG">

__2.2__ Now, select the most accurate classifier (or any classifier of your choosing). Selecting the most "best" classifier is left to the user, but information is supplied in the form of accuracy values in Precision, Recall and F1 score, as well as statistical outputs of mean accuracy comparison between two separate experimental conditions entered in the genotypes.csv file. This program is set to handle any N number of conditions, performing 1 sample T-Tests, Welch 2 sample T-Tests, and ANOVA respective to the number of conditions in the genotype.csv file. __TODO__ Note that audit or ACCT 3 can only handle 2 levels, and only 2 levels.

<img src = "figures/selectClassifier.PNG">

__2.3__ After the classifier is selected, the pipline applies the single selected classifier across the previously unseen dataset and produces count and basic morphology measurements, as well as a handful of prescribed statistical comparisons. This is similar to stage __1.2__. As in that step, the user will only need to run this once for a full dataset, but may want to repeatedly run later stages, such as stage __2.4__, to optimize your results. Thus, we give the option to skip this step. By default, it is set to run.

<img src = "figures/selectWeka.png">

__2.4__ Repeat stage __1.3__ and __1.4__ with the exact same parameters you used in stage __1__. This stage requires a second genotypes file named __geno_full.csv__ from the user containing experimental grouping information for the unseen dataset. This serves the exact same purpose as __genotype.csv__, but for the full set of images.

__If not done yet, to generate your own geno_full.csv file: TODO__


If you desire even more detailed statistical information about the selected classifier:
1. The number of counted objects for each individual image for each individual classifier can be found in __testing_area/Weka_Output_Counted/classifier#/classifier#\_Final.csv__.
2. The morphological data of each individual object counted for each individual image for each indivdual classifier can be found in __testing_area/Weka_Output_Counted/classifier#/classifier#\_Results.csv__.

## Stage 3
*** 
Additionaly, the third step of the pipeline sets aside a random sample of images equal to the number of validation images and equally distributed between experimental groups to serve as the performance estimate on the unseen data. This performance analysis requires user input in the form of .roi hand counts, similar to what was done in the first step of the program. This audit dataset is then used to calculate the same statistics as the validation dataset for comparison.

__TODO__
***

# Creating Hand Count Markers
Hand count markers are created in Imagej using the Point Selection Tool, available in the toolbar, and the ROI manager, which is under __Analyze >> Tools >> ROI Manager__. You can also type ROI Manager in the search bar and select it.

1. Open an image and place one or two count markers 
2. Add the selections to the ROI manager
3. Rename the new ROI with the image name (This is most easily done by using the following keyboard shortcuts: Ctrl+Shift+d -> Ctrl+c -> Ctrl+w -> right click the ROI and select Rename -> Ctrl+v -> Enter)
4. Continue selecting cell locations, peridocally updating via the Update button in the ROI Manager
5. When all cells are selected, save in Hand counts folder, or Audit hand counts folder for the audit image set.
6. Open new image and repeat until all validation or audit images are counted.

<img src = "figures/fijiMultiPoint.PNG">
<img src = "figures/roiManager.PNG">

# Critical Notes
The image names much match exactly between the hand counts and the original images (except for the file extension).

Each folder must only contain images or hand counts, with the exception of the Weka Output Counted folder, in which classifier subfolders will include calculation data files.
At present, two experimental conditions, denoted in the genotypes.csv files, are expected. 

When running the program again with a new set of images, classifiers, etc. you will want to remove all the inputted files and folders generated by the program so that the file architecture is the same as it was when downloaded from github.
