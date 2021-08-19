//REMEMBER TO RUN ALL CODE FROM THE TOP INCLUDING THE FUNCTION, IT DOESNT REMEMBER ANYTHING
function action(input, output, filename) {
        open(input + filename);
      	run("Sharpen");
		run("Enhance Contrast...", "saturated=0.3 equalize");
		
		saveAs("Png", output + filename+"S_ECHE");
        close();
        
}

input = getDirectory("Choose source directory for the input");
output = getDirectory("Choose source directory for the output");






//filename = "x"
setBatchMode(true); 
list = getFileList(input);
list = Array.reverse(list);

for (i = 0; i < list.length; i++)
        action(input, output, list[i]);
setBatchMode(false);
