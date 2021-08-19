//REMEMBER TO RUN ALL CODE FROM THE TOP INCLUDING THE FUNCTION, IT DOESNT REMEMBER ANYTHING
function action(input, output, filename) {
        open(input + filename);
        run("Subtract Background...", "rolling=80");
        saveAs("Png", output + filename+"png");
        close();
}

//input = "C:/Users/User/Downloads/Ambrosio-Tortorelli-Minimizer-master/Ambrosio-Tortorelli-Minimizer-master/New folder/test/";
//input = "E:/Theo/from_deepika/map2_neun_40x/subimages/newfolder";
//input = "E:\Theo\from_deepika\map2_neun_40x\subimages\final"
//output = "E:\Theo\from_deepika\map2_neun_40x\subimages\final"

//input = "E:/Theo/from_deepika/map2_neun_40x/343/test1/";
//output = "E:/Theo/from_deepika/map2_neun_40x/343/test1/";

//output = "C:/Users/User/Downloads/Ambrosio-Tortorelli-Minimizer-master/Ambrosio-Tortorelli-Minimizer-master/New folder/test/";
//output = "E:/Theo/from_deepika/map2_neun_40x/subimages/bkg_sub/";

//input = "E:/Theo/from_deepika/map2_neun_40x/343/processing/";
//output = "E:/Theo/from_deepika/map2_neun_40x/343/processing/";

input = "F:/Theo/iba_7_2020_autocount/image_processing/practice/sld_files/";
output = "F:/Theo/iba_7_2020_autocount/image_processing/practice/output/";

//filename = "x"
setBatchMode(true); 
list = getFileList(input);

for (i = 0; i < list.length; i++)
		print(list[1]);
        action(input, output, list[i]);
setBatchMode(false);




input = "E:/Theo/from_deepika/map2_neun_40x/subimages/";
print(input)
output = "E:/Theo/from_deepika/map2_neun_40x/subimages/bkg_sub/";
filename = "x"


input = "E:/Theo/from_deepika/map2_neun_40x/343/"
list = getFileList(input)
print(list[1])