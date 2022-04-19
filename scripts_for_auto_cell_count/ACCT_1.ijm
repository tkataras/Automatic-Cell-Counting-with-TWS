/**
 * Author: Theo Kataras, Tyler Jang
 * Date: 4/19/2022
 * 
 * Input: Classifier model files, validation images, hand counted roi files
 * Output: CSV of statistical performance of each classifier on validation data, ROC curves
 * Description: Main program for doing training analysis of user made classifiers to determine 
 * 				the performance of each classifier on a set of validation images. 
 */
print("Starting ACCT 1");

// The user needs to select the source directory of the code so that the program knows where the user has downloaded the program.
input = getDirectory("Choose source directory of the macro (Scripts for Auto Cell Count)");

// Set measurements to calculate
run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction limit display redirect=None decimal=8");

// Ask the user if they need to reset their file system
Dialog.create("File Reset");
Dialog.addCheckbox("Have you run this program before and would like to reset your files for a clean run? This only deletes the contents of the Weka_ folders.", false);
Dialog.show();
ifReset = Dialog.getCheckbox();
if (ifReset) {
	// Double check that this is what they want
	Dialog.create("Confirmation");
	Dialog.addCheckbox("Are you sure you would like to reset your folders?", false);
	Dialog.show();
	ifReset = Dialog.getCheckbox();
	if (ifReset) {
		exec("python", input + "file_reset.py", input);
	}
}
// Populate all folders. If folders already exist, selectively does not make those folders
exec("python", input + "file_architect.py", input);

// Ask if the user needs to run Weka 
Dialog.create("Run Weka to create new probability output?");
Dialog.addCheckbox("Do you need to run Weka?", true);
Dialog.show();
ifWeka = Dialog.getCheckbox();
if (ifWeka) {
	run("apply BS TWS prob");
} 

// Dialog box option to ask user if their data is made of projected image segmentations
searchDirectory = input;
Dialog.create("Multiple Image Segmentations?");
Dialog.addCheckbox("Are you working with projected image segmentations?", false);
Dialog.show();
result = Dialog.getCheckbox();
if (result) {
	// Projected images go inside of Weka_Output_Projected
	searchDirectory = input + "../training_area/Weka_Output_Projected/";

	// Check if the user has already projected images
	Dialog.create("Project Probability Images?");
	Dialog.addCheckbox("Do you need to project images again? If you already have done so, leave the box unselected so you can speed up this step", false);
	Dialog.show();
	projectResult = Dialog.getCheckbox();
	if (projectResult) {
		exec("python", input + "project_probability.py", input);	
	}

	// Threshold the projected images and move them into folder for processing
	runMacro(input + "threshold_projected_prob.ijm", searchDirectory);
} else {
	// Else, search for images in Weka Output
	searchDirectory = input + "../training_area/Weka_Output/";
}

// Run ImageJ macros
runMacro(input + "count_from_roi.ijm", input);

runMacro(input + "count_over_dir_prob_TK.ijm", searchDirectory);

// Next, run classifier comparison
exec("python", input + "classifier_comparison.py", input);

// Run ROC Curve script
exec("python", input + "roc_curve.py", input);

print("Finished ACCT 1");
