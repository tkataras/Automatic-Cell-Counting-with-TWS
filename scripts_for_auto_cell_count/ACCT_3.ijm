input = getDirectory("Choose source directory of the macro (Scripts for Auto Cell Count)");

// Set measurements to calculate
run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction limit display redirect=None decimal=8");

//making sure all folders exist
exec("python", input + "file_architect.py", input);

testingPath = input + "../training_area/testing_area/";
classifierDir = input + "../training_area/Classifiers";
searchDirectory = getFileList(classifierDir);

print(classifierDir);

Dialog.create("Select Classifier to test on full dataset");
Dialog.addChoice("_Choose classifier", searchDirectory);
Dialog.show();

selectedClassifier = Dialog.getChoice();

// Trim .model off the selected classifier by the user
trimClassName = split(selectedClassifier, ".");

// Randomly select images for analysis
exec("python", input + "audit.py", input, trimClassName[0]);

Dialog.create("Question");
Dialog.addCheckbox("Now hand count the randomly selected audit images inside of training_area/testing_area/Audit_Images. Select this box when you are ready to continue.", false);
Dialog.show();

// Count and analysis of audit images
runMacro(input + "count_from_roi.ijm", input + "../training_area/testing_area/Audit_Hand_Counts/" + trimClassName[0] + "/");

runMacro(input + "audit_count.ijm", searchDirectory);
exec("python", input + "audit_classifier_comparison.py", input, trimClassName[0]);