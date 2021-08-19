function action(input, output, filename) {
        open(input + filename);
        run("8-bit");
        filename2 = substring(filename, 1);
        run("Invert");
		run("Extended Particle Analyzer", "pixel show=Masks redirect=None keep=None display summarize add");
		//selectWindow("Mask of" + filename)
		saveAs("Png", output + filename2+"mask");
		selectWindow("Results");
		//save("Txt", "Results" + filename2 );
		//close();
}



//input = "E:/Theo/from_deepika/map2_neun_40x/343/images/gb_hess_sobel_var_8bit/segment/bw/test/a/";
//output = "E:/Theo/from_deepika/map2_neun_40x/343/images/gb_hess_sobel_var_8bit/segment/bw/test/a/b/";

//input = "E:/Theo/from_deepika/map2_neun_40x/343/testing/";
//input = "E:/Theo/from_deepika/map2_neun_40x/new markers 5_21/images/seg2/";
//output = "E:/Theo/from_deepika/map2_neun_40x/new markers 5_21/images/seg2/";
//input = "E:/Theo/from_deepika/map2_neun_40x/new markers 5_21/images/xcombined_seg2/";
//output = "E:/Theo/from_deepika/map2_neun_40x/new markers 5_21/images/xcombined_seg3/";

//input = "E:/Theo/from_deepika/map2_neun_40x/gb_hes_mp_sob_var_lap_ent_1_10_all_images/seg/";
//output = "E:/Theo/from_deepika/map2_neun_40x/gb_hes_mp_sob_var_lap_ent_1_10_all_images/the_count/";
input = "F:/Theo/iba_7_2020_autocount/working images/traing_val_set/validation set/class2midtrain3/thresh/";
output = "F:/Theo/iba_7_2020_autocount/working images/traing_val_set/validation set/class2midtrain3/counted/";


setBatchMode(true); 
list = getFileList(input);

for (i = 0; i < list.length; i++)
        action(input, output, list[i]);
setBatchMode(false);




selectWindow("_HPC343 Map2_NeuN all (CI).sld - HPC343 MAP2_NeuN_01042019_s45_C_F1.CI - C=1 z55.tif_ghe_bkgsub50_png.pngWSI12.png");
run("ROI Manager...");
saveAs("Tiff", "E:/Theo/from_deepika/map2_neun_40x/343/images/gb_hess_sobel_var_8bit/segment/bw/test/a/Mask of Mask of _HPC343 Map2_NeuN all (CI).sld - HPC343 MAP2_NeuN_01042019_s45_C_F1.CI - C=1 z55.tif_ghe_bkgsub50_png.pngWSI12-1.tif");


run("Extended Particle Analyzer", "pixel show=Masks redirect=None keep=None display summarize add");
saveAs("Tiff", "E:/Theo/from_deepika/map2_neun_40x/343/images/gb_hess_sobel_var_8bit/segment/bw/test/a/Mask of Mask of _HPC343 Map2_NeuN all (CI).sld - HPC343 MAP2_NeuN_01042019_s45_C_F5 - C=1 z22.tif_ghe_bkgsub50_png.pngWSI12-1 delete.tif");
close();

selectWindow("imagename")