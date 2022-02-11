/**
 * Author: Theo Kataras, Tyler Jang
 * Date: 12/1/2021
 * 
 * Input: Several user created classifiers, a set of images.
 * Description: This second stage of the pipeline uses a selected classifier by the user to count the number of objects
 * 				in each image as well as give statistical and morphological information. 
 */
 // The user needs to select the source directory of the code so that the program knows where the user has downloaded the program.
input = getDirectory("Choose source directory of the macro (Scripts for Auto Cell Count)");

// Set measurements to calculate
run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction limit display redirect=None decimal=8");

// Variables for needed file paths
testingPath = input + "../testing_area/";
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

// Create Weka output for the selected classifier
//COMMENTING OUT FO RNOW @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//run("apply TWS one classifier-probs");


// TODO Check if can run without projected images
searchDirectory = input
Dialog.create("Question");
Dialog.addCheckbox("Do you need to project multiple image segmentations?", false);
Dialog.show();
result = Dialog.getCheckbox();

if (result) {
	exec("python", input + "project_N_images_by_ID.py", input, trimClassName[0]);
	searchDirectory = input + "../testing_area/Weka_Output_Projected/" + trimClassName[0];
} else {
	searchDirectory = input + "../testing_area/Weka_Output_Thresholded/" + trimClassName[0];
}

// Count the number of objects in each image
runMacro(input + "count_full_dataset-prob.ijm", searchDirectory);

// Finally, get statistical information about the classifier's performance
exec("python", input + "final_classifier_check.py", input, trimClassName[0]);

print("Finished Act 2");