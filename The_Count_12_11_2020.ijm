macro "The -- Count" {

input = getDirectory("Choose source directory");
output = getDirectory("_Choose directory for counted images");


setBatchMode(true); //hide details from user
list = getFileList(input);

for (i = 0; i < list.length; i++)
        action(input, output, list[i]);
setBatchMode(false);


function action(input, output, filename) {
        open(input + filename);
        run("8-bit");
        filename2 = substring(filename, 0);
        //run("Invert");
		run("Extended Particle Analyzer", "pixel show=Masks redirect=None keep=None display summarize add");
		//selectWindow("Mask of" + filename)
		saveAs("Png", output + filename2+"mask");
		selectWindow("Results");
		//save("Txt", "Results" + filename2 );
		//close();
}

print("AH HA HA"+list.length+" images")

}
