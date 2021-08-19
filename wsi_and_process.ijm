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
		run("Fill Holes");
		run("Open");
		run("Watershed Irregular Features", "erosion=12 convexity_threshold=0.95 separator_size=0-Infinity");
		saveAs("Png", output + filename2+"WSI12_cs1");
        close();
}

//input = "E:/Theo/from_deepika/map2_neun_40x/343/images/gb_hess_sobel_var_8bit/segment/xcombined_seg";
//output = "E:/Theo/from_deepika/map2_neun_40x/343/images/gb_hess_sobel_var_8bit/segment/bw/test2/";
//input = "E:/Theo/from_deepika/map2_neun_40x/new markers 5_21/images/xcombined_seg/"
//outout = "E:/Theo/from_deepika/map2_neun_40x/new markers 5_21/images/xcombined_seg2/"
//input = "E:/Theo/from_deepika/map2_neun_40x/all_images_mask1/";
//output = "E:/Theo/from_deepika/map2_neun_40x/all_images_seg1/";

input = "E:/Theo/from_indira/min_training/";
output = "E:/Theo/from_indira/min_training_seg/";

setBatchMode(true); 
list = getFileList(input);

for (i = 0; i < list.length; i++)
        action(input, output, list[i]);
setBatchMode(false);




run("8-bit");
        setAutoThreshold("Default dark");
		//run("Threshold...");
		//setThreshold(133, 255);
		setOption("BlackBackground", true);
		run("Convert to Mask");

		//run("Close");
		
		run("Invert");
		run("Fill Holes");
		run("Watershed Irregular Features", "erosion=12 convexity_threshold=0 separator_size=0-Infinity");


        filestring=File.openAsString(pathfile)