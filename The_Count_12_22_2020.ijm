macro "The -- Count" {

input = getDirectory("Choose source directory for binary images to count.");

run("Clear Results"); // removes old results
output = getDirectory("_Choose output directory for counted images and Results file");


setBatchMode(true); //hide details from user
list = getFileList(input); // holds all file names from input folder


for (i = 0; i < list.length; i++)
        action(input, output, list[i]);
setBatchMode(false);


function action(input, output, filename) {
        
        open(input + filename);
        run("8-bit");
        filename2 = substring(filename, 0);
        //run("Invert");
		
		run("Extended Particle Analyzer", "pixel show=Masks redirect=None keep=None display summarize add");
		selectWindow("Mask of" + filename)
		saveAs("Png", output + filename2+"mask");
		close();
		
}

selectWindow("Results");
save("Txt", "Results");
close();

print("AH HA HA "+list.length+" images")

}
