/*
 * Author: Theo Kataras, Tyler Jang
 * Date: 2/9/2022
 * 
 * Input: Binary images, hand placed markes in roi files, one file for each image
 * Output: Binary image files including only cells counted, and .csv file in classifier folder with accuracy information
 * Description:
 Uses hand placed markers and weka output images from each classifier to begin accuracy calculation
 */
macro "The -- Audit -- Count" {
	// This hides intermediary information and speeds processing
	setBatchMode(true); 
	
	print("Starting count_full_dataset.ijm");
	
	// Weka Output Projected if Projected, else Weka Output Thresholded
	input = getArgument();


	// Get the classifier
	x = split(input, "/");
	selectedClassifier = x[x.length-1];
	
	// Weka Output Counted
	output = input + "/../../Audit_Images/" + selectedClassifier + "/";
	
// Validation Hand Counts
	dirVal = input + "/../../Audit_Hand_Counts/";
	listVal = getFileList(dirVal);
	
	// Track the total cell count
	totalCount = 0;
	
	// Clear the results table
	run("Clear Results");

	// Set size minimum for cells to exclude small radius noise
	sizeMin = 20;
	sizeMax = 1000;
	Dialog.create("Size Values");
	Dialog.addNumber("Minimum pixel size for object count:", sizeMin);
	Dialog.addNumber("Maximum pixel size for object count:", sizeMax);
	Dialog.show();
	sizeMin = Dialog.getNumber();
	
sizeMax = Dialog.getNumber();
	print(sizeMin);
	print(sizeMax);
	
	// Gets the images for the selected classifier
	list = getFileList(input);
	

	rowNumber = -1;
	
// Iterate macro over the images in the classifier folder
		for (q = 0; q < list.length; q++) {
			action(input, output, list[q], dirVal, listVal[q] );
		}
			
		// Opens and thresholds binary images or Weka output directly       
		function action(input, output, filename, inputTwo, filenameTwo) {    	
			open(input + input + filename);
			run("8-bit");
			
			run("Invert");
			run("Fill Holes"); //prevents any measurement discrepancies in Imagej


			//clear any existing rois
			if (roiManager("count") > 0) {
				roiManager("deselect");		
				roiManager("Delete");
			}  
			
			
			
			
		
			//close the counted image, open the probaility image and measure the objects on it instead
		//	close();
			

			counts = 0;
			//stop empty auto count images here 
			getRawStatistics(nPixels, mean, min, max, std, histogram);
			if (max == 0) {
				if (rowNumber == -1) {
					rowNumber = 0;
				}
				numRoi = 0;
				open(inputP + input + filenameP);
				run("Measure");
				close();
				setResult("points", rowNumber++, counts);
				
				//roiManager("deselect");
				//roiManager("Delete"); 
				//print(filename + " this was an empty image");
			} else {	
				//print(filename + " this was an image with cells (after the else)");

			
			

					
				// Measuring a full image after the objects, to keep parity with the empty images
				run("Measure");
				rowNumber++;
	
				//need to deal with case where human marked no cells and saved placeholder, but program has objects
				// This is with hand counts and auto counts
				if (endsWith(filenameTwo, ".roi")) {
					
					open(inputTwo + filenameTwo);
					roiManager("Add");

					//TODO need to save the exact roi info for each auto object
				 	// Establish number of objects
					numRoi = roiManager("count"); 
				
					roiManager("select", numRoi - 1);
//					print("this is roi name being used for hand count coords"  + Roi.getName); //I THINK THE ISSUE MAY BE HERE IN THE assignment of the hand count roi coords???!?!?!?!?!
					pts = Roi.getCoordinates(xPoints2, yPoints2); //get info for all hand places counts

					
					//roiManager("Delete"); //just added this to test !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!312312313
					numPoints = lengthOf(yPoints2); // establish number of hand placed counts	
					numRoiTwo = numRoi - 1;//subtract one for the multipoint ROI containing the hand count info

				} else {
					//this is the case where the hand count found no cells, but the auto count did
					numPoints = 0;//set the number of hand counts to 0
//					print("this is the case where the hand count found no cells, but the auto count did");
					numRoiTwo = roiManager("count");
					xPoints2 = 99999;//these need to be a point that will never overlap with objects in the image
					yPoints2 = 99999;
				}
		
				// For each object k in the image
				for (k = 0; k < numRoiTwo; k++) {   
					roiManager("Select", k);
//					print("this is roi name being examined"  + Roi.getName); //I THINK THE ISSUE MAY BE HERE IN THE assignment of the hand count roi coords???!?!?!?!?!

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
						 // each hand placed count
					} // each pixel in object
					// Update the results table
					setResult("points", rowNumber++, counts);
				}//each object in image	
				
			    
			} //else
		} //function endpoint
		selectWindow("Results");
		
		// Take / off end of folder name to get classifier ID
		
		saveAs("Results", output + selectedClassifier + "_Results.csv");
		run("Clear Results");
	}// iterate through folders
	
	// Prints text in the log window after all files are processed
	print("Counted " + list.length + " images");
	print("Finished count_over_dir.ijm\n");
}
updateResults();