# ACCT: Automatic-Cell-Counting-with-TWS
A user friendly program for automated object counting using Trainable WEKA Segmentation.

## Table of Contents
1. [Installation Guide](#installation-guide)
2. [Prerequisites](#prerequisites)
3. [Software Dependencies](#software-dependencies)
4. [Manual Input Files](#manual-input-files)
5. [Creating Classifiers Using Weka](#Creating-Classifiers-Using-Weka)
6. [Hand Placed Markers for Validation](#creating-Hand-Placed-Markers-for-Validation)
7. [How to Use](#how-to-use) 
8. [Errors and Troubleshooting](#errors-and-troubleshooting)
9. [Quick Start Guide(in progress)](#quick-start-guide)

# Prerequisites
-Current version of Fiji distribution of ImageJ: https://imagej.net/software/fiji/

-Python: https://www.python.org/ftp/python/3.10.0/python-3.10.0-amd64.exe 

(Ensure the "add to path" check box is selected during install)

-Currently the ImageScience package for Fiji must NOT be installed or have been installed on the Fiji installation in use since it is not compatable with our program. If you have installed ImageScience, you can uninstall and reinstall Fiji to solve the problem. Alternatively, it is possible to use ACCT from a fresh installation of Fiji.

# Installation Guide
First you will have to download this program, which can be done through a terminal such as Git, Ubuntu, or Microsoft Powershell with the following line of code.
```
git clone https://github.com/tkataras/Automatic-Cell-counting-with-TWS.git
```
If you are not familiar with terminals, you can also click the green code button and select __Download ZIP__, then unzip the files in a desired location.

Next, ensure you have downloaded the software located in the [Prerequisites](#prerequisites) section.

Finally, you will have to manually copy and paste certain files into the __Plugins__ folder of your Fiji instalation of ImageJ. 

Find where you downloaded Fiji in your file directory. Next, navigate to [scripts_for_auto_cell_count](scripts_for_auto_cell_count) then copy and paste the following files into your __Fiji.app/plugins__ directory. This is so you can run the program from ImageJ using the graphical user interface and macro menu.
```
ACCT_1.ijm
ACCT_2.ijm
ACCT_3.ijm
apply_BS_TWS_prob.bsh
apply_TWS_one_classifier_prob.bsh
```


# Software Dependencies
__Windows:__ In order to install the neccessary Python packages, the Python Scripts folder must be added to the terminal's knowledge of working areas designated by the PATH file. The easiest way to do this is to ensure the "add to path" checkbox is filled during the installation of Python.

If you have an existing installation of Python not added to path, perform the following steps to add Python to the path:

```
Locate the Python install directory through the Windows search in Explorer.
Copy the address of the scripts folder from the location bar at the top of the Explorer window.
Access Edit system environment variables in the control panel, select Environment variables, select Path, Edit and new.
Paste the copied Python scrips location into the new path line.
```
With Python added to the system apth, open Windows Powershell from the search menu and the packages can be installed by copying the following install commands line by line. Right click the working line of the termnial to paste the command.

```
pip3 install numpy
pip3 install scipy
pip3 install pandas
pip3 install python-time
pip3 install imageio
pip3 install sklearn
pip3 install matplotlib
```

__Linux/Mac:__ Open your terminal and copy paste the following into the command line.
```
sudo apt install python3-pip

pip3 install numpy
pip3 install scipy
pip3 install pandas
pip3 install python-time
pip3 install imageio
pip3 install sklearn
pip3 install matplotlib
```

## File architecture
This image represents the full file architecture of ACCT, displaying information about the location and purpose of different folders. More details about individual sections of this image appear in the following sections.
<img src = "figures/file_diagram.png">


# Manual Input Files
```
All input images should be in .PNG, .JPEG, or .TIF format. 
Preferably, images should be in .PNG format.
```
Place the entire set of images you would like counted inside of [testing_area/images](testing_area/images).

Place the set of images you would like to use as images to train the classifiers inside of [training_area/training_images](training_area/training_images). This is mainly for you to keep track of what images you used for training.

Place the set of images you would like use for validation of the machine learning classifiers in [training_area/Validation_data](training_area/Validation_data).

These three sets should have no overlapping images for the most statstically valid automatic counts.

You will also need to create a .csv file storing the experimental condition data for your images. ACCT is set up to handle two condition comparisons automatically. Currently, this is neccessary even if you only have one condition. We refer to these files as genotype.csv for the validation data, and geno_full.csv for the experimental data.
```
genotype.csv 
```
Place this file inside of [training_area/](training_area/). 

The file will look similar to this with "geno" as a specified header and your conditions for each image of your training set in alphabetical order written in each row.

<img src = "figures/genotypeCSV.PNG">

```
geno_full.csv
```
Place this file inside of [testing_area/](testing_area/). It will look similar to the other genotype file but will have rows for every image in your complete dataset with rows containing the condition/group of the image the row represents.
```
User generated classifiers through Trainable Weka Segmentation
```
Place these classifiers inside of [training_area/Classifiers/](training_area/Classifiers/). These should be __.model__ files.

Making classifiers is described in the [Creating Classifiers Using Weka](#Creating-Classifiers-Using-Weka) section.

## Image Protocols
Images should be of the same dimensions.

Images should be 8-bit.

Images should be free of major artifacts (Optional but recommended).

Each image _must_ have a unique file name.

Image file names should not contain the following symbols as they are used for other purposes.
```
.     (except for the default symbol starting the file extension)
:
```
## Projected Images
In some cases, paired or grouped images should be projected to create a complete cell count of an area. We are working on a more flexible implimentation of ACCT for handling projected images, but presently the images should have the following identifying characteristics to know which projections associate with each other: 

The final characters denoting the end of unique image information should be: ___XY__

There are 3 loci for levels of identifying information seperated by __-__:

1. The __first__ space, before any __"-"__

2. The __second__ space, after a single __"-"__

3. The __last__ space, after all __"-"__, and before ___XY__ . Only the first two characters are considered

Example: __BKO-426-S42-Iba-Syn-Cortex-10x-F1a_XY1562195071_Z0_T0_C2.tiff8bit.pngcropped.pngNpt3__

In this example, the relevant sections are:
```
426
S42
F1
```

# Creating Classifiers Using Weka
ACCT uses Weka Classifiers to identify cells in images, which the user will need to create. 

Before starting, close any images open in Fiji.

Start by selecting all [training_area/training_images](training_area/training_images) in your file explorer progam and drag them to the Fiji user interface bar to open them all at once.

Once all images are open, use the Fiji search bar to apply the __Images to Stack__ operation.

You will then want to convert the images to 8-bit for consistency, which will make the images appear in greyscale. To do this select __Image >> Type >> 8-bit__.

With the image stack selected, launch the __Advanced Weka Segmentation__ plugin from the Fiji search bar, or __Plugins__ menu.

With the __full training image stack__ open in Weka, we can beging training classifiers.

It is best to start with small amounts of input data, using the free selection tool to highlight some cell pixels in an image and adding them to __Class 1__ and some non-cell pixels, adding them to __Class 2__.

<img src = "figures/weka gui.png">

After the first two instances of training data are added, press __Train classifier__ to begin building a classifier with the provided data, which will then be applied to the whole image stack, visible from an overlay on all images. __The first training can take several minutes on an image stack, as features are calcuated for the first time for each image. This speed improves in the following trainings.__

<img src = "figures/smaller_training/training1.pnghalf.png">

Once there is feedback on the current state of the classifier, save it with the __Save classifier__ button, before adding a few more pixels of training data based on areas with inaccurate segmentation based on the current classifier overlay. 

<img src = "figures/smaller_training/training2.pnghalf.png">

<img src = "figures/smaller_training/training5.pnghalf.png">

With the new training data added, press __Train classifier__ and observe the result, making further corrections and saving the intermediate classifiers.

<img src = "figures/smaller_training/training7.pnghalf.png">

<img src = "figures/smaller_training/training8.pnghalf.png">

Each new addition of data will change the persepctive of the classifier based on the new data, and we can save multiple classifiers which allows us to select the most effective point in training based on the validation data.

There will be an image overlay in red and green showing what the classifier thinks is part of the object and what is not. If you would like to see the original image under the overlay, select __Toggle overlay__.

To review, for ACCT's automatic counting to function:
**Cells** should be **RED**, or class 1

**Background** should be **GREEN** or class 2

For more information, there is a thorough explanation of __Trainable Weka Segmentation__ plugin located at: https://imagej.net/plugins/tws/ .

ACCT will expect at least 2 classifiers to compare performance against for its validation step.

# Creating Hand Placed Markers for Validation
Hand count markers are created in ImageJ using the Point Selection Tool, available in the toolbar, and the ROI manager, which is under __Analyze >> Tools >> ROI Manager__. You can also type ROI Manager in the search bar and select it. You should also close __Trainable Weka Segmentation__ if you still have it open.

1. Open an image and place one or two count markers 
2. Add the selections to the ROI manager
3. Rename the new ROI with the image name (This is most easily done by using the following keyboard shortcuts: Ctrl+Shift+d -> Ctrl+c -> Ctrl+w -> right click the ROI and then select Rename -> Ctrl+v -> Enter)
4. Continue selecting cell locations, peridocally updating via the Update button in the ROI Manager
5. When all cells are selected, save the .roi file in the [training_area/Validation_Hand_Counts](training_area/Validation_Hand_Counts) folder if placing markers for the validation images, or in the [testing_area/Audit_Hand_Counts](testing_area/Audit_Hand_Counts) folder for the audit image set. To do this select __More >> Save__ and navigate to the folder you wish to save the file in.
6. Once saved, select the roi in the roi manager and select __Delete__ before moving on to the next image. Then close the image so you can open the next image. Your computer will ask if you want to save changes you made to the image, but you _do not_ want to save changes. Instead, select __Don't Save__ when closing the image.
7. Open a new image and repeat until all validation or audit images are counted.

<img src = "figures/fijiMultiPoint.PNG">

<img src = "figures/roiManager.PNG">

# How To Use

TODO: By downloading our Github __demo__ repository you will have a set of folders for demo and for experimental use. (Don't have a demo with example data yet)

## Stage 1
From the ImageJ bar, navigate and select __Plugins >> ACCT 1__. You may need to scroll down for a period of time to find it.

<img src = "figures/selectACCT1.png">

__1.1__ The first step is to initiate the pipeline. You will be prompted to locate the installation location of the ACCT folders, as this will vary by user preference.  Select the directory/folder named [scripts_for_auto_cell_count](scripts_for_auto_cell_count).

<img src = "figures/selectSource.PNG">

__1.2__ The pipeline will ask if you want to reset your folders. Specifically it will ask if you want to reset your Weka_ folders. This is because you may want to run ACCT with new images and so you will need to remove old files or the program will try to use those old files. If you select the option to reset your files, it will then ask to confirm that choice.

<img src = "figures/fileResetOne.png">
<img src = "figures/fileResetTwo.png">

__1.3__ The pipeline will ask if you want to run Trainable Weka Segmentation. This will individually apply classifiers to the validation data and output the accuracy statistics using hand count placement .roi files and the supplied genotypes.csv file. This stage needs to only be run once for a set of validation images, but you may want to repeatedly run later stages, such as stage __1.4__, to optimize your results. Thus, we give the option to skip this stage. By default, it is set to run.

<img src = "figures/selectWeka.png">

__1.4__ Our data includes paired images in individual fields of view for increased context when counting, so intermediate stage are included to identify and project these image pairs for the final automatic count. If your data does not include paired images, do not select this option below:

<img src = "figures/selectMultipleSegmentation.PNG">

__1.4.1__ If you select this option, you will then be prompted to rerun the step that grouped the projected images into a combined image. This step takes a long time relative to other parts of the pipeline and only needs to be done once, so you are prompted to decide if you want to rerun this step.

<img src = "figures/rerunProjected.png">

__1.5__ To count the number of objects in your data, the program defaults to a pixel minimum and maximum object size. These cuttoffs will have significant effects on accuracy and vary completely by application. You will be prompted to select these values. This has to be left to the user since the size of the objects they want counted will vary between different users. You will also be prompted to optionally apply the watershed algorithm when counting images. This is used to separate objects that are touching or overlapping in the image so they can be separately counted. This is on by default.

<img src = "figures/sizeValues.png">

After the pipeline completes a run, run times will vary by hardware capacity, open the __All\_Classifier\_Comparison\_(current time).csv__ file to compare the performance of the various classifiers. This is a summary of the overall statistical performance of each classifier.

More statistical information will be printed to the log window.

This will be located under [training_area/Results](training_area/Results).

If you desire even more detailed statistical information about each individual classifier:
1. Reciever operator curves are also automatically generated for each classifier and located inside of __training_area/Weka_Output_Counted/classifier#/classifier#\_roc\_curve.pdf__.   (Note, Not all models classifiy pixels in a probabilistic manner, instead classifying by a binary label. Thus, ROC plots cannot be generated for that particular model.)

2. The number of true positives, false positives, and false negatives for each individual image for each individual classifier can be found in __training_area/Weka_Output_Counted/classifier#/classifier#\_Final.csv__.
3. The morphological data and the correctness of each individual object counted for each individual image for each indivdual classifier can be found in __training_area/Weka_Output_Counted/classifier#/classifier#\_Results.csv__.

As an example, the output in log will look like this.

<img src = "figures/act1ExpectedOut.PNG">

## Stage 2
From the ImageJ bar, navigate and select __Plugins >> ACCT 2__.

__2.1__ Once again, the program must know where it is downloaded. Select the directory/folder named [scripts_for_auto_cell_count](scripts_for_auto_cell_count). Also, select the most accurate classifier (or any classifier of your choosing). Selecting the best classifier is left to the user, but information is supplied in the form of accuracy values on the validation dataset in the form of in Precision, Recall and F1 score, as well as statistical outputs of mean accuracy comparison between two separate experimental conditions entered in the genotypes.csv file. This program is set to handle any N number of conditions, performing Welch 2 sample T-Tests and ANOVA respective to the number of conditions in the genotype.csv file.

<img src = "figures/applyTWSOneClassifierProb.png">

__2.2__ After the classifier is selected, the pipline applies the single selected classifier across the previously unseen dataset and produces count and basic morphology measurements, as well as a handful of prescribed statistical comparisons based on the genotypes file. This is similar to stage __1.2__. As in that step, the user will only need to run this once for a full dataset, but may want to repeatedly run later stages, such as stage __2.4__, to optimize your results. Thus, we give the option to skip this step. By default, it is set to run.

<img src = "figures/selectWeka.png">

__2.3__ Repeat stage __1.3__ and __1.4__ with the exact same parameters you used in stage __1__. This stage requires a second genotypes file named __geno_full.csv__ from the user containing experimental grouping information for the unseen dataset. This serves the exact same purpose as __genotype.csv__, but for the full set of images.

If you desire even more detailed statistical information about the selected classifier:
1. The number of counted objects for each individual image for each individual classifier can be found in __testing_area/Weka_Output_Counted/classifier#/classifier#\_Final.csv__.
2. The morphological data of each individual object counted for each individual image for each indivdual classifier can be found in __testing_area/Weka_Output_Counted/classifier#/classifier#\_Results.csv__.

## Stage 3
*** 
The third step of the pipeline allows the user to audit the accuracy of a set of binary images using a set of hand placed markers. In this step, set aside a random sample of images equal to the number of validation images and equally distributed between experimental groups from the unseen data to serve as the performance estimate. This performance analysis requires user input in the form of .roi hand counts, similar to what was done for the validation images in ACCT 1. This audit dataset is then used to calculate the same statistics as the validation dataset for comparison. ACCT 3 can also be used to assess the accuracy of any set of binary images with multi point ROI markers. 

__3.1__ Same as __1.1__

__3.2__ You will select which classifier you want to audit the performance of from the full dataset. 

<img src = "figures/auditSelectClassifier.png">

__3.3__ The program will ask if you are ready to audit your images. This is because the program is waiting for you to select the images you want to audit and move them into the __Audit_Images__ folder. It is also waiting for the .roi files for these images to be placed in the __Audit_Hand_Counts__ folder. Once this is done you can select __OK__.

<img src = "figures/auditConfirmProgress.png">

__3.4__ Same as __1.5__ to set the maximum and minimum object size and toggle the watershed algorithm option.
***

# Errors and Troubleshooting
## Installation Errors
__I can't move the files listed in the installation guide into the Plugins folder__
1. It may be that you do not have permission to move files into that location. It may be your computer downloading Fiji into a protected location, like the iCloud. Try moving it, or downloading it again, to a local folder and try moving the folders again.
  
__I want to use other classifier models besides the ones that come with ACCT__
1. Weka allows installation of other classifier models which is explained at the following website: https://imagej.net/imagej-wiki-static/Trainable_Weka_Segmentation_-_How_to_install_new_classifiers

## Program Errors
__ACCT will not run if I try to use the result from the search bar.__
1. If this is happening, instead of searching for ACCT in the search bar, select ACCT from the plugins menu

__My program is giving me an index out of bounds exception.__
1. Keep subfolders in [training_area/](training_area) and [testing_area/](testing_area) free of files other than their intended content. Failing to do so may cause the program to give incorrect results.
2. When running the program again with a new set of images, classifiers, etc. you will want to remove all the folders generated by the program so that the file architecture is the same as it was when downloaded from Github. 
3. Make sure images have unique and corresponding file names to your ROI counts.

__If you get an error message stating "Error when adjusting data!"__
1. In our experience, this occurs mostly when the ImageJ updates its software. It is most often solved by uninstalling and reinstalling Fiji. You could also try the ImageJ updater, but it doesn't always work.
2. It could be that one of your classifier.model files got corrupted, and needs to be remade.

__If you get an error message stating it could not apply classifier:__
1. It could be that you forgot to train your classifiers on 8-bit images, which should look grey. When making classifiers, they need to be trained on 8-bit images and not 32-bit or color images which will create classifiers designed for those image types. The solution is to convert your images to 8-bit which can be done through the ImageJ bar by selecting __Image >> Type >> 8-bit__.

__My roi_counts.csv looks like it has repetitive data, or it looks like it is full of error messages__
1. Close all ImageJ windows except for the task bar. This can be from running ACCT and stopping the program midway through, then rerunning. It can also be from just rerunning the program. The issue is due to the Results and Summary windows remaining open, which get added to the csv file again when the program generates it.

__I have applied classifiers with BS TWS to many of the images but had to stop for some reason or for some error and I do not want to restart the long process again for the images I already finished.__
1. You can remove images that you have already processed in images to skip forward, but be sure you know that you processed these images correctly.

__No ROC plot appears in Weka_Output_Counted folders__
1. You may not have all Python packages installed correctly. Make sure all Python packages are installed and available.
2. Check that the output to log says that the ROC curve was not generated due to the data being entirely false positives or true positives. This happens on occasion when a classifier is too restrictive or not restrictive enough. The program will not generate a ROC curve that is essentially a flat line in that situation.
3. Not all models classifiy pixels in a probabilistic manner, instead classifying by a binary label. Thus, ROC plots cannot be generated for that particular model.
 
__No Audit_example.csv file appears in Results folder when running ACCT 3__
1. Make sure for ACCT 3 that images in __Audit_Counted__ match .roi files in __Audit_Hand_Counts__ and the rows in __geno_audit.csv__




# Quick Start Guide(in progress)
***
to quickly test ACCT with your own images follow these steps:
Download the #### branch, which has no demonstration data included.

Prepare your data:
  All images should be 8-bit single channel .png images without any extranious information such as scale bars.

Separate your image set and place them in the following folders:
  training images - a subset of images to train the machine learnign classifier - place in DownloadLocation/training_are/training_images
  validation images - a sebset of images to assess classifier accuracy durign model selection - place in DownloadLocation/training_are/Validation_images
  testing images - the remaining images you would like to count - place in DownloadLocation/training_are/Validation_images
 
 Create a validation marker set
  Use the "Multi-point" selection tool in FIJI to place a marker near the center of each counted object in each validation image and save one multipoint ROI per image using the same file name as the original images.
  
 Create a genotype file for the validation images
  As ACCT is designed for cell counting in experimental conditions, the user must specify the conditions of each image in a .csv file named genotype.csv. the column of data containing the condition infomration must have the first element as "geno" followed by whatever levels are present in the experiment. there must be one cell for each image in the valdiation dataset.
 
  Run ACCT 1 from the Macro dropdown menu in FIJI (it will be at the bottom)
  
  
 
