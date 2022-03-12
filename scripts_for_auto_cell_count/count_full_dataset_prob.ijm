/*
 * Author: Theo Kataras, Tyler Jang
 * Date: 2/17/2022
 * 
 * Input: Binary images, hand placed markes in roi files, one file for each image
 * Output: Binary image files including only cells counted, and .csv file in classifier folder with accuracy information
 * Description: Uses hand placed markers and weka output images from each classifier to begin accuracy calculation
 */
macro "The -- True -- Count" {
	// This hides intermediary information and speeds processing
	setBatchMode(true); 
	
	print("Starting count_full_dataset_prob.ijm");
	
	// Weka Output Projected if Projected, else Weka Output Thresholded
	inputDirs = getArgument();

	// Get the classifier
	selectedClassifier = split(inputDirs, "/");

	// Weka Output Counted
	outputDirs = inputDirs + "/../../Weka_Output_Counted/" + selectedClassifier[selectedClassifier.length - 1];



	// Weka Probability


// Check if we used projected images
if(inputDirs.contains("Weka_Output_Projected")) {
	probDirs = inputDirs + "/../../Weka_Probability_Projected/" + selectedClassifier[selectedClassifier.length - 1];
	projected = true;
	print("Projected Images");
} else {
	probDirs = inputDirs + "/../../Weka_Probability/" + selectedClassifier[selectedClassifier.length - 1];

	projected = false;
	
}



	

	// Track the total cell count
	totalCount = 0;
	
	// Clear the results table
	run("Clear Results");

	// Set size minimum for cells to exclude small radius noise
	sizeMin = 20;
	sizeMax = 1000;
	isWatershed = true;
	Dialog.create("Size Values");
	Dialog.addNumber("Minimum pixel size for object count:", sizeMin);
	Dialog.addNumber("Maximum pixel size for object count:", sizeMax);
	Dialog.addCheckbox("Do you want to apply the Watershed algorithm", true);
	Dialog.show();
	sizeMin = Dialog.getNumber();
	sizeMax = Dialog.getNumber();
	ifWatershed = Dialog.getCheckbox();
	print("Minimum Pixel Size: " + sizeMin);
	print("Maximum Pixel Size: " + sizeMax);
	
	// Gets the images for the selected classifier
	inputDirList = getFileList(inputDirs);
	probDirList = getFileList(probDirs);

	// Initialize the csv row at -1 to start correctly at 0 when handling empty images
	rowNumber = -1;
	
	// Iterate macro over the images in the input folder
	for (q = 0; q < inputDirList.length; q++) {
		action(inputDirs, outputDirs, inputDirList[q], probDirList[q]);
	}
			
	// Opens and thresholds binary images or Weka output directly       
	function action(input, output, filename, filenameP) {    
		open(input + "/" + filename);
		run("8-bit");
		setAutoThreshold("Default dark");
		run("Threshold...");
		setThreshold(6, 255);
		run("Convert to Mask");
		run("Invert");

		// Fill in small pixel gaps to complete objects
		run("Fill Holes"); 
		
		//clear any existing rois
		if (roiManager("count") > 0) {
			roiManager("deselect");		
			roiManager("Delete");
		}  

		// Apply the watershed algorithm if true
		if(ifWatershed) {
			run("Watershed");
		}
		
		// This imageJ plugin creates the results file and image of the count cells based on the size exclusion		
		run("Analyze Particles...", "size=" + sizeMin + "-" + sizeMax + " pixel show=Masks summarize add");

		// Save the resulting counted image
		saveAs("Png", output + "/" + filename);

		// Get info about the images to see if it is empty
		getRawStatistics(nPixels, mean, min, max, std, histogram);

		// Stop empty auto count images here 
		if (max == 0) {
			// Case where the first image contained no auto counts
			if (rowNumber == -1) {
				rowNumber = 0;
			}
			// Save measurement data for the empty image
			numRoi = 0;
			run("Measure");
			setResult("points", rowNumber++, numRoi);
		// Image contains auto counted objects
		} else {
			// Using the classifier from input, not prob, should be fine, could be used elsewehre
			open(probDirs + "/" + filenameP);
			roiManager("measure");
			close();
			
			// Measuring a full image after the objects, to keep parity with the empty images
			run("Measure");	
			rowNumber++;

			// Establish number of objects
			numRoi = roiManager("count"); 
			print("Number of auto counted objects = " + numRoi);
		}
	}	
	roiManager("deselect")		
	roiManager("Delete");       	
	selectWindow("Results");
	
	// Takes / off end of folder name to get classifier ID
	className = selectedClassifier[selectedClassifier.length - 1];
	saveAs("Results", outputDirs + "/" + className + "_Results_test_data.csv");

 	// Clear the results window
	run("Clear Results");
	
	// Prints text in the log window after all files are processed
	print("Counted " + inputDirList.length + " images");
	print("Finished count_full_dataset_prob.ijm\n");
}
updateResults();