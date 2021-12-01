/*
 * Author: Theo Kataras, Tyler Jang
 * Date: 11/30/2021
 * 
 * Input: Binary images, hand placed markes in roi files, one file for each image
 * Output: Binary image files including only cells counted, and .csv file in classifier folder with accuracy information
 * Description: Uses hand placed markers and weka output images from each classifier to begin accuracy calculation
 */
macro "The -- True -- Count" {
	//Remove old results
	run("Clear Results");

	//this hides intermediary information and speeds processing
	setBatchMode(true); 
	
	print("Starting count_full_dataset.ijm");
	
	// Weka Output Projected if Projected, else Weka Output Thresholded
	inputDirs = getArgument();

	// Get the classifier
	selectedClassifier = split(inputDirs, "/");

	// Weka Output Counted
	outputDirs = inputDirs + "/../../Weka_Output_Counted/" + selectedClassifier[selectedClassifier.length - 1];
	
	// Set size minimum for cells to exclude small radius noise
	size_min=20;
	Dialog.create("Size Min");
	Dialog.addNumber("Minimum pixel size for object count:", size_min);
	Dialog.show();
	size_min = Dialog.getNumber();
	
	
	// Holds all file names from input folder
	list = getFileList(inputDirs);	
	n = 0;
		
	// Iterate macro over the images in the input folder
	for (q = 0; q < list.length; q++) {
		action(inputDirs, outputDirs, list[q]);
	}
			
	// Opens and thresholds binary images or Weka output directly       
	function action(input, output, filename) {    
		open(input + "/" + filename);
		run("8-bit");
		setAutoThreshold("Default dark");
		run("Threshold...");
		setThreshold(6, 255);
		run("Convert to Mask");
						
		// This imageJ plugin creates the results file and image of the count cells based on the size exclusion		
		run("Analyze Particles...", "size=" + size_min + "-Infinity pixel show=Masks display summarize add");

		// Save the resulting counted image
		saveAs("Png", output + "/" + filename);
		run("Measure");	

		// Establish number of objects
		numRoi = roiManager("count"); 
		print("Number of auto counted objects = " + numRoi - 1);	
	}			
	roiManager("deselect")		
	roiManager("Delete");       
	
	selectWindow("Results");
	
	// Takes / off end of folder name to get classifier ID
	className = selectedClassifier[selectedClassifier.length - 1];
	saveAs("Results", outputDirs + "/" + className + "_Results_test_data.csv"); // **#*#*CANT FIND THIS FILE ANYWHERE*#*#*#*##*
	run("Clear Results");
	
	// Prints text in the log window after all files are processed
	print("Counted " + list.length + " images");
	print("Finished count_full_dataset\n");
}
updateResults();