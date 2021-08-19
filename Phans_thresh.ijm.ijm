function action(input, output, filename) {
        open(input + filename);
        run("8-bit");
        //run("Anisotropic Diffusion 2D", "number=20 smoothings=3 keep=20 a1=0.50 a2=0.90 dt=20 edge=5");
        
        //run("Enhance Contrast...", "saturated=0.1 equalize");
        //run("Enhance Local Contrast (CLAHE)", "blocksize=60 histogram=256 maximum=20 mask=*None* fast_(less_accurate)");
        //run("Subtract Background...", "rolling=60");
        run("Auto Local Threshold", "method=Phansalkar radius=30 parameter_1=0 parameter_2=0 white");
		run("Open");
		run("Invert");
        
        saveAs("Png", output + "sub" + filename+"process_phans_open_inv");
        
}

input = "D:/Images HMC3 daniel/DAPI/";
output = "D:/Images HMC3 daniel/DAPI_seg/";


setBatchMode(true); 
list = getFileList(input);

for (i = 0; i < list.length; i++)
        action(input, output, list[i]);
setBatchMode(false);
