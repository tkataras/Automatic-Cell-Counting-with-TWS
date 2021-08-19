            macro "The -- True -- Count" {
	
//prompt window to select input folder for binary images
input = getDirectory("Choose binary image directory");
dir2 = getDirectory("_Choose source directory for the roi multipoint counts");
//dir2 = "F:/Theo/iba_7_2020_autocount/working images/substack32_37/new training/random_quarters/new_male_only_6_24/validation_roi/";
//CLOSES old Results and Summary to avoid mixing with new results
run("Clear Results"); 


//prompt window to select output folder
output = getDirectory("_Choose directory for output");


//hide details from user to minimize screen clutter
setBatchMode(true); 

//holds all file names from input folder
list = getFileList(input);
list2 = getFileList(dir2);

n = 0;



//iterate  macro over the objects in the input folder
for (q = 0; q < list.length; q++)
        action(input, output, list[q], dir2, list2[q]);


//describes the actions for each image
function action(input, output, filename, input2, filename2) {
       
      
        
 open(input + filename);
        run("8-bit");
        setAutoThreshold("Default dark");
		//run("Threshold...");
		//setThreshold(6, 255);
		setOption("BlackBackground", true);
		run("Convert to Mask");
		run("Invert");
		//saveAs("Tif", output + filename+"cnt");

		
run("Analyze Particles...", "size=20-Infinity pixel show=Masks display summarize add");
saveAs("Png", output + filename+"mask");

open(input2 + filename2);
roiManager("Add");

numroi = roiManager("count"); // establish number of objects

//numroi = roiManager("count"); // establish number of objects
roiManager("Select", numroi - 1);
pts = Roi.getCoordinates(xpoints2, ypoints2); 
numpoints = lengthOf(ypoints2); // establish number of hand placed counts
print(numpoints + "_hand_placed_markers");
print("number auto count objects=" + numroi -1);

numroi2 = numroi -1;


for (k = 0; k < numroi2; k++) {   //k is repeated for each object


roiManager("Select", k);
test = Roi.getContainedPoints(xpoints, ypoints); // get coords for all pixels in object
//Array.print(xpoints);
//Array.print(ypoints);

//roiManager("Select", numroi-1);
//test2 = Roi.getCoordinates(xpoints2, ypoints2);
//Array.print(xpoints2);
//Array.print(ypoints2);

//print(xpoints[3])

lng = lengthOf(xpoints); //length of all pixels in current object, this varies
//print(lng);
//lng2 = lengthOf(xpoints2);//length of hand placed counts, this does not vary
lng2 = numpoints; //length of hand placed counts, this does not vary
//print(lng2);

counts = 0;

for (i = 0 ; i < lng ; i++) {
	for(j = 0; j < lng2 ; j++) {
		xpoints2rnd = round(xpoints2[j]);
		ypoints2rnd = round(ypoints2[j]);
		
		if (xpoints[i] == xpoints2rnd && ypoints[i] == ypoints2rnd) {counts = counts + 1;}
		}
		//setResult("points", k, counts);
		//print(k);
		//testing = Array.concat(testing,counts);
		
		}
		
//maybe put setresults here next
//print(k);
setResult("points", n++, counts);
//print(n);
		//testing[k] = counts;

}

		
roiManager("Delete");
roiManager("Delete");



       
}
//close final image, delete roi
//close();
//roiManager("Delete");

// prints text in the log window after all files are processed
print("AH HA HA "+list.length+" images");

selectWindow("Results");
saveAs("Results", output + "Results.csv");		
}

updateResults();

