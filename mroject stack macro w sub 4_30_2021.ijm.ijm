

macro "The -- sub and project" {
	
//prompt window to select input folder
input = getDirectory("Choose source directory");




//prompt window to select output folder for images and results file
output = getDirectory("_Choose directory for counted images");

//hide details from user to minimize screen clutter
setBatchMode(true); 

//holds all file names from input folder
list = getFileList(input);

//iterate  macro over the objects in the input folder
for (i = 0; i < list.length; i++)
        action(input, output, list[i]);


//describes the actions for each image
function action(input, output, filename) {
        
        //open and processe images
        open(input + filename);
        run("8-bit");
        run("Subtract Background...", "rolling=20 stack");
        run("Z Project...", "projection=[Max Intensity]");
		saveAs("Tiff", output + filename+"edf");
		
		
}
//close final image
close();

// prints text in the log window after all files are processed
print("AH HA HA "+list.length+" images")

}