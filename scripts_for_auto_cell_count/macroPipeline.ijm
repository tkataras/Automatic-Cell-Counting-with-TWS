input = getDirectory("Choose source directory of macro");
print(input);
exec("python", input + "file_architect.py");

//TODO figure out bean shell calling
//runMacro(input + "BS_TWS_apply.bsh", input);

runMacro(input + "just_thresh.ijm");
runMacro(input + "count_from_roi.ijm");
runMacro(input + "count_over_dir.ijm");
y = input + "pipeline.sh";
z = input + "test.py";

print(y);
// Next run classifier comparison
exec("python", z);