macro "The -- Count" {

input = getDirectory("Choose source directory for binary images to count.");
run("Clear Results"); // removes old results to avoid saving them with new results
output = getDirectory("_Choose output directory for counted images and Results file");


setBatchMode(true); //hide details from user
list = getFileList(input); //holds all file names from input folder
for (i = 0; i < list.length; i++) //iterates  macro over the objects in the input folder
        action(input, output, list[i]);
setBatchMode(false);


function action(input, output, filename) { //describes the actions for each image

        //processes images that may have
        open(input + filename);
        run("8-bit");
        filename2 = substring(filename, 0);// removes characters from begginings of file names
        //run("Invert");
        
		//section below performs the counting, requires Biovoxxel toolbox.
		run("Extended Particle Analyzer", "pixel show=Masks redirect=None keep=None display summarize add");
		selectWindow("Mask of" + filename)
		saveAs("Png", output + filename2+"mask");
		close();		
}
selectWindow("Results"); //saves results to file and closes them
save("Txt", "Results");
close();

print("AH HA HA "+list.length+" images") // prints text in the log window after all files are processed

}
