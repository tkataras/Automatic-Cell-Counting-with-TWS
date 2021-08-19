run("Subtract Background...", "rolling=8 sliding");
title = getTitle();
prefix = substring (title, 51, lastIndexOf(title,"-"));
prefix2 = replace(prefix," ","_")
prefix3 = prefix2 + ".tiff"
prefix4 = replace(prefix3,":","in")
loc = "D:\\Deepika\\Uroosa\\Iba1 MABN92 Millipore\\secondary anti-mouse IgG\\Methanol\\";
saveAs("tiff", loc+prefix4);
write(prefix4) 
//saveAs("tiff", loc+"test7.tiff"); 
close()