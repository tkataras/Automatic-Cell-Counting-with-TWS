/*
 * Author: Theo, Tyler
 * Date: 10/21/2021
 * Description:
 */
macro "The -- True -- Count" {
	//Overview: uses hand placed markers and weka output images from each classifier to begin accuracy calculation
	//Input: Binary images, hand placed markes in roi files, one file for each image
	//Output: Binary image files including only cells counted, and .csv file in classifier folder with accuracy information
	

	//Remove old results
	run("Clear Results");

	//this hides intermediary information and speeds processing
	setBatchMode(true); 
	
	//set input and output directories locations
	
	// Weka Output Projected if Projected, else Weka Output Thresholded
	input_dirs = getArgument();

	// Get the classifier
	x = split(input_dirs, "/");

		// Weka Output Counted
		output_dirs = input_dirs + "/../../Weka_Output_Counted/" + x[x.length-1];
	print(output_dirs);
	
	// set size minimum for cells to exclude small radius noise
	size_min=20;
	Dialog.create("Size Min");
	Dialog.addNumber("Minimum pixel size for object count:", size_min);
	Dialog.show();
	size_min = Dialog.getNumber();
	
	
	

		print(input_dirs);
		print(output_dirs);
		
		// this loop iterates through classifier folders
		//holds all file names from input folder
		list = getFileList(input_dirs);	
		n = 0;
		print(list.length);
		
		//iterate  macro over the images in the input folder
		for (q = 0; q < list.length; q++) {
			actionTwo(input_dirs, output_dirs, list[q]);
		}
			
		//describes the actions for each image
		function actionTwo(input, output, filename) {    
			//opens and thresholds binary images or Weka output directly       
			open(input + "/" + filename);
			run("8-bit");
			setAutoThreshold("Default dark");
			run("Threshold...");
			setThreshold(6, 255);
			//setOption("BlackBackground", true);	
			run("Convert to Mask");
			//run("Invert");
						
			// this imageJ plugin creates the results file and image of the count cells based on the size exclusion		
			run("Analyze Particles...", "size="+size_min+"-Infinity pixel show=Masks display summarize add");
			
			
			saveAs("Png",output + "/" + filename);// *#*#*##* need to at x, which is the classifier name,  and a / so it saves in the correct folder
			
			run("Measure");	
			
			
			
			
			numroi = roiManager("count"); // establish number of objects
			print("number auto count objects=" + numroi -1);
		
				
			
					}
				
					
				//update the results table
				//setResult("points", n++, counts);	
			//}
			//roiManager("deselect")		
			//roiManager("Delete");       
		//}
		selectWindow("Results");
		//take / off end of folder name to get classifier ID
		class_name = x[x.length-1];
		saveAs("Results", output_dirs + "/" + class_name + "_Results_test_data.csv"); // **#*#*CANT FIND THIS FILE ANYWHERE*#*#*#*##*
		run("Clear Results");
		
		// prints text in the log window after all files are processed
		print("AH HA HA "+list.length+" images");
	}
}

updateResults();