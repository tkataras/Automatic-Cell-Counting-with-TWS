/**
 * Author: Theo Kataras, Tyler Jang
 * Date: 11/30/2021
 * 
 * Input: Binary images, hand placed markes in roi files, one file for each image
 * Output: Binary image files including only cells counted, and .csv file in classifier folder with accuracy information
 * Description: Uses hand placed markers and weka output images from each classifier to begin accuracy calculation
 */
macro "The -- True -- Count" {
	// This hides intermediary information and speeds processing
	setBatchMode(true); 
	
	print("Starting count_over_dir.ijm");
	
	// Weka Output Projected if Projected, else Weka Output Thresholded
	inputDirs = getArgument();
	
	// Weka Output Counted
	outputDirs = inputDirs + "../Weka_Output_Counted/";
	
	// Clear the results table
	run("Clear Results");
	
	// Set size minimum for cells to exclude small radius noise
	size_min=20;
	Dialog.create("Size Min");
	Dialog.addNumber("Minimum pixel size for object count:", size_min);
	Dialog.show();
	size_min = Dialog.getNumber();
	
	// Validation Hand Counts
	dirTwo = inputDirs + "../Validation_Hand_Counts/";
	
	// Gets the folders for each classifier
	inputDirList = getFileList(inputDirs);
	outputDirList = getFileList(outputDirs);
		
	// This loop iterates through classifier folders
	for (z = 0; z < inputDirList.length; z++) {		
		input = inputDirList[z];
		output = outputDirList[z];
			
		// Holds all file names from input folder
		list = getFileList(inputDirs + input);
		listTwo = getFileList(dirTwo);
		
		n = 0;
		
		// Iterate macro over the images in the classifier folder
		for (q = 0; q < list.length; q++) {
			action(input, output, list[q], dirTwo, listTwo[q]);
		}
			
		// Opens and thresholds binary images or Weka output directly       
		function action(input, output, filename, inputTwo, filenameTwo) {    	
			open(inputDirs + input + filename);
			run("8-bit");
			setAutoThreshold("Default dark");
			run("Threshold...");
			setThreshold(6, 255);
			run("Convert to Mask");
					
			// This imageJ plugin creates the results file and image of the count cells based on the size exclusion		
			run("Analyze Particles...", "size=" + size_min + "-Infinity pixel show=Masks display summarize add");
			saveAs("Png", outputDirs + output + filename);
				
			open(inputTwo + filenameTwo);
			roiManager("Add");
			
			//TODO need to save the exact roi info for each auto object
		 	// Establish number of objects
			numRoi = roiManager("count"); 
				
			roiManager("Select", numRoi - 1);
			pts = Roi.getCoordinates(xPoints2, yPoints2); 
			numPoints = lengthOf(yPoints2); // establish number of hand placed counts	
			numRoiTwo = numRoi - 1;

			// For each object k in the image
			for (k = 0; k < numRoiTwo; k++) {   
				roiManager("Select", k);
				// Get coords for all pixels in object
				test = Roi.getContainedPoints(xPoints, yPoints); 
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
				}
					
				// Update the results table
				setResult("points", n++, counts);	
			}
			roiManager("deselect")		
			roiManager("Delete");       
		}
		selectWindow("Results");
		
		// Take / off end of folder name to get classifier ID
		class_name = substring(outputDirList[z], 0, lengthOf(outputDirList[z]) -1);
		saveAs("Results", outputDirs + output + class_name + "_Results.csv");
		run("Clear Results");
	}
	// Prints text in the log window after all files are processed
	print("Counted " + list.length + " images");
	print("Finished count_over_dir.ijm\n");
}
updateResults();