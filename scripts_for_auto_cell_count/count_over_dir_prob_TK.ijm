/**
 * Author: Theo Kataras, Tyler Jang
 * Date: 5/19/2022
 * 
 * Input: Binary images, hand placed markes in roi files, one file for each image
 * Output: Binary image files including only cells counted, and .csv file in classifier folder with accuracy information
 * Description: Uses hand placed markers and weka output images from each classifier to begin accuracy calculation
 */
macro "The -- True -- Count" {
	// This hides intermediary information and speeds processing
	setBatchMode(true); 
	
	print("Starting count_over_dir_prob_TK.ijm");
	
	// Weka Output Projected if Projected, else Weka Output
	inputDirs = getArgument();
	
	// Weka Output Counted
	outputDirs = inputDirs + "../Weka_Output_Counted/";
	
	// Weka Probability
	// Check if we used projected images
	if(matches(inputDirs, ".*Weka_Output_Projected.*")) {
		probDirs = inputDirs + "../Weka_Probability_Projected/";
		projected = true;
		print("Projected Images");
	} else {
		probDirs = inputDirs + "../Weka_Probability/";
		projected = false;
	}
	
	// Clear the results table
	run("Clear Results");
	
	// Set size minimum for cells to exclude small radius noise and large artifacts
	sizeMin = 20;
	sizeMax = 1000;
	ifWatershed = true;
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
	
	// Validation Hand Counts
	dirVal = inputDirs + "../Validation_Hand_Counts/";
	
	// Gets the folders for each classifier
	inputDirList = getFileList(inputDirs);
	outputDirList = getFileList(outputDirs);
	probDirList = getFileList(probDirs);
		
	// This loop iterates through classifier folders
	for (z = 0; z < inputDirList.length; z++) {
		input = inputDirList[z];
		output = outputDirList[z];
		prob =  probDirList[z];
			
		// Holds all file names from input folders
		list = getFileList(inputDirs + input);
		listVal = getFileList(dirVal);
		listProb = getFileList(probDirs + prob);
		
		// Initialize the csv row at -1 to start correctly at zero for handling empty images
		rowNumber = -1;
		
		// Iterate macro over the images in the classifier folder
		for (q = 0; q < list.length; q++) {
			action(input, output, list[q], dirVal, listVal[q], listProb[q], probDirs);
		}
			
		// Opens and thresholds binary images or Weka output directly       
		function action(input, output, filename, inputTwo, filenameTwo, filenameP, inputP) {    	
			open(inputDirs + input + filename);
			run("8-bit");
			setAutoThreshold("Default dark");
			run("Threshold...");
			setThreshold(6, 255);
			run("Convert to Mask");
			run("Invert");
			
			// Fill in small pixel gaps to complete objects
			run("Fill Holes");

		
			// Apply the watershed algorithm if true
			if(ifWatershed) {
				run("Watershed");
			}
			
			// Clear any existing rois
			if (roiManager("count") > 0) {
				roiManager("deselect");		
				roiManager("Delete");
			}  
						
			// This imageJ plugin creates the results file and image of the count cells based on the size exclusion		
			run("Analyze Particles...", "size=" + sizeMin + "-" + sizeMax + " pixel show=Masks summarize add");
			
			// Saving the image of the counted objects
			saveAs("Png", outputDirs + output + filename);
	
			// Number of counted objects
			counts = 0;
			
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
				setResult("points", rowNumber++, counts);
				
			// Image contains auto counted objects
			} else {	
				// Look at the probabilty maps for the images
				open(inputP + input + filenameP);
				roiManager("measure");
				close();
					
				// Measuring a full image after the objects, to keep parity with the empty images
				run("Measure");
				rowNumber++;
	
				// Images with hand counts and auto counts
				if (endsWith(filenameTwo, ".roi")) {
					open(inputTwo + filenameTwo);
					roiManager("Add");

				 	// Establish number of objects
					numRoi = roiManager("count"); 
					roiManager("select", numRoi - 1);

					// Get info for all hand places counts
					pts = Roi.getCoordinates(xPoints2, yPoints2); 

					// Establish number of hand placed counts	
					numPoints = lengthOf(yPoints2); 
					
					// Subtract one for the multipoint ROI containing the hand count info
					numRoiTwo = numRoi - 1;


				// Case where the hand count found no cells, but the auto count did
				} else {
					// Set the number of hand counts to 0
					numPoints = 0;
					numRoiTwo = roiManager("count");
					
					// Set point that will never overlap with objects in the image
					xPoints2 = 99999;
					yPoints2 = 99999;
				}
		
				// For each object k in the image
				for (k = 0; k < numRoiTwo; k++) {   
					roiManager("Select", k);

					// Get coords for all pixels in object
					Roi.getContainedPoints(xPoints, yPoints); 

					// Length of all pixels in current object, this varies
					len = lengthOf(xPoints);
					
					// Length of hand placed counts, this does not vary 
					lenTwo = numPoints; 

					counts = 0;
					// For each pixel in the object
					for (i = 0 ; i < len ; i++) {
					
						// For each hand placed count
						for(j = 0; j < lenTwo ; j++) {
							xPoints2rnd = round(xPoints2[j]);
							yPoints2rnd = round(yPoints2[j]);
							
							// If the object contains the hand count, increment counts
							if (xPoints[i] == xPoints2rnd && yPoints[i] == yPoints2rnd) {
								counts = counts + 1;
							} 
						}
						 // Each hand placed count
					} // Each pixel in object
					// Update the results table
					setResult("points", rowNumber++, counts);
				} // Each object in image	
  
			} // Else
		} // Function endpoint
		selectWindow("Results");
		
		// Take "/" off end of folder name to get classifier ID
		className = substring(outputDirList[z], 0, lengthOf(outputDirList[z]) -1);
		saveAs("Results", outputDirs + output + className + "_Results.csv");
		run("Clear Results");
	} // Iterate through folders
	
	// Prints text in the log window after all files are processed
	print("Counted " + list.length + " images");
	print("Finished count_over_dir_prob_TK.ijm\n");
}
updateResults();
