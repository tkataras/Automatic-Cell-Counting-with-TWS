//REMEMBER TO RUN ALL CODE FROM THE TOP INCLUDING THE FUNCTION, IT DOESNT REMEMBER ANYTHING
function action(input, output, filename) {
        open(input + filename);
        
		run("Anisotropic Diffusion 2D", "number=5 smoothings=4 a1=0.6 a2=0.45 dt=20 edge=2");
		run("Subtract Background...", "rolling=15 stack");
		run("Z Project...", "projection=[Max Intensity]");
		saveAs("Png", output + filename+"AD_SB_MP");
        close();
        close();
}




input = "F:/Theo/iba_7_2020_autocount/working images/input/";
output = "F:/Theo/iba_7_2020_autocount/working images/output/";





//filename = "x"
setBatchMode(true); 
list = getFileList(input);
list = Array.reverse(list);

for (i = 0; i < list.length; i++)
        action(input, output, list[i]);
setBatchMode(false);
