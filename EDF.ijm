//REMEMBER TO RUN ALL CODE FROM THE TOP INCLUDING THE FUNCTION, IT DOESNT REMEMBER ANYTHING
function action(input, output, filename) {
        open(input + filename);
        run("Easy mode...");
        selectWindow("Output")
        saveAs("Png", output + filename+"_edf_test_png");
        close();
}
input = "E:/Theo/from_deepika/map2_neun_40x/EDF_test/";
output = "E:/Theo/from_deepika/map2_neun_40x/EDF_test/output/";

//filename = "x"
setBatchMode(true); 
list = getFileList(input);

for (i = 0; i < list.length; i++)
        action(input, output, list[i]);
setBatchMode(false);

