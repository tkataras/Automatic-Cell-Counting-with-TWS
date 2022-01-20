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
	//!!!!!!!!!!!!!!!!!!!!!!!I CHANGED THIS TO ONLY USE 2 CLASS FOLDERS FoR teSTING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	//for (z = 0; z < inputDirList.length; z++) {
	for (z = 0; z < 2; z++) {
		input = inputDirList[z];
		output = outputDirList[z];
			
		// Holds all file names from input folder
		list = getFileList(inputDirs + input);
		listTwo = getFileList(dirTwo);
		
		n = 0;
//do i need this???
		
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

			
					//size_min = 20
			// This imageJ plugin creates the results file and image of the count cells based on the size exclusion		
			run("Analyze Particles...", "size=" + size_min + "-Infinity pixel show=Masks display summarize add");
			//selectImage("Mask of " + filename);     //JUST COMMENteD OUT TO TEST !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
			saveAs("Png", outputDirs + output + filename);

			
			//stop empty auto count images here 
			getRawStatistics(nPixels, mean, min, max, std, histogram);
			if (max == 0) {
				numRoi = 0;
				counts = 0;
				run("Measure");
				setResult("points", n++, counts);
				
				//roiManager("deselect");
				//roiManager("Delete"); 
				print(filename + " this was an empty image");
			}else {
print(filename + " this was an image with cells (after the else)");
			run("Measure");//measuring a full image after the objects, to keep parity with the empty images
			print(filenameTwo + "=filename2 the hand count");

			//need to deal with case where human marked no cells and saved placeholder, but program has objects
			if (endsWith(filenameTwo, ".roi")) {
				
			open(inputTwo + filenameTwo);
			roiManager("Add");

			//TODO need to save the exact roi info for each auto object
		 	// Establish number of objects
			numRoi = roiManager("count"); 
				
			roiManager("Select", numRoi - 1);
			print("this is roi name being used for hand count coords"  + Roi.getName); //I THINK THE ISSUE MAY BE HERE IN THE assignment of the hand count roi coords???!?!?!?!?!
			pts = Roi.getCoordinates(xPoints2, yPoints2); //get info for all hand places counts
			//roiManager("Delete"); //just added this to test !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!312312313
			numPoints = lengthOf(yPoints2); // establish number of hand placed counts	
			numRoiTwo = numRoi - 1;//subtract one for the multipoint ROI containing the hand count info

			
			} else {
				
				//this is the case where the hand count found no cells, but the auto count did
				numPoints = 0;//set the number of hand counts to 0
				print("this is the case where the hand count found no cells, but the auto count did");
				numRoiTwo = roiManager("count");
				xPoints2 = 99999;//these need to be a point that will never overlap with objects in the image
				yPoints2 = 99999;
			}

			
			
			
			

			// For each object k in the image
			for (k = 0; k < numRoiTwo; k++) {   
				roiManager("Select", k);
print("this is roi name being examined"  + Roi.getName); //I THINK THE ISSUE MAY BE HERE IN THE assignment of the hand count roi coords???!?!?!?!?!

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
							print("count sum" + counts);// ADDED THIS FOR TESTING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
						

						}
 else {}// counting if statement; else: counts stays at 0
					}
 // each hand placed count
				} // each pixel in object
				
					
				// Update the results table
				setResult("points", n++, counts);
				
			
}//each object in image
			
			roiManager("deselect")		
			roiManager("Delete");       
			}//else
		}//function endpoint
		//}//for z input dir list length
		selectWindow("Results");
		
		// Take / off end of folder name to get classifier ID
		class_name = substring(outputDirList[z], 0, lengthOf(outputDirList[z]) -1);
		saveAs("Results", outputDirs + output + class_name + "_Results.csv");
		run("Clear Results");
	}//
 iterate through folders
	// Prints text in the log window after all files are processed
	print("Counted " + list.length + " images");
	print("Finished count_over_dir.ijm\n");

}
updateResults();