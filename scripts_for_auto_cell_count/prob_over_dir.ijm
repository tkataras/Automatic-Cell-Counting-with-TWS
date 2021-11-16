
//need to identify script folder location
	//this hides intermediary information and speeds processing
	setBatchMode(true); 
	
	//set input and output directories locations
	
	// Weka Output Projected if Projected, else Weka Output Thresholded
	//input_dirs = getArgument();
	
	input = getDirectory("Choose source directory of the macro (Scripts for Auto Cell Count)");

	
	input_dirs = input
	
	// Weka Output Counted
	counted_dirs = input_dirs + "../training_area/Weka_Output_Counted/";
	// probabilities
	prob_dirs = input_dirs + "../training_area/Weka_Probability/";	 
	// Clear the results table
	run("Clear Results");
	print(prob_dirs);


	
//need to start the loop through folders
	counted_dir_list = getFileList(counted_dirs);
	prob_dir_list = getFileList(prob_dirs);
		
		print(counted_dir_list[3]);
		print(prob_dir_list[3]);

		
	// this loop iterates through classifier folders
	for (z = 0; z< counted_dir_list.length; z++) {		
		counted = counted_dir_list[z];
		prob = prob_dir_list[z];
			
//need to identify counted image locations, need ignore non image(.csv, .txt)
counted_files = getFileList(counted_dirs + counted);
prob_files = getFileList(prob_dirs + prob);


	q = 0;
	counted_img = newArray(1);
for (i = 0; i < counted_files.length; i++) {
      if (endsWith(counted_files[i], ".csv")) { 
      } else { 
      	b = counted_files[i];
      	counted_img = Array.concat(counted_img, b);
      	q++;
      	
      }
   }
   //removes the initializing item in array
counted_img = Array.slice(counted_img,1);


   


//need to identify probabiliy image locations
	q = 0;
	prob_img = newArray(1);
for (i = 0; i < prob_files.length; i++) {
      if (endsWith(prob_files[i], ".csv")) { 
      } else { 
      	b = prob_files[i];
      	prob_img = Array.concat(prob_img, b);
      	q++;
      	
      }
   }
   //removes the initializing item in array
counted_img = Array.slice(counted_img,1);

if (counted_img.length != prob_img.length) { print("image length mismatch counted and prob images");
}

//iterate over images in folders
for (m = 0; m < counted_img.length; i++) {
	//need to open counted image
// #@$@#$%@%@5 i have tested up to here
	open(counted_dirs + counted + counted_img);
run("Analyze Particles...", "size="+size_min+"-Infinity pixel show=Masks display summarize add");

	//"analyze particles

	//open probability image

	//measure the rois from the counted image on the probability image

}






}
