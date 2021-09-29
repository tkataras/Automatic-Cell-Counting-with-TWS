tot_num_img = nImages
for (i=0;i<tot_num_img;i++) {
	print(nImages + "tot images");
	tit = getTitle();
	selectWindow(tit);
	run("8-bit");
	saveAs("PNG", "F:/primary microglia Jeff images/New Folder/"+tit);
	close();
	print(i + "image just closed");
	}

