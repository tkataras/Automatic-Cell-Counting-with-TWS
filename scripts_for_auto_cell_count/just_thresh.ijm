/*
 * Author: Theo, Tyler
 * Date: 11/1/2021
 * Description:
 */
setBatchMode(true); 
print("Starting just_thresh.ijm");
// Weka Output
input_dirs = getArgument();
// Weka Output Thresholded
output_dirs = "";

// Get the classifier
x = split(input_dirs, "/");

firstStage = true;
// Check if the argument is from testing or training area
if(input_dirs.contains("testing_area")) {
	output_dirs = input_dirs + "/../../Weka_Output_Thresholded/" + x[x.length-1] + "/";
	firstStage = false;
} else {
	input_dirs = input_dirs + "../training_area/Weka_Output/";
	output_dirs = input_dirs + "../Weka_Output_Thresholded/";
	firstStage = true;
}

// Code for the first half of the pipeline
if(firstStage) {
	input_dir_list = getFileList(input_dirs);
	output_dir_list = getFileList(output_dirs);

	for (z = 0; z< input_dir_list.length; z++) {	
		input = input_dir_list[z];
		output = output_dir_list[z];
		
		//holds all file names from input folder
		list = getFileList(input_dirs + input);
		
		//iterate  macro over the objects in the input folder
		for (q = 0; q < list.length; q++) {
			action(input, output, list[q]);
		}
			
		//describes the actions for each image
		function action(input, output, filename) {      
			open(input_dirs + input + filename);
			run("8-bit");
			setAutoThreshold("Default");
			//run("Threshold...");
			//setThreshold(8, 132);
			setOption("BlackBackground", true);
			run("Convert to Mask");
			saveAs("Png",output_dirs + output + filename);	
		}
	}
} else {
	//holds all file names from input folder
	list = getFileList(input_dirs);
		
	//iterate  macro over the objects in the input folder
	for (q = 0; q < list.length; q++) {
		actionTwo(input_dirs, output_dirs, list[q]);
	}
	
	//describes the actions for each image
	function actionTwo(input, output, filename) {       
		open(input + "/" + filename);
		run("8-bit");
		setAutoThreshold("Default");
		//run("Threshold...");
		//setThreshold(8, 132);
		setOption("BlackBackground", true);
		run("Convert to Mask");
		saveAs("Png",output + filename);	
	}
}

print("Finished just_thresh.ijm\n");