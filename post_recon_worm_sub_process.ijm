dir = getDirectory("Choose source directory for the origional cell images");

dirout = getDirectory("__Choose directory for the output");

list = getFileList(dir);	//get the file list
list2 = getFileList(dir2);	//get the file list


setBatchMode(true);	//hide all the details from user
//process every file...
for (i=0; i<list.length; i++) {

open(dir+list[i]);
		rename("cell_1");
			//process the cell images
			run("8-bit");
			setAutoThreshold("Default dark");
			//run("Threshold...");
			//setThreshold(133, 255);
			setOption("BlackBackground", true);
			run("Convert to Mask");
			



open(dir2+list2[i]);
			run("8-bit");
			
			setAutoThreshold("Default dark");
			//run("Threshold...");
			//setThreshold(133, 255);
			setOption("BlackBackground", true);
			run("Convert to Mask");
			run("Invert");
			
			//rename("worm_0");
			//run("Duplicate...", "title=worm_1");
			//selectWindow("worm_1");
			
			run("Morphological Filters", "operation=Closing element=Disk radius=3");
			run("Keep Largest Region");
			
			run("Invert");
			rename("worm_1");



run("Morphological Reconstruction", "marker=worm_1 mask=[cell_1] type=[By Erosion] connectivity=4");

rename("recon_1");



testname = "_final_12_10";
saveAs("png", dirout+list[i] + testname);


close("cell_1");

close("worm_1");
close("recon_1");

}