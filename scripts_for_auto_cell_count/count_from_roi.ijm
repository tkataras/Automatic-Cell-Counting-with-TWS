/*
 * Author: Theo, Tyler
 * Date: 10/20/2021
 * Description:
 */
 
//hide details from user to minimize screen clutter
setBatchMode(true);
print("Starting count_from_roi.ijm");
//macro for per image count from goi. also has xy location of all points

// Validation Hand Counts
input = getArgument();

firstStage = true
if(input.contains("testing_area")) {
	// Passed in Audit_Hand_Counts/Classifier
	x = split(input, "/");
	output = input + "../";
} else {
	input = input + "../training_area/Validation_Hand_Counts/";
	// Results
	output = input + "../Results";
}
//output = getDirectory("Choose output directory (Not the same as the source directory)");
//output = "../training_area/Results"

//CLOSES old Results and Summary to avoid mixing with new results
run("Clear Results"); 
 

//holds all file names from input folder
list = getFileList(input);

// Need at least two files to compare
if(list.length < 2) {
	print("Need at least two input roi files");
} else {
//iterate macro over the objects in the input folder
	for (i = 0; i < list.length; i++) {
		action(input, list[i]);
	}	
	
	//describes the actions for each image
	function action(input, filename) {
		open(input + filename);
		run("Measure");
	    close();	
	}
	
	// prints text in the log window after all files are processed
	print("counts from "+list.length+" rois");
	//run("Summarize");
	saveAs("Results", output +"/roi_counts.csv");
}
print("Finished count_from_roi.ijm\n");