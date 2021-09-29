//// processing and normalization





//prompt window to select input folder
input = getDirectory("Choose source directory");
output = getDirectory("_Choose output directory");



//CLOSES old Results and Summary to avoid mixing with new results
run("Clear Results"); 



//hide details from user to minimize screen clutter
setBatchMode(true); 

//holds all file names from input folder
list = getFileList(input);

//iterate  macro over the objects in the input folder
for (i = 0; i < list.length; i++)
        action(input, list[i]);


//describes the actions for each image
function action(input, filename) {
        
        open(input + filename);


        //run("Auto Threshold", "method=Intermodes white");
		//run("Auto Threshold", "method=MinError(I) white");
		run("Auto Threshold", "method=Default white");
		run("Close-");
      	
      	
      	saveAs("Png", output + filename);
		
		
		
		close();
		
}


// prints text in the log window after all files are processed
print("we processed "+list.length+" images")
//run("Summarize");
