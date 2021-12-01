/*
 * Author: Theo, Tyler
 * Date: 11/1/2021
 * Description:
 */
setBatchMode(true); 
print("Starting just_thresh.ijm");
// Weka Output
inputDirs = getArgument();
// Weka Output Thresholded
outputDirs = "";

// Get the classifier
selectedClassifier = split(inputDirs, "/");

firstStage = true;

// Check if the argument is from testing or training area
if(inputDirs.contains("testing_area")) {
	outputDirs = inputDirs + "/../../Weka_Output_Thresholded/" + selectedClassifier[selectedClassifier.length-1] + "/";
	firstStage = false;
} else {
	inputDirs = inputDirs + "../training_area/Weka_Output/";
	outputDirs = inputDirs + "../Weka_Output_Thresholded/";
	firstStage = true;
}

// Code for the first half of the pipeline
if(firstStage) {
	inputDirList = getFileList(inputDirs);
	outputDirList = getFileList(outputDirs);

	// Call threshold over each classifier in Weka Output
	for (z = 0; z< inputDirList.length; z++) {	
		input = inputDirList[z];
		output = outputDirList[z];
		
		// Holds all file names from input folder
		list = getFileList(inputDirs + input);
		
		// Iterate macro over each image in the classifier folder
		for (q = 0; q < list.length; q++) {
			action(input, output, list[q]);
		}
			
		// Threshold each image and convert to black-white image
		function action(input, output, filename) {      
			open(inputDirs + input + filename);
			run("8-bit");
			setAutoThreshold("Default");
			setOption("BlackBackground", true);
			run("Convert to Mask");
			saveAs("Png", outputDirs + output + filename);	
		}
	}
} else {
	// Holds all file names from input folder
	list = getFileList(inputDirs);
		
	// Iterate macro over each image in the input folder for this specific classifier
	for (q = 0; q < list.length; q++) {
		actionTwo(inputDirs, outputDirs, list[q]);
	}
	
	// Threshold each image and convert to black-white image
	function actionTwo(input, output, filename) {       
		open(input + "/" + filename);
		run("8-bit");
		setAutoThreshold("Default");
		setOption("BlackBackground", true);
		run("Convert to Mask");
		saveAs("Png", output + filename);	
	}
}
print("Finished just_thresh.ijm\n");