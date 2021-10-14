


//prompt window to select input folder
input = getDirectory("Choose source directory");



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


//set all componets to measure, most important is "limit" which sets measure to only look at pixels above threshold
run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction limit display redirect=None decimal=8");

//sets threshold to 0 to ignore backgorund, does ignore the few zeros that fall within cell area
setThreshold(1, 255);
setOption("BlackBackground", true);

run("Measure");
//getValue("Mean limit") 
      	
      	
		
		
		
		close();
		
}


// prints text in the log window after all files are processed
print("we processed "+list.length+" images")
//run("Summarize");
