//REMEMBER TO RUN ALL CODE FROM THE TOP INCLUDING THE FUNCTION, IT DOESNT REMEMBER ANYTHING
function action(input, output, filename) {
        open(input + filename);
        
      	run("RGB Color");
		
		saveAs("Png", output + filename+"rgb");
        close();
        
}

input = getDirectory("Choose source directory for the input");
output = getDirectory("_Choose source directory for the output");






//filename = "x"
setBatchMode(true); 
list = getFileList(input);
list = Array.reverse(list);

for (i = 0; i < list.length; i++)
        action(input, output, list[i]);
setBatchMode(false);
