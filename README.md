# Automatic-Cell-counting-with-TWS
A repository for the suit of scripts I use to perform automatic cell quantification.


## Table of Contents
1. [Installation Guide](#installation-guide)
2. [Software Dependencies](#software-dependencies)

# Installation Guide
```
git clone https://github.com/tkataras/Automatic-Cell-counting-with-TWS.git
```

# Software Dependencies

```
sudo apt-get update
sudo apt-get install python3-pip
pip3 install numpy
pip3 install scipy
pip3 install pandas
```

# Prerequisites:
Current** version of FIJI distribution of Imagej
https://imagej.net/software/fiji/

*** need R version___
Need beanshell installation through terminal
 
By downloading our Github repository you will have a set of folders for practice and for experimental use.

# Practice
The first step in practice is to initiate the pipeline. You will be prompted to locate the installation location of the pipeline, as this will vary by user preference.
The pipeline will then individually apply classifiers to the validation data and output the accuracy statistics using hand count placement .ROi files and the supplied genotypes.csv file. Our data includes paired images in individual fields of view for increased context when counting, so intermediate steps are included to identify and project these image pairs for the final automatic count.
After the pipeline completes a run, run times will vary by hardware capacity, open the all_classifier_comparison.csv* file to compare the performance of the various classifiers. Several classifiers should demonstrate the same accuracy statistics as the image size is very small, containing at most 3 cells per image.
Now, select the most accurate classifier. Selecting the most accurate classifier is left to the user, but information is supplied in the form of accuracy values in Precision, Recall and F! score, as well as statistical outputs of mean accuracy comparison between two separate experimental conditions entered in the genotypes.csv file. With base functionality, the pipeline is set up to process a dataset with two experimental groups.***
 
After the best classifier is selected, the second step of the pipline is initiated which applies a single classifier across the previously unseen dataset and produces count and basic morphology measurements, as well as a handful of prescribed statistical comparisons. This step requires a second genotypes.csv file from the user containing experimental grouping information for the unseen dataset.
Additionaly, the second step of the pipeline sets aside a random sample of images equal to the number of validation images and equally distributed between experimental groups to serve as the performance estimate on the unseen data. This performance analysis requires user input in the form of .ROI hand counts. This audit dataset is then used to calculate the same statistics as the validation dataset for comparison*****
 
           	Creating hand count markers
Hand count markers are created in Imagej using the Point Selection Tool, available in the toolbar, and the ROI manager.
1.      Open an image and place one or two count markers
2.      Add the selections to the ROI manager
3.      Rename the new ROI with the image name
a.      (this is most easily done by using the following keyboard shortcuts:
Ctrl+d -> Ctrl+c -> Ctrl+w -> right click the ROI and select Rename -> Ctrl+v -> Enter)
4.      Continue selecting cell locations, peridocally updating via the Update button in the ROI Manager
5.      When all cells are selected, save in Hand counts folder, or Audit hand counts folder for the audit image set.
6.      Open new image and repeat until all validation or audit images are counted.
 
Critical notes**
The image names much match exactly between the hand counts and the original images(except for the file extension).
Each folder must only contain images or hand counts, with the exception of the Weka Output Counted folder, in which classifier subfolders will include calculation data files.
At present, two experimental conditions, denoted in the genotypes.csv files, are expected. 

