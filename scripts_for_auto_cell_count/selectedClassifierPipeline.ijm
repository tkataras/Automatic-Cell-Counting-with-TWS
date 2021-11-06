input = getDirectory("Choose source directory of the macro (Scripts for Auto Cell Count)");
testingPath = input + "../training_area/testing_area/";
classifierDir = input + "../training_area/Classifiers";
searchDirectory = getFileList(classifierDir);

print(classifierDir);

Dialog.create("Select Classifier to test on full dataset");
Dialog.addChoice("Choose classifier", searchDirectory);
Dialog.show();

selectedClassifier = Dialog.getChoice();
print(selectedClassifier);
exec("python", input + "file_architect.py", input, selectedClassifier);

trimClassName = split(selectedClassifier, ".");

testingPath = testingPath + "Weka_Output/" + trimClassName[0];

//TODO figure out bean shell calling
//runMacro(input + "BS_TWS_apply.bsh");

//exec("python", input + "audit.py");

// TODO Check if can run without projected images
searchDirectory = input
Dialog.create("Example Dialog");
Dialog.addCheckbox("Do you need to project multiple image segmentations?", false);
Dialog.show();
result = Dialog.getCheckbox();
if (result) {
	exec("python", input + "Project N Images by ID.py", input, trimClassName[0]);
	searchDirectory = input + "../training_area/testing_area/Weka_Output_Projected/" + trimClassName[0];
} else {
	searchDirectory = input + "../training_area/testing_area/Weka_Output_Thresholded/" + trimClassName[0];
}

// Run ImageJ macros
runMacro(input + "just_thresh.ijm", testingPath); //***IT STILL SEemS to ME LIKE thiS NEEDS TO BE RUN BEFORE PROJECT IMAGES***
runMacro(input + "count_full_dataset.ijm", searchDirectory);

// Run Python script
//exec("python", input + "audit.py", input, trimClassName[0]);

// Next, run classifier comparison
exec("python", input + "finalClassifierCheck.py", input, trimClassName[0]);
print("finished pipeline");
