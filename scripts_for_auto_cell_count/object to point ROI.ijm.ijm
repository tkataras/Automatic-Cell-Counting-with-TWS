//keep all output windows hidden and close open windows
setBatchMode("hide");
close("*");


//allow user to set input and output directories
input_dir = getDir("input");
output_dir = getDir("output");

//get list of input files
input = getFileList(input_dir);
	
// Clear the results table
run("Clear Results");

//iterate through all images in input folder
for (image = 0; image < lengthOf(input); image++) {

//open and process images to ensure analyze particles can work
open(input_dir + input[image]); 
run("8-bit");
setAutoThreshold("Default");
//run("Threshold...");
setOption("BlackBackground", false);
run("Convert to Mask");
run("Invert");

//stop empty images here and save image instead as placeholder
getRawStatistics(nPixels, mean, min, max, std, histogram);
if (max == 0) {
	saveAs("Png",output_dir + "/" + input[image]);
	
	}else {



// capture information about the objects in image
run("Analyze Particles...", "  show=Masks display clear summarize add");
			
			
			
//identify number of objects and initialize the variables that will holde the coord info				
n = roiManager('count');
all_center_x = newArray(n);
all_center_y = newArray(n);
			
//iterates over all objects, seems to work on 2 or more cells, but break on single cell image
for (i = 0; i < n; i++) {
    roiManager('select', 0);



//calculate center position from bounding box
coords = Roi.getBounds(x, y, width, height);
center_x = x + (width/2);
center_y = y + (height/2);
			

//store the XY coord values for each objects
all_center_x[i] = center_x;
all_center_y[i] = center_y;

roiManager("Delete");


}

//now we have one array each for x and y with all the respective center(from bounding box) values
//Array.print(all_center_x);
//Array.print(all_center_y);



numroi = lengthOf(all_center_x);
//now turn all center XY coords into multipoint roi markers
for (j = 0; j < numroi; j++) {
	x = all_center_x[j];
	y = all_center_y[j];
	makePoint(x, y, "small yellow dot");
	roiManager("Add");
	

}

//now need to combine the individual point markers into one multipoint selection

roiManager("Combine");
roiManager("Add");

numroi2 = roiManager("count"); // establish number of objects

//select the new combined mutlipoint roi and save
roiManager("Select", numroi2 - 1);
roiManager("rename", input[image]);
roiManager("Save selected", output_dir + "/" + input[image]+".roi");

//clear roi manager for next image
roiManager("deselect");
roiManager("delete");
//print(lengthOf(all_center_x));
//print(lengthOf(all_center_y));
}// end of the else that captures all images with objects
}// for length of images
print("end");

