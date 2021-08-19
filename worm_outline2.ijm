

dir = getDirectory("Choose source directory for the input");
dirout = getDirectory("_Choose source directory for the output");
list = getFileList(dir);	//get the file list



setBatchMode(true);	//hide all the details from user
//process every file...
for (i=0; i<list.length; i++) {

open(dir+list[i]);
run("8-bit");


setAutoThreshold("Default");
run("Threshold...");
setThreshold(10, 128);
run("Convert to Mask");



run("Dilate");

run("Fill Holes");

run("Close-");	
run("Close-");
run("Dilate");
run("Close-");



run("Analyze Particles...", "size=10000-Infinity show=Masks  clear add");
testname = "_outline";


//saveAs("png", dir2+list[i] + testname);
saveAs("png", dirout+list[i] + testname);
close();
}