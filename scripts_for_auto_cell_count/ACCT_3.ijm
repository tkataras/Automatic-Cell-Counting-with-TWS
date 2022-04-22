/**
 * Author: Theo Kataras, Tyler Jang
 * Date: 4/21/2022
 * 
 * Description: Main program to validate the counts from ACCT 2 to see performance on a
 * 				selection of images from the full dataset.
 */
input = getDirectory("Choose source directory of the macro (Scripts for Auto Cell Count)");

// Set measurements to calculate
run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction limit display redirect=None decimal=8");

testingPath = input + "../testing_area/";
classifierDir = input + "../training_area/Classifiers";
searchDirectory = getFileList(classifierDir);

print(classifierDir);

Dialog.create("Select Classifier to audit");
Dialog.addChoice("_Choose classifier", searchDirectory);
Dialog.show();

selectedClassifier = Dialog.getChoice();

// Trim .model off the selected classifier by the user
trimClassName = split(selectedClassifier, ".");

// Making sure all folders exist
exec("python", input + "file_architect.py", input, selectedClassifier);

// Ask if the user needs to run Weka 
Dialog.create("Have you selected your audit image set, marked cells with multi point selection and moved counted images into the counted folder?");
Dialog.addCheckbox("Are you ready to audit your dataset?", true);
Dialog.show();
ifWeka = Dialog.getCheckbox();
if (ifWeka) {
	// Count and analysis of audit images
	runMacro(input + "count_from_roi_audit.ijm", input + "../testing_area/Audit_Hand_Counts/" + trimClassName[0] + "/");
	runMacro(input + "audit_count.ijm", input + "../testing_area/Audit_Counted/" + trimClassName[0] + "/");
	exec("python", input + "audit_classifier_check.py", input, trimClassName[0]);
} 


print("Finished ACCT 3");

