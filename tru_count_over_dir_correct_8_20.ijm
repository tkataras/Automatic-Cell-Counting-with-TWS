            macro "The -- True -- Count" {


setBatchMode(true); 


input_dirs = getDirectory("Choose source directories");
output_dirs = getDirectory("_Choose output directories");




  size_min=20;
  Dialog.create("Size Min");
  Dialog.addNumber("Minimum pixel size for object count:", size_min);
  Dialog.show();
  size_min = Dialog.getNumber();


//the roi location will not change
dir2 = getDirectory("_Choose source directory for the roi multipoint counts");



input_dir_list = getFileList(input_dirs);

output_dir_list = getFileList(output_dirs);


for (z = 0; z< input_dir_list.length; z++){

	
	input = input_dir_list[z];
	output = output_dir_list[z];

 

//hide details from user to minimize screen clutter
setBatchMode(true); 

//holds all file names from input folder
list = getFileList(input_dirs + input);
list2 = getFileList(dir2);

n = 0;



//iterate  macro over the objects in the input folder
for (q = 0; q < list.length; q++)
        action(input, output, list[q], dir2, list2[q]);


//describes the actions for each image
function action(input, output, filename, input2, filename2) {
       
      
        
 open(input_dirs + input + filename);
        run("8-bit");
        setAutoThreshold("Default dark");
		run("Threshold...");
		setThreshold(6, 255);
		//setOption("BlackBackground", true);
		run("Convert to Mask");
		//run("Invert");
		
		
run("Analyze Particles...", "size="+size_min+"-Infinity pixel show=Masks display summarize add");
saveAs("Png",output_dirs + output + filename);

open(input2 + filename2);
roiManager("Add");

numroi = roiManager("count"); // establish number of objects


roiManager("Select", numroi - 1);
pts = Roi.getCoordinates(xpoints2, ypoints2); 
numpoints = lengthOf(ypoints2); // establish number of hand placed counts
print(numpoints + "_hand_placed_markers");
print("number auto count objects=" + numroi -1);

numroi2 = numroi -1;


for (k = 0; k < numroi2; k++) {   //k is repeated for each object


roiManager("Select", k);
test = Roi.getContainedPoints(xpoints, ypoints); // get coords for all pixels in object


lng = lengthOf(xpoints); //length of all pixels in current object, this varies

lng2 = numpoints; //length of hand placed counts, this does not vary


counts = 0;

for (i = 0 ; i < lng ; i++) {
	for(j = 0; j < lng2 ; j++) {
		xpoints2rnd = round(xpoints2[j]);
		ypoints2rnd = round(ypoints2[j]);
		
		if (xpoints[i] == xpoints2rnd && ypoints[i] == ypoints2rnd) {counts = counts + 1;}
		}
		
		
		}

	//update the results table
setResult("points", n++, counts);

}

roiManager("deselect")		
roiManager("Delete");




       
}

selectWindow("Results");
saveAs("Results", output_dirs + output + "Results.csv");
run("Clear Results");
}
// prints text in the log window after all files are processed
print("AH HA HA "+list.length+" images");
	
}

updateResults();

