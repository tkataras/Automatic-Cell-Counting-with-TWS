macro "The -- Count" {
	
//prompt window to select input folder
input = getDirectory("Choose source directory");

//CLOSES old Results and Summary to avoid mixing with new results
run("Clear Results"); 
run("Close", "Summary");

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
        
        // removes 14 redundant characters from begginings of file names
        filename2 = substring(filename, 14);
        
        //section below performs the counting, requires Biovoxxel toolbox.
		run("Extended Particle Analyzer","pixel "+
		"show=Masks redirect=None keep=None display summarize add");

		//save individual images of counted objects in output folder
		saveAs("Png", output + filename2+"mask");
		selectWindow("Results");
		
}
//close final image
close();

// prints text in the log window after all files are processed
print("AH HA HA "+list.length+" images")

}
