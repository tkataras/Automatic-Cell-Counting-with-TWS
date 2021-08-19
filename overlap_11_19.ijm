macro "overlap--Maxima" {

//this code subtracts a binary image(the first) from the second 
//show prompt for selection of source directory
dir = getDirectory("Choose source directory for the auto count");
dir2 = getDirectory("Choose source directory for the hand count");
list = getFileList(dir);	//get the file list
list2 = getFileList(dir2);	//get the file list

setBatchMode(true);	//hide all the details from user
//process every file...
for (i=0; i<list.length; i++) {


		
	//open the files from each folder
		open(dir+list[i]);
		rename("test1");
			//process the auto images
			run("8-bit");
			setAutoThreshold("Default dark");
			//run("Threshold...");
			//setThreshold(133, 255);
			run("Convert to Mask");
			run("Erode");
			//run("Invert");
			
		open(dir2+list2[i]);
			run("8-bit");
			rename("test2");
			
print(dir2+list2[i]);

		//subtract the two open images, should be named dir+list[i] and dir2+list2[i]
		//imageCalculator("Subtract create", dir+list[i], dir2+list2[i]);
imageCalculator("Subtract create", "test2", "test1");
			
//selectWindow("Result of "+ dir+list[i] +" - "+ dir2+list2[i);
selectWindow("Result of test2");
testname = "nice";
saveAs("png", dir+list[i] + testname);

	}
}






//summarize all data and copy the results
run("Summarize");
String.copyResults();
setBatchMode(false);

//create a text file with counting results
saveAs("Results",dir+"Cell counting results (ccm1).txt");
}
