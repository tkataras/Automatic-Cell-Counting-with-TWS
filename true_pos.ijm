//before running you must clear the results window and the ROI manager!
dir = getDirectory("Choose source directory for the cell images");
dir2 = getDirectory("_Choose source directory for the hand count markers");
//dirout = getDirectory("__Choose directory for the output");

list = getFileList(dir);	//get the file list
list2 = getFileList(dir2);	//get the file list


setBatchMode(true);	//hide all the details from user
//process every file...
for (i=0; i<list.length; i++) {

open(dir+list[i]);
		
			//process the cell images
			run("8-bit");




			

roiManager("Open", dir2+list2[i]);
roiManager("Measure");

//roiManager("Select", 1);
roiManager("Delete");


hand_count_num = getValue("results.count");
print(hand_count_num);
print("test");

}

