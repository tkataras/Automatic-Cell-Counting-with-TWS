input = getDirectory("Choose source directory of macro");
print(input);
runMacro(input + "BS_TWS_apply.bsh");
//runMacro(input + "just_thresh.ijm");
//runMacro(input + "count_from_roi.ijm");
//runMacro(input + "count_over_dir.ijm");
x = input + "file_architect.r";
print(x);
exec("Rscript", x);