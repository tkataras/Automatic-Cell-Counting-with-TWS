//REMEMBER TO RUN ALL CODE FROM THE TOP INCLUDING THE FUNCTION, IT DOESNT REMEMBER ANYTHING
function action(input, output, filename) {
        open(input + filename);
        filename2 = substring(filename, 3);
        run("8-bit");
        setAutoThreshold("Default dark");
		//run("Threshold...");
		//setThreshold(133, 255);
		setOption("BlackBackground", true);
		run("Convert to Mask");
		run("Invert");
		run("EDM Binary Operations", "iterations=1 operation=open");
		saveAs("Png", output + filename2+"forsub");
}

//input = "E:/Theo/from_deepika/map2_neun_40x/343/images/gb_hess_sobel_var_8bit/segment/xcombined_seg";
//output = "E:/Theo/from_deepika/map2_neun_40x/343/images/gb_hess_sobel_var_8bit/segment/bw/test2/";
//input = "E:/Theo/from_deepika/map2_neun_40x/new markers 5_21/images/xcombined_seg/"
//outout = "E:/Theo/from_deepika/map2_neun_40x/new markers 5_21/images/xcombined_seg2/"
//input = "E:/Theo/from_deepika/map2_neun_40x/all_images_mask1/";
//output = "E:/Theo/from_deepika/map2_neun_40x/all_images_seg1/";

input = "E:/Deepika NeuN/classified_step_one/";
output = "E:/Deepika NeuN/classified_step_one_thresh/";

setBatchMode(true); 
list = getFileList(input);

for (i = 0; i < list.length; i++)
        action(input, output, list[i]);
setBatchMode(false);
