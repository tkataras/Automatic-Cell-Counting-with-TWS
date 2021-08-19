// making the worm outline and removing non worm bits

//show prompt for selection of source directory

//this throws a fit about "dubpicate Keyword"
dir = getDirectory("Choose source directory for the input");
dirout = getDirectory("Choose source directory for the output");
list = getFileList(dir);	//get the file list


setBatchMode(true);	//hide all the details from user
//process every file...
for (i=0; i<list.length; i++) {

open(dir+list[i]);
run("8-bit");

run("Subtract Background...", "rolling=20 light");
setAutoThreshold("Default dark");
//run("Threshold...");
setAutoThreshold("Default dark");
setOption("BlackBackground", true);
run("Convert to Mask");

run("Erode");
run("Erode");

run("Invert");
run("Analyze Particles...", "size=1000-Infinity show=Masks exclude clear add");

testname = "_outline";

//saveAs("png", dir2+list[i] + testname);
saveAs("png", dirout+list[i] + testname);

}
