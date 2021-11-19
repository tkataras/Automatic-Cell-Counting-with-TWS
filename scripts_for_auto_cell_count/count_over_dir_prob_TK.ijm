/*
 * Author: Theo, Tyler
 * Date: 11/17/2021
 * Description:
 */
macro "The -- True -- probability -- Count" {
	//Overview: uses hand placed markers and weka output images from each classifier to begin accuracy calculation
	//Input: Binary images, hand placed markes in roi files, one file for each image
	//Output: Binary image files including only cells counted, and .csv file in classifier folder with accuracy information
	
	//this hides intermediary information and speeds processing
	setBatchMode(true); 
	
	//set input and output directories locations
	
	// Weka Output Projected if Projected, else Weka Output Thresholded

	input_dirs = getArgument();


	
	// Weka Output Counted
	output_dirs = input_dirs + "../Weka_Output_Counted/";

	
	prob_dirs = input_dirs + "../Weka_Probability_Projected/";

	

	// Clear the results table
	run("Clear Results");
	
	// set size minimum for cells to exclude small radius noise
	size_min=20;
	Dialog.create("Size Min");
	Dialog.addNumber("Minimum pixel size for object count:", size_min);
	Dialog.show();
	size_min = Dialog.getNumber();
	
	
	//the hand placed roi location will not change as it is applied to each classifier image set
	//dir2 = getDirectory("_Choose source directory for the roi multipoint counts");
	dir2 = input_dirs + "../Validation_Hand_Counts/";
	
	// gets the folders for each classifier
	input_dir_list = getFileList(input_dirs);
		
	output_dir_list = getFileList(output_dirs);

	prob_dir_list = getFileList(prob_dirs);
		
	// this loop iterates through classifier folders
	for (z = 0; z< input_dir_list.length; z++) {		
		input = input_dir_list[z];
		output = output_dir_list[z];
		prob = prob_dir_list[z];
			
		//holds all file names from input folder
		list = getFileList(input_dirs + input);
		list2 = getFileList(dir2);
		list3 = getFileList(prob_dirs + prob);

		n = 0;
			
		//iterate  macro over the images in the input folder
		for (q = 0; q < list.length; q++) {
			action(input, output, list[q], dir2, list2[q], list3[q], prob_dirs);
		}
			
		//describes the actions for each image
		function action(input, output, filename, input2, filename2, filenameP, inputP) {    
			//opens and thresholds binary images or Weka output directly       
			open(input_dirs + input + filename);
			run("8-bit");
			setAutoThreshold("Default dark");
			run("Threshold...");
			setThreshold(6, 255);
			//setOption("BlackBackground", true);	
			run("Convert to Mask");
			//run("Invert");
					
					
			// this imageJ plugin creates the results file and image of the count cells based on the size exclusion		
			run("Analyze Particles...", "size="+size_min+"-Infinity pixel show=Masks summarize add");
			saveAs("Png",output_dirs + output + filename);


//here is the probability part. we need to close the segmented image and open the probability image to measure on it

			close();
			
			

print("rpob input");
print(inputP + input + filenameP);
//using the classifier from input, not prob, should be fine, could be used elsewehre
			open(inputP + input + filenameP);
			roiManager("Measure");
				
				
			open(input2 + filename2);
			roiManager("Add");
			


			//TODO
			//need to save the exact roi info for each auto object
			//is that not what happens here??? -TK
			
			
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
			roiManager("deselect")		
			roiManager("Delete");       
		}
		selectWindow("Results");
		//take / off end of folder name to get classifier ID
		class_name = substring(output_dir_list[z],0,lengthOf(output_dir_list[z]) -1);
		
		print("saving location");
		print( prob_dirs + prob + class_name + "_Results.csv");
		saveAs("Results", prob_dirs + prob + class_name + "_Results.csv");
		run("Clear Results");
	}
	// prints text in the log window after all files are processed
	print("AH HA HA "+list.length+" images");
}
updateResults();