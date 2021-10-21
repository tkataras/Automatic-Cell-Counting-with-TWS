/*
 * Author: Theo, Tyler
 * Date: 10/21/2021
 * Description:
 */
setBatchMode(true); 


input_dirs = getDirectory("Choose source directory (Weka_Output)");
//output_dirs = getDirectory("_Choose output directories");
output_dirs = input_dirs + "../Weka_Output_Thresholded/";

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