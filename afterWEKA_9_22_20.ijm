//REMEMBER TO RUN ALL CODE FROM THE TOP INCLUDING THE FUNCTION, IT DOESNT REMEMBER ANYTHING
function action(input, output, filename) {
        open(input + filename);
        
		run("8-bit");
setAutoThreshold("Default dark");
//run("Threshold...");
//setThreshold(6, 255);
setOption("BlackBackground", true);
run("Convert to Mask");
run("Invert");
run("Close-");
saveAs("Png", output + filename+"");

        close();
        
}




input = "F:/Theo/iba_7_2020_autocount/working images/traing_val_set/validation set/class2endtrain1/segmented/";
output = "F:/Theo/iba_7_2020_autocount/working images/traing_val_set/validation set/class2endtrain1/processed/";





//filename = "x"
setBatchMode(true); 
list = getFileList(input);
list = Array.reverse(list);

for (i = 0; i < list.length; i++)
        action(input, output, list[i]);
setBatchMode(false);
