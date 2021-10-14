macro "overlap--Maxima" {

//this code subtracts a binary image(the first) from the second 
//show prompt for selection of source directory
dir = getDirectory("Choose source directory for the images to sub(outlines) recon");
dir2 = getDirectory("_Choose source directory for images to sub from(raw) worm");
dirout = getDirectory("__Choose directory for the output");

list = getFileList(dir);	//get the file list
list2 = getFileList(dir2);	//get the file list

setBatchMode(true);	//hide all the details from user
//process every file...
for (i=0; i<list.length; i++) {


		
	//open the files from each folder
		open(dir+list[i]);
		selectWindow(list[i]);
		
			//process the auto images
			run("8-bit");
			run("Invert");
			
		open(dir2+list2[i]);
		selectWindow(list2[i]);
			run("8-bit");
			//rename("test2");
			run("Invert");
			




			
print(dir2+list2[i]);

		//subtract the two open images, should be named dir+list[i] and dir2+list2[i]
		//imageCalculator("Subtract create", dir+list[i], dir2+list2[i]);
imageCalculator("Subtract create", list[i], list2[i]);

//Select the resulting window by name and save
//selectWindow("Result of "+ dir+list[i] +" - "+ dir2+list2[i);
//selectWindow("Result of "+list2[i]);
testname = "";
saveAs("png", dirout+list[i] + testname);
close();
close("test1");
close("test2");
	}

}






//summarize all data and copy the results
run("Summarize");
String.copyResults();
setBatchMode(false);

//create a text file with counting results
saveAs("Results",dir+"Cell counting results (ccm1).txt");
}
