/**
 * Author: Theo Kataras, Tyler Jang
 * Date: 2/17/2022
 * 
 * Input: Several user created classifiers, a set of images.
 * Output: The total number of objects counted, statistical information about the count
 * Description: This second stage of the pipeline uses a selected classifier by the user to count the number of objects
 * 				in each image as well as give statistical and morphological information. 
 */
print("Starting ACCT 2");

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

// Populate all folders. If folders already exist, selectively does not make those folders
exec("python", input + "file_architect.py", input, selectedClassifier);

// Trim .model off the selected classifier by the user
trimClassName = split(selectedClassifier, ".");
testingPath = testingPath + "Weka_Output/" + trimClassName[0];

// Create Weka output for the selected classifier if option is selected
Dialog.create("Run Weka to create new probability output?");
Dialog.addCheckbox("Do you need to run Weka?", true);
Dialog.show();
ifWeka = Dialog.getCheckbox();
if (ifWeka) {
	run("apply TWS one classifier prob");
} 

// Dialog box option to ask user if their data is made of projected image segmentations
// TODO Check if can run with projected images
searchDirectory = input;
Dialog.create("Question");
Dialog.addCheckbox("Do you need to project multiple image segmentations?", false);
Dialog.show();
result = Dialog.getCheckbox();
if (result) {
	exec("python", input + "project_probability.py", input, trimClassName[0]);
	// Projected images go inside of Weka_Output_Projected
	searchDirectory = input + "../testing_area/Weka_Output_Projected/" + trimClassName[0];
} else {
	// Else, search for images in Weka Output
	searchDirectory = input + "../testing_area/Weka_Output/" + trimClassName[0];
}

// Count the number of objects in each image
runMacro(input + "count_full_dataset_prob.ijm", searchDirectory);

// Finally, get statistical information about the classifier's performance
exec("python", input + "final_classifier_check.py", input, trimClassName[0]);

print("Finished ACCT 2");