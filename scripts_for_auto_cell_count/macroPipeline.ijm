input = getDirectory("Choose source directory of the macro (Scripts for Auto Cell Count)");

// Set measurements to calculate
run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction limit display redirect=None decimal=8");

print(input);

File.setDefaultDir(input);
print(File.getDefaultDir);


exec("python", input + "file_architect.py", input);

// TODO need to find a way to put this bsh into user's plugins
//fiji_dir = getDirectory("Select the plugins directory for fiji (fiji/plugins)");
//Copy BS_TWS_apply.bsh into fiji_dir
//File.copy(input + "BS_TWS_apply.bsh", getDirectory("plugins"));
//run("BS TWS apply");

runMacro(input + "just_thresh.ijm", input);

// TODO Check if can run without projected images
searchDirectory = input
Dialog.create("Multiple Image Segmentations?");
Dialog.addCheckbox("Do you need to project multiple image segmentations?", false);
Dialog.show();
result = Dialog.getCheckbox();
if (result) {
	exec("python", input + "Project N Images by ID.py", input);
	searchDirectory = input + "../training_area/Weka_Output_Projected/";
} else {
	searchDirectory = input + "../training_area/Weka_Output_Thresholded/";
}

// Run ImageJ macros
runMacro(input + "count_from_roi.ijm", input);
runMacro(input + "count_over_dir.ijm", searchDirectory);

z = input + "classifier_comparison.py";

// Next, run classifier comparison
exec("python", z, input);
print("finished pipeline");