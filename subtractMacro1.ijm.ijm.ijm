input = "D:/Deepika/Uroosa/Iba1 MABN92 Millipore/secondary anti-mouse IgG/Methanol/";
output = "D:/Deepika/Uroosa/Iba1 MABN92 Millipore/secondary anti-mouse IgG/Methanol/";
//run("Duplicate...", "duplicate channels=2");
run("Subtract Background...", "rolling=8 sliding");
//run("Tiff...");
write(output)
//run("Save", "save=[D:/Deepika/Uroosa/Iba1 MABN92 Millipore/secondary anti-mouse IgG/Methanol/"+ filename]);
//saveAs("tiff", output + filename);
//run("Save", "save=[filename + "b"]);
title = getTitle();
//saveAs("Tiff", "D:\\Deepika\\Uroosa\\Iba1 MABN92 Millipore\\secondary anti-mouse IgG\\Methanol\\"+title);
//loc = "D:\\Deepika\\Uroosa\\Iba1 MABN92 Millipore\\secondary anti-mouse IgG\\Methanol\\";
loc = "C:\\Users\\User\\Desktop\\";

write(title);
//prefix = substring (title, 43, lastIndexOf(title," "));
prefix = substring (title, 43, 76);
write(prefix)


//saveAs("tiff", loc+prefix+".tiff"); 
//saveAs("tiff", loc+title+".tiff"); 
saveAs("tiff", loc+"testc.tiff")


close();
