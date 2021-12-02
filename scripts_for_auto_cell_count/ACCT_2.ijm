/**
 * Author: Theo Kataras, Tyler Jang
 * Date: 12/1/2021
 * 
 * Description:
 */
 // The user needs to select the source directory of the code so that the program knows where the user has downloaded the program.
input = getDirectory("Choose source directory of the macro (Scripts for Auto Cell Count)");

// Set measurements to calculate
run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction limit display redirect=None decimal=8");

// Variables for needed file paths
testingPath = input + "../training_area/testing_area/";
classifierDir = input + "../training_area/Classifiers";
searchDirectory = getFileList(classifierDir);

// Ask the user to select the classifier they want to count the full dataset
Dialog.create("Select Classifier to test on full dataset");
Dialog.addChoice("_Choose classifier", searchDirectory);
Dialog.show();

selectedClassifier = Dialog.getChoice();
print(selectedClassifier);

// Populate all folders. If folders already exist, selectively does not make those folders
exec("python", input + "file_architect.py", input, selectedClassifier);

// Trim .model off the selected classifier by the user
trimClassName = split(selectedClassifier, ".");

testingPath = testingPath + "Weka_Output/" + trimClassName[0];

// Create weka output for selected classifier
run("apply TWS one classifier");

// TODO Check if can run without projected images
searchDirectory = input
Dialog.create("Question");
Dialog.addCheckbox("Do you need to project multiple image segmentations?", false);
Dialog.show();
result = Dialog.getCheckbox();

// Threshold the images
runMacro(input + "just_thresh.ijm", testingPath);

if (result) {
	exec("python", input + "Project N Images by ID.py", input, trimClassName[0]);
	searchDirectory = input + "../training_area/testing_area/Weka_Output_Projected/" + trimClassName[0];
} else {
	searchDirectory = input + "../training_area/testing_area/Weka_Output_Thresholded/" + trimClassName[0];
}

// Count the number of objects in each image
runMacro(input + "count_full_dataset.ijm", searchDirectory);

// Begin the third act of the pipeline
//exec("python", input + "audit.py", input, trimClassName[0]);
//runMacro(input + "audit_count.ijm", testingPath + "," + trimClassName[0]);

// Next, run get statistical information about the classifier's performance
exec("python", input + "finalClassifierCheck.py", input, trimClassName[0]);

// select the random images for the audit set
//exec("python", input + "audit.py", input, trimClassName[0]);

print("Finished Act 2");