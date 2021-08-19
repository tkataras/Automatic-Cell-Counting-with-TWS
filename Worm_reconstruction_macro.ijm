dir = getDirectory("Choose source directory for the cell images");
dir2 = getDirectory("_Choose source directory for the worm images");
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
			
			rename("worm_0");
			run("Duplicate...", "title=worm_1");
			selectWindow("worm_1");
			
			run("Morphological Filters", "operation=Closing element=Disk radius=3");
			run("Keep Largest Region");
			
			//run("Invert");
			



run("Morphological Reconstruction", "marker=worm_1 mask=[cell_1] type=[By Erosion] connectivity=4");

rename("recon_1");





//run("Invert");
//run("Fill Holes");


//imageCalculator("Subtract create", "recon_1", "worm_0");

//run("Morphological Filters", "operation=Closing element=Disk radius=1");
//run("Morphological Filters", "operation=Opening element=Disk radius=3");






testname = "_final1h7";
saveAs("png", dirout+list[i] + testname);

close();

close("worm_0");
close("recon_1");
}
