/**
 * Author: Theo Kataras, Tyler Jang
 * Date: 3/9/2022
 * 
 * Input: Binary images, hand placed markes in roi files, one file for each image
 * Output: Binary image files including only cells counted, and .csv file in classifier folder with accuracy information
 * Description: Uses hand placed markers and weka output images from each classifier to begin accuracy calculation
 */

// This hides intermediary information and speeds processing
setBatchMode(true); 
	
print("Starting audit_count.ijm");
	
// Select the classifier
inputDir = getArgument();
// Holds all file names from input folders
list = getFileList(inputDir);
	
// Get the classifier
x = split(inputDir, "/");
selectedClassifier = x[x.length-1];

// Data output location
outputDir = inputDir + "/../../Results/";
	
// Audit Hand Counts
dirVal = inputDir + "/../../Audit_Hand_Counts/"+ selectedClassifier + "/";
listVal = getFileList(dirVal);
	
// Clear the results table
run("Clear Results");
	
// Set size minimum for cells to exclude small radius noise and large artifacts
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


// Have to initialize at -1 to start correctly at 0
rowNumber = -1;
		
// Iterate macro over the images in the classifier folder
for (q = 0; q < list.length; q++) {
	action(selectedClassifier, outputDir, list[q], dirVal, listVal[q]);
}
			
// Opens and thresholds binary images or Weka output directly       
function action(input, output, filename, inputTwo, filenameTwo) {    	
	open(inputDir + filename);
	run("8-bit");
	setAutoThreshold("Default dark");
	run("Threshold...");
	setThreshold(6, 255);
	run("Convert to Mask");
	//run("Invert");

	// Fill in small pixel gaps to complete objects
	run("Fill Holes");

	// Clear any existing rois
	if (roiManager("count") > 0) {
		roiManager("deselect");		
		roiManager("Delete");
	}  

	// Apply the watershed algorithm if true
	if(ifWatershed) {
		run("Watershed");
	}
	
	// This imageJ plugin creates the results file and image of the count cells based on the size exclusion		
	run("Analyze Particles...", "size=" + sizeMin + "-" + sizeMax + " pixel show=Masks display summarize add");

	

	counts = 0;
	// Stop empty auto count images here 
	getRawStatistics(nPixels, mean, min, max, std, histogram);
	if (max == 0) {	
	// Case where the first image contained no auto counts
		if (rowNumber == -1) {
			rowNumber = 0;
		}
		// Save measurement data for the empty image
		numRoi = 0;
		run("Measure");
		setResult("points", rowNumber++, counts);
	} else {	
		// Measuring a full image after the objects, to keep parity with the empty images
		run("Measure");
		rowNumber++;
		
		// Need to deal with case where human marked no cells and saved placeholder, but program has objects
		// This is with hand counts and auto counts
		if (endsWith(filenameTwo, ".roi")) {	
			open(inputTwo + filenameTwo);
			roiManager("Add");
			
			// Establish number of objects
			numRoi = roiManager("count"); 
						
			roiManager("Select", numRoi - 1);

			pts = Roi.getCoordinates(xPoints2, yPoints2); //get info for all hand places counts	
				
			numPoints = lengthOf(yPoints2); // establish number of hand placed counts	
			numRoiTwo = numRoi - 1;//subtract one for the multipoint ROI containing the hand count info

		} else {
			// This is the case where the hand count found no cells, but the auto count did
			numPoints = 0;//set the number of hand counts to 0
			numRoiTwo = roiManager("count");
			xPoints2 = 99999;//these need to be a point that will never overlap with objects in the image
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
		}//each object in image	
		roiManager("deselect");		
		roiManager("Delete");       
	} //else
} //function endpoint
selectWindow("Results");
saveAs("Results", outputDir + selectedClassifier + "_Results_Audit.csv");
run("Clear Results");
	
// iterate through folders
// Prints text in the log window after all files are processed
print("Counted " + list.length + " images");
print("Finished audit_count.ijm\n");

updateResults();