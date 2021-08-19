write(nSlices + " this time")

run("Duplicate...", "title=NewStack.tif duplicate"); 
for (i=1; i<=nSlices; i++) { 
 setSlice(i); 
 // apply your transformation here,  run("Invert", "slice"); 
 run("8-bit", "invert");
};
write("complete");