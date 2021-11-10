input = getDirectory("Choose source directory of the macro (Scripts for Auto Cell Count)");
print(input);
exec("python", input + "audit.py");

exec("python", "F:/Theo/full_backup_3_23_2021/Kaul_lab_work/bin_general/scripts_for_auto_cell_count/" + "audit.py");

"F:/Theo/full_backup_3_23_2021/Kaul_lab_work/bin_general/scripts_for_auto_cell_count/"