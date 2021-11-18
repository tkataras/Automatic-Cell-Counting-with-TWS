//count of dir for the audit

/*
 * Author: Theo, Tyler
 * Date: 10/21/2021
 * Description:
 */
macro "The -- Audit -- Count" {
	//Overview: uses hand placed markers and weka output images from each classifier to begin accuracy calculation
	//Input: Binary images, hand placed markes in roi files, one file for each image
	//Output: Binary image files including only cells counted, and .csv file in classifier folder with accuracy information
	
	//this hides intermediary information and speeds processing
	setBatchMode(true); 

		// set size minimum for cells to exclude small radius noise
	size_min=20;
	Dialog.create("Size Min");
	Dialog.addNumber("Minimum pixel size for object count:", size_min);
	Dialog.show();
	size_min = Dialog.getNumber();

	
	//set input and output directories locations
	
	// Weka Output Projected if Projected, else Weka Output Thresholded
	arg1 = getArgument();

	// Get the classifier
	x = split(arg1, "/");
	selectedClassifier = x[x.length-1];
	
	//need the counted audit images
	input = arg1 + "/../../Audit_Counted/" + selectedClassifier + "/";
	
	// Clear the results table
	run("Clear Results");
	
	//the hand placed roi location will not change as it is applied to each classifier image set
	//dir2 = getDirectory("_Choose source directory for the roi multipoint counts");
	output = arg1 + "/../../Audit_Hand_Counts/" + selectedClassifier + "/";
	outResults = arg1 + "/../../Audit_Hand_Counts/"
	// TODO tell it not to grab csv files
	//holds all file names from input folder
	list = getFileList(input);
	list2 = getFileList(output);
			
	n = 0;
			
	//iterate  macro over the images in the input folder
	for (q = 0; q < list.length; q++) {
		action(input, output, list[q], list2[q]);
	}
			
		//describes the actions for each image
		function action(input, output, filename, filename2) {    
			//opens and thresholds binary images or Weka output directly       
			print("hi");
			print( input + filename);
			print("hi");
			open( input + filename);
			run("8-bit");
			setAutoThreshold("Default dark");
			run("Threshold...");
			setThreshold(6, 255);
			//setOption("BlackBackground", true);	
			run("Convert to Mask");
			//run("Invert");
					
			// this imageJ plugin creates the results file and image of the count cells based on the size exclusion		
			run("Analyze Particles...", "size="+size_min+"-Infinity pixel show=Masks display summarize add");
			//saveAs("Png",output_dirs + output + filename);

	//this if statement is made to allow the program to cycle over image files saved in the hand count folder to signify empty image
		if (endsWith(filename2, ".roi") > 0) {
			open(output + filename2);
			roiManager("Add");
			
			numroi = roiManager("count"); // establish number of objects
				
			roiManager("Select", numroi - 1);
			pts = Roi.getCoordinates(xpoints2, ypoints2); 
			numpoints = lengthOf(ypoints2); // establish number of hand placed counts
			print(numpoints + "_hand_placed_markers");
			print("number auto count objects=" + numroi -1);
				
			numroi2 = numroi -1;
				
				
			for (k = 0; k < numroi2; k++) {   //k is repeated for each object
				roiManager("Select", k);
				test = Roi.getContainedPoints(xpoints, ypoints); // get coords for all pixels in object
				lng = lengthOf(xpoints); //length of all pixels in current object, this varies
				lng2 = numpoints; //length of hand placed counts, this does not vary
									
				counts = 0;
				for (i = 0 ; i < lng ; i++) {
					for(j = 0; j < lng2 ; j++) {
						xpoints2rnd = round(xpoints2[j]);
						ypoints2rnd = round(ypoints2[j]);
							
						if (xpoints[i] == xpoints2rnd && ypoints[i] == ypoints2rnd) {
							counts = counts + 1;
						}
					}
				}
					
				//update the results table
				setResult("points", n++, counts);	
			}
			} else {
				//this block will add a row to the results file signifying an emapy image. the dimensions of the roi will be very large comparitively
      			print("no hand counts in " + filename2);
      			open(output + filename2);
      			run("Select All");
      			run("Measure");
      			roiManager("Add");
      			counts = 0;
      			//update the results table
				setResult("points", n++, counts); //testing this
   			}   
			roiManager("deselect");		
			roiManager("Delete");       
		}
		selectWindow("Results");
		
		
		saveAs("Results", outResults + "/" + selectedClassifier + "_testing_Results.csv");
		//run("Clear Results");
	
	// prints text in the log window after all files are processed
	print("AH HA HA "+list.length+" audit images");
}
updateResults();