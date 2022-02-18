/**
 * Author: Theo Kataras, Tyler Jang
 * Date: 2/17/2021
 * 
 * Input: Hand counted images .
 * Output: CSV with information about all the hand counted objects.
 * Description: This macro gets the counts for each hand counted image, plus their coordinate position. 
 * 				Saves the results in roi_counts.csv
 */
 
// Hide details from user to minimize screen clutter
setBatchMode(true);

print("Starting count_from_roi.ijm");

// Validation Hand Counts
input = getArgument();
input = input + "../training_area/Validation_Hand_Counts/";

// Results
output = input + "../Results";

// Closes old Results and Summary to avoid mixing with new results
run("Clear Results"); 
 
// Holds all file names from input folder
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
		// Measure full image
		run("Measure"); 

		// Only read .roi files
		if (endsWith(filename, ".roi")){
			// Select all points in the image
			run("Select All");  

			// Measure full image
			run("Measure"); 
			getImageID();
		}   
	    close();			
	}
	
	// Prints text in the log window after all files are processed
	print("Counts from " + list.length + " ROIs");
	saveAs("Results", output +"/roi_counts.csv");
}
print("Finished count_from_roi.ijm\n");