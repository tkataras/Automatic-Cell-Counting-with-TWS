input = getDirectory("Choose source directory of the macro (Scripts for Auto Cell Count)");
testingPath = input + "../training_area/testing_area/";
classifierDir = input + "../training_area/Classifiers";
searchDirectory = getFileList(classifierDir);

print(classifierDir);
Dialog.create("Select Classifier to test on full dataset");
/*for (index = 0; index < searchDirectory.length; index++) {
	print(searchDirectory[index]);	
	classifierName = searchDirectory[index];
	Dialog.addCheckbox(classifierName, false);	
}*/
Dialog.addChoice("Choose classifier", searchDirectory);
Dialog.show();

selectedClassifier = Dialog.getChoice();

exec("python", input + "file_architect.py", input, selectedClassifier);

print(selectedClassifier);

//TODO figure out bean shell calling
//runMacro(input + "BS_TWS_apply.bsh");

// TODO Check if can run without projected images
searchDirectory = input
Dialog.create("Example Dialog");
Dialog.addCheckbox("Do you need to project multiple image segmentations?", false);
Dialog.show();
result = Dialog.getCheckbox();
if (result) {
	exec("python", input + "Project N Images by ID.py", input);
	searchDirectory = input + "../training_area/testing_area/Weka_Output_Projected/";
} else {
	searchDirectory = input + "../training_area/testing_area/Weka_Output_Thresholded/";
}

// Run ImageJ macros
runMacro(input + "just_thresh.ijm", testingPath);
/*
runMacro(input + "count_from_roi.ijm", testingPath);

runMacro(input + "count_over_dir.ijm", searchDirectory);

y = input + "test.py";
z = input + "classifier_comparison.py";

print(y);
// Next, run classifier comparison
//exec("python", y);
exec("python", z, input);
print("finished pipeline");
*/