# ACCT: Automatic-Cell-counting-with-TWS
A user friendly program for automated object counting using Trainable WEKA Segmentation.

## Table of Contents
1. [Installation Guide](#installation-guide)
2. [Software Dependencies](#software-dependencies)
3. [Prerequisites](#prerequisites)
4. [How To Use](#how-to-use)
5. [Creating hand count markers](#creating-hand-count-markers)
6. [Critical Notes](#critical-notes)

# Installation Guide
First you will have to acquire this directory, can be done through a terminal such as Git, Ubuntu, or Microsoft Powershell with the following line of code.
```
git clone https://github.com/tkataras/Automatic-Cell-counting-with-TWS.git
```
Next, ensure you have downloaded the software located in the __Prerequisites__ section.

Finally, you will have to manually copy and paste certain files into the plugins folder of your Fiji instalation of Imagej. 

Find where you downloaded Fiji in your file directory. Next, navigate to scripts for auto cell count then copy and paste the following files into your Fiji.app/plugins directory. This is so you can run the program from ImageJ using the GUI.
```
BS_TWS_apply.bsh
apply_TWS_one_classifier.bsh
```

# Software Dependencies
__Windows:__ In order to install the neccessary Python packages, the Python Scripts folder must be added to the terminal's knowelege of working areas designated by the PATH file. The easiest way to do this is to locate the Python install directory through the Windows search and copy the adress of the scripts folder. Then access Edit system environment variables, select Environment variables, select Path, Edit and new. Then paste the copied python scrips location into the new path line. Now open Windows Powershell from the search menu and the packages can be installed by copying the install scripts line by line and right clicking on the working line of the termnial to paste.

__Linux/Mac:__ Open your terminal and copy paste the following into the command line.
```
sudo apt-get update
sudo apt-get install python3-pip
pip3 install numpy
pip3 install scipy
pip3 install pandas
pip3 install python-time
pip3 install imageio
pip3 install sklearn
```

# Prerequisites:
-Current version of FIJI distribution of Imagej https://imagej.net/software/fiji/

-***In ImageJ enable update site for Featurej**

-Python https://www.python.org/ftp/python/3.10.0/python-3.10.0-amd64.exe
 
# How To Use

By downloading our Github repository you will have a set of folders for practice and for experimental use.

# Manual Input Files
```
Your images in .PNG format
TODO should be able to handle .JPG and .tiff, just need to test it
```
Place the entire set of images you would like counted inside of training_area/testing_area/images.

Place the set of images you would like to use as training images to train the classifiers inside of training_area/Validation_data.
```
genotype.csv 
```
Place this file inside of training_area/. 

The file will look similar to this with "geno" as a specified header and your conditions for each image of your training set in alphabetical order written in each row.

<img src = "figures/genotypeCSV.PNG">

```
geno_full.csv
```
Place this file inside of training_area/testing_area. It will look similar to the other genotype file but will have rows for every image in your complete dataset with rows containing the condition/group of the image the row represents.
```
classifiers generated by you through Weka
```
Place these classifiers inside of training_area/Classifiers. These should be .model files.

# Image Protocols
Images should be of the same dimensions.

Images should be free of major artifacts (Optimal but recommended).

Images should be in .png format.
TODO images could also be .jpg or .tiff

Each image should have a unique file name.

Image file names should not contain a a __.__ (except for the one starting the file extension) or a __:__ as these symbols are used for other purposes.

Projected images should have the following identifying characteristics to know which projections associate with each other: ...

# How to create classifiers using Weka
ACCT uses Weka Classifiers to count images, which the user will initially need to create. In order to generate classifiers..... __TODO__

The program expects at least 2 classifiers to compare performance against.
# Stage 1

Navigate and select _Plugins >> Macro >> Run >> macroPipeline.ijm_

__1.1__ The first step is to initiate the pipeline. You will be prompted to locate the installation location of the pipeline, as this will vary by user preference. This is so that our program knows where you have downloaded it. Select the directory/folder named scripts_for_auto_cell_count.

<img src = "figures/selectSource.PNG">

__1.2__ The pipeline will then individually apply classifiers to the validation data and output the accuracy statistics using hand count placement .roi files and the supplied genotypes.csv file. 

__If not done yet, to generate your own genotype.csv file: TODO__

__1.3__ Our data includes paired images in individual fields of view for increased context when counting, so intermediate steps are included to identify and project these image pairs for the final automatic count. If your data does not include paired images, do not select this option below:

<img src = "figures/selectMultipleSegmentation.PNG">

__1.4__ To count the number of objects in your data, the program defaults to a 20 pixel minimum size to determine an object as countable. If you want a different minimum size threshold in order to be counted, you are able to adjust this value.

<img src = "figures/selectSizeMin.PNG">

After the pipeline completes a run, run times will vary by hardware capacity, open the All_Classifier_Comparison.csv file to compare the performance of the various classifiers. 

More statistical information will be printed to the log window.

This will be located under training_area/Results.

For the testing dataset, several classifiers should demonstrate the same accuracy statistics as the image size is very small as they contain at most 3 cells per image.

As an example, the output in log will look like this.
<img src = "figures/act1ExpectedOut.PNG">

# Stage 2
Navigate and select _Plugins >> Macro >> Run >> selectedClassifierPipeline.ijm_

__2.1__ Once again, the program must know where it is downloaded. Select the directory/folder named scripts_for_auto_cell_count.

<img src = "figures/selectSource.PNG">

__2.2__ Now, select the most accurate classifier (or any classifier of your choosing). Selecting the most accurate classifier is left to the user, but information is supplied in the form of accuracy values in Precision, Recall and F1 score, as well as statistical outputs of mean accuracy comparison between two separate experimental conditions entered in the genotypes.csv file. This program is set to handle any N number of conditions, performing 1 sample T-Tests, Welch 2 sample T-Tests, and ANOVA respective to the number of conditions in the genotype.csv file. __TODO__ Note that audit or ACCT 3 can only handle 2 levels, and only 2 levels.

<img src = "figures/selectClassifier.PNG">

__2.3__ After the best classifier is selected, the pipline applies the single selected classifier across the previously unseen dataset and produces count and basic morphology measurements, as well as a handful of prescribed statistical comparisons. This step requires a second genotypes file named geno_full.csv from the user containing experimental grouping information for the unseen dataset.

__If not done yet, to generate your own geno_full.csv file: TODO__


__2.4__ Repeat steps __1.3__ and __1.4__ with the parameters you used in stage 1.

*** 
Additionaly, the third step of the pipeline sets aside a random sample of images equal to the number of validation images and equally distributed between experimental groups to serve as the performance estimate on the unseen data. This performance analysis requires user input in the form of .roi hand counts, similar to what was done in the first step of the program. This audit dataset is then used to calculate the same statistics as the validation dataset for comparison.
***

# Creating Hand Count Markers
Hand count markers are created in Imagej using the Point Selection Tool, available in the toolbar, and the ROI manager, which is under Analyze >> Tools >> ROI Manager. You can also type ROI Manager in the search bar and select it.
1.      Open an image and place one or two count markers 
2.      Add the selections to the ROI manager
3.      Rename the new ROI with the image name (This is most easily done by using the following keyboard shortcuts: Ctrl+d -> Ctrl+c -> Ctrl+w -> right click the ROI and select Rename -> Ctrl+v -> Enter)
4.      Continue selecting cell locations, peridocally updating via the Update button in the ROI Manager
5.      When all cells are selected, save in Hand counts folder, or Audit hand counts folder for the audit image set.
6.      Open new image and repeat until all validation or audit images are counted.
<img src = "figures/fijiMultiPoint.PNG">
<img src = "figures/roiManager.PNG">

# Critical Notes
The image names much match exactly between the hand counts and the original images(except for the file extension).
Each folder must only contain images or hand counts, with the exception of the Weka Output Counted folder, in which classifier subfolders will include calculation data files.
At present, two experimental conditions, denoted in the genotypes.csv files, are expected. 

When running the program again with a new set of images, classifiers, etc. you will want to remove all the inputted files and folders generated by the program so that the file architecture is the same as it was when downloaded from github.
