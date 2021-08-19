//REMEMBER TO RUN ALL CODE FROM THE TOP INCLUDING THE FUNCTION, IT DOESNT REMEMBER ANYTHING
function action(input, output, filename) {
        open(input + filename);
        run("8-bit");
		run("Subtract Background...", "rolling=20 light");
		run("Morphological Filters", "operation=Closing element=Disk radius=1");		
		
		run("Auto Threshold", "method=Huang ignore_white");
		run("Close-");
		
		run("Fill Holes");
		
		run("Analyze Particles...", "size=10000-Infinity show=Masks  clear add");
		
		saveAs("Png", output + filename+"subbkg");
    
}






input = getDirectory("Choose source directory for the input");

output = getDirectory("_Choose directory for the output");



//filename = "x"
setBatchMode(true); 
list = getFileList(input);
list = Array.reverse(list);

for (i = 0; i < list.length; i++)
        action(input, output, list[i]);
setBatchMode(false);
