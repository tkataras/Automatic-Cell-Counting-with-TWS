/*
 * Author: Theo, Tyler
 * Date: 11/30/2021
 * Description: This macro gets the counts for each hand counted image, plus their coordinate position.
 */
 
// Hide details from user to minimize screen clutter
setBatchMode(true);

print("Starting count_from_roi.ijm");

// Validation Hand Counts
input = getArgument();

firstStage = true
if(input.contains("testing_area")) {
	// Passed in Audit_Hand_Counts/Classifier
	x = split(input, "/");
	output = input + "../";
} else {
	input = input + "../training_area/Validation_Hand_Counts - Copy/";
	// Results
	output = input + "../Results";
}

// CLOSES old Results and Summary to avoid mixing with new results
run("Clear Results"); 
 
//holds all file names from input folder
list = getFileList(input);

// Need at least two files to compare
if(list.length < 2) {
	print("Need at least two input roi files");
} else {
	// Iterate macro over the objects in the input folder
	for (i = 0; i < list.length; i++) {
		action(input, list[i]);
	}	
	
	// Measure the information about each image
	function action(input, filename) {
		open(input + filename);
		run("Measure");
	    close();	
	}
	
	// Prints text in the log window after all files are processed
	print("Counts from "+list.length+" ROIs");
	saveAs("Results", output +"/roi_counts.csv");
}
print("Finished count_from_roi.ijm\n");