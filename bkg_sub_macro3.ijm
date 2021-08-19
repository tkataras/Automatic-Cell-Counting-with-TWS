//REMEMBER TO RUN ALL CODE FROM THE TOP INCLUDING THE FUNCTION, IT DOESNT REMEMBER ANYTHING
function action(input, output, filename) {
        open(input + filename);
        run("8-bit");
        run("Anisotropic Diffusion 2D", "number=20 smoothings=3 keep=20 a1=0.50 a2=0.90 dt=20 edge=5");
        run("Subtract Background...", "rolling=85");
        run("Enhance Contrast...", "saturated=0.1 equalize");
        //run("Enhance Local Contrast (CLAHE)", "blocksize=60 histogram=256 maximum=20 mask=*None* fast_(less_accurate)");
        //run("Subtract Background...", "rolling=60");
        saveAs("Png", output + filename+"bs85_anis_smooth3_subb4he");
        close();
        close();
}


//input = "C:/Users/User/Downloads/Ambrosio-Tortorelli-Minimizer-master/Ambrosio-Tortorelli-Minimizer-master/New folder/test/";
//input = "E:/Theo/from_deepika/map2_neun_40x/subimages/newfolder";

//input = "E:/Theo/from_deepika/map2_neun_40x/343/test1/";
//output = "E:/Theo/from_deepika/map2_neun_40x/343/test1/";

//output = "C:/Users/User/Downloads/Ambrosio-Tortorelli-Minimizer-master/Ambrosio-Tortorelli-Minimizer-master/New folder/test/";
//output = "E:/Theo/from_deepika/map2_neun_40x/subimages/bkg_sub/";

//input = "E:/Theo/from_deepika/map2_neun_40x/subimages/histeq_at_start/";
//output = "E:/Theo/from_deepika/map2_neun_40x/subimages/histeq_at_start/";
//input = "E:/Theo/from_deepika/map2_neun_40x/all_images/";
//output = "E:/Theo/from_deepika/map2_neun_40x/all_images_processed/";
//input = "E:/Theo/from_deepika/map2_neun_40x/hist_eq_testing/";
//output = "E:/Theo/from_deepika/map2_neun_40x/hist_eq_testing/output/";
//input = "E:/Theo/from_deepika/map2_neun_40x/343/images/";
//output = "E:/Theo/from_deepika/map2_neun_40x/343/images/gb_hess_sobel_var/";
input = "E:/Deepika NeuN/nuen_only_male_cortex/";
output = "E:/Deepika NeuN/nuen_only_male_cortex/anis_bkgsub_85/";


//filename = "x"
setBatchMode(true); 
list = getFileList(input);
list = Array.reverse(list)
print(list)
for (i = 0; i < list.length; i++)
        action(input, output, list[i]);
setBatchMode(false);




input = "E:/Theo/from_deepika/map2_neun_40x/subimages/";
print(input)
output = "E:/Theo/from_deepika/map2_neun_40x/subimages/bkg_sub/";
filename = "x"


input = "E:/Theo/from_deepika/map2_neun_40x/343/"
list = getFileList(input)
print(list[1])