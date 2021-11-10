input = getDirectory("Choose source directory of the macro (Scripts for Auto Cell Count)");
print(input);

File.setDefaultDir(input);
print(File.getDefaultDir);

exec("python", input + "file_architect.py", input);

// TODO need to find a way to put this bsh into user's plugins
<<<<<<< HEAD
//fiji_dir = getDirectory("Select the plugins directory for fiji (fiji/plugins)");
// Copy BS_TWS_apply.bsh into fiji_dir

//run("BS TWS apply", input);
=======
run("BS TWS apply");
>>>>>>> parent of 900d13a... Changed the arguments to audit.py to take the current dir and selected classifier

runMacro(input + "just_thresh.ijm", input);

// TODO Check if can run without projected images
searchDirectory = input
Dialog.create("Example Dialog");
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