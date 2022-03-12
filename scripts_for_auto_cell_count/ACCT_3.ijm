/**
 * Author: Theo Kataras, Tyler Jang
 * Date: 3/9/2022
 * 
 * Description: Main program to validate the counts from ACCT 2 to see performance on a random
 * 				selection of images.
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

// Randomly select images for analysis
//TK: thinking about this more, the audit set needs to have the same genotype/exp condition breakdown as the validation set, IF the user has exp groups, so we might just say the 
//user has to select images randomly and count them themselves and that THIS TOOL is just a way for them to quantify any futher counted images. 
//audit could be more user input based so people can use it for any counting. just have one folder for counted images, one folder for hand counts and an output location in results

//exec("python", input + "audit.py", input, trimClassName[0]);

print(input + "../testing_area/Audit_Images/" + trimClassName[0] + "/");
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

