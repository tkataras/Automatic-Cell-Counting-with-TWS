//apply one classifier to 

run("Trainable Weka Segmentation"); 



call("trainableSegmentation.Weka_Segmentation.loadClassifier",
SelectedClassifier);
call("trainableSegmentation.Weka_Segmentation.applyClassifier", "F:\\Theo\\full_backup_3_23_2021\\Kaul_lab_work\\bin_general\\training_area\\testing_area\\images", "BKO-426-S57-Iba-Syn-Cortex-10x-F1a_XY1562014005_Z0_T0_C2.tiff8bit.pngcropped.pngNpt3.png", "showResults=true", "storeResults=false", "probabilityMaps=false", "");


SelectedClassifier


call("trainableSegmentation.Weka_Segmentation.loadClassifier",
 "/home/iarganda/classifier.model");


call("trainableSegmentation.Weka_Segmentation.applyClassifier", "F:\\Theo\\full_backup_3_23_2021\\Kaul_lab_work\\bin_general\\training_area\\testing_area\\images", "BKO-426-S57-Iba-Syn-Cortex-10x-F1a_XY1562014005_Z0_T0_C2.tiff8bit.pngcropped.pngNpt3.png", "showResults=true", "storeResults=false", "probabilityMaps=false", "");