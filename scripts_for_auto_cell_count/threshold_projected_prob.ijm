/*
 * Author: Theo, Tyler Jang
 * Date: 5/19/2022
 * 
 * Input: Projected Images
 * Output: Thresholded Projected Images
 * Description: Takes the projected images and thresholds them to the cut off value specified by the user.
 */
setBatchMode(true); 
print("Starting threshold_projected_prob.ijm");


// Get the threshold from user
Dialog.create("Set cutoff");
cutoff = 0.5;
Dialog.addNumber("Cutoff for cell pixels[0,1], default = 0.5:", cutoff);
Dialog.show();

// Weka Output
arg1 = getArgument();
// Weka Output Thresholded
outputDirs = "";

// Get the classifier
selectedClassifier = split(arg1, "/");

firstStage = true;

// Check if the argument is from testing or training area
if(arg1.contains("testing_area")) {
	
	inputDirs = arg1 + "/../../Weka_Probability_Projected/"+ selectedClassifier[selectedClassifier.length-1] + "/";
	outputDirs = arg1 + "/../../Weka_Output_Projected/" + selectedClassifier[selectedClassifier.length-1] + "/";
	
	firstStage = false;
} else {
	inputDirs = arg1 + "../Weka_Probability_Projected/";
	outputDirs = arg1;
	firstStage = true;
}

// Code for the first half of the pipeline
if(firstStage) {
	inputDirList = getFileList(inputDirs);
	outputDirList = getFileList(outputDirs);

	// Call threshold over each classifier in Weka Probabilty Projected
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
			//run("Threshold...");
			setThreshold(0, cutoff);
			//setOption("BlackBackground", false);
			//run("Convert to Mask");
			setOption("BlackBackground", true);
			run("Convert to Mask");
			//run("Invert");
			saveAs("tiff", outputDirs + output + filename);
			close();
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
		//run("Threshold...");
		setThreshold(0, cutoff);
		setOption("BlackBackground", true);
		run("Convert to Mask");
		//run("Invert");
		saveAs("tiff", output + filename);
		close();	
	}
}
print("Finished threshold_projected_prob.ijm\n");