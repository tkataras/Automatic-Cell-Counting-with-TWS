/**
 * Author: Theo Kataras, Tyler Jang
 * Date: 11/30/2021
 * 
 * Description:
 */
// The user needs to select the source directory of the code so that the program knows where the user has downloaded the program.
input = getDirectory("Choose source directory of the macro (Scripts for Auto Cell Count)");

// Set measurements to calculate
run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction limit display redirect=None decimal=8");

// Populate all folders. If folders already exist, selectively does not make those folders
//exec("python", input + "file_architect.py", input);

//run("BS TWS apply");	
//run("BS TWS apply prob");





/*
Dialog.create("Label or Probability?");
Dialog.addCheckbox("Probability?", false);
Dialog.show();
result = Dialog.getCheckbox();



if(result) {
	run("BS TWS apply prob");
} else {
	// TODO need to find a way to put this bsh into user's plugins
	//fiji_dir = getDirectory("Select the plugins directory for fiji (fiji/plugins)");
	//Copy BS_TWS_apply.bsh into fiji_dir
	//File.copy(input + "BS_TWS_apply.bsh", getDirectory("plugins"));
//	run("BS TWS apply");
}
*/
//run("BS TWS apply");

// Threshold the images into distinct values
//runMacro(input + "just_thresh.ijm", input);

// TODO Check if can run without projected images
searchDirectory = input
Dialog.create("Multiple Image Segmentations?");
Dialog.addCheckbox("Do you need to project multiple image segmentations?", false);
Dialog.show();
result = Dialog.getCheckbox();
if (result) {
	exec("python", input + "project_N_images_by_ID.py", input);
	searchDirectory = input + "../training_area/Weka_Output_Projected/";
} else {
	searchDirectory = input + "../training_area/Weka_Output_Thresholded/";
}

// Run ImageJ  macros 
//runMacro(input + "count_from_roi.ijm", input);

//runMacro(input + "count_over_dir_prob_TK.ijm", searchDirectory);

//runMacro(input + "count_over_dir.ijm", searchDirectory);
runMacro(input + "count_over_dir_prob_TK.ijm", searchDirectory);


// Next, run classifier comparison
//exec("python", input + "classifier_comparison.py", input);

print("Finished Act 1");