/*
 * Author: Theo Kataras, Tyler Jang
 * Date: 2/9/2022
 * 
 * Input: Binary images, hand placed markes in roi files, one file for each image
 * Output: Binary image files including only cells counted, and .csv file in classifier folder with accuracy information
 * Description:
 Uses hand placed markers and weka output images from each classifier to begin accuracy calculation
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
	
probDirs = inputDirs + "/../../Weka_Probability/" + selectedClassifier[selectedClassifier.length - 1];

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
	inputDirList = getFileList(inputDirs);
	probDirList = getFileList(probDirs);

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
		run("Fill Holes"); //prevents any measurement discrepancies in Imagej

		
		//clear any existing rois
		if (roiManager("count") > 0) {
			roiManager("deselect");		
			roiManager("Delete");
		}  

		// Call the watershed algorithm to split objects
		//run("Watershed");
		
		// This imageJ plugin creates the results file and image of the count cells based on the size exclusion		
		run("Analyze Particles...", "size=" + sizeMin + "-" + sizeMax + " pixel show=Masks summarize add");

		// Save the resulting counted image
		saveAs("Png", output + "/" + filename);
		
		//close the counted image, open the probaility image and measure the objects on it instead
		//close();

		//stop empty auto count images here 
		// TODO what if image is not empty, but the particle is so small it gets passed by
		// TODO this would also be an act one problem
		getRawStatistics(nPixels, mean, min, max, std, histogram);
		if (max == 0) {
			if (rowNumber == -1) {
				rowNumber = 0;
			}
			numRoi = 0;
			run("Measure");
			setResult("points", rowNumber++, numRoi);
				
			//roiManager("deselect");
			//roiManager("Delete"); 
			print(filename + " this was an empty image");
		} else {
			//using the classifier from input, not prob, should be fine, could be used elsewehre
			open(probDirs + "/" + filenameP);
			roiManager("measure");
			close();
			
			// Measuring a full image after the objects, to keep parity with the empty images
			run("Measure");	
			rowNumber++;

			// Establish number of objects
			numRoi = roiManager("count"); 
			print("Number of auto counted objects = " + numRoi);
	
			//print(numRoi);
			//totalCount = totalCount + numRoi;

			
		}
	}
			
	roiManager("deselect")		
	roiManager("Delete");       
	
	selectWindow("Results");
	
	// Takes / off end of folder name to get classifier ID
	className = selectedClassifier[selectedClassifier.length - 1];
	saveAs("Results", outputDirs + "/" + className + "_Results_test_data.csv");
 
	run("Clear Results");
	
	// Prints text in the log window after all files are processed
	print("Counted " + inputDirList.length + " images");
	//print("Counted a total of " + totalCount + " cells");
	print("Finished count_full_dataset_prob.ijm\n");
}
updateResults();