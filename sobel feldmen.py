# -*- coding: utf-8 -*-
"""
Created on Mon Apr  1 11:46:35 2019

@author: User
"""

import cv2
from AmbrosioTortorelliMinimizer import *



cv2.imread("C:/Users/User/Desktop/Kaul_lab_work/deepika_counting_local/test2_jpg.jpg", 0)


    img = cv2.imread("D:/Theo/LAV1669-Calbindin-Parvalbumin-082918.sld - LAV1669-s76-Calbindin-Parvalbumin-082918-cortex-F2 - C=1 PNG.png", 0)
    solver = AmbrosioTortorelliMinimizer(img)
    img, edges = solver.minimize()


LAV1669-Calbindin-Parvalbumin-082918.sld - LAV1669-s76-Calbindin-Parvalbumin-082918-cortex-F2 - C=1
#cv2.imwrite('messigray.png',img)

cv2.imwrite("LAV1669-Calbindin-Parvalbumin-082918.sld - LAV1669-s76-Calbindin-Parvalbumin-082918-cortex-F2 - C=1 PNG smoothed.png", img)


import os 
dir_path = os.path.dirname(os.path.realpath(__file__))
dir_path
cwd = os.getcwd()
cwd
    C:/Users/User/Desktop/Kaul_lab_work/deepika_counting_local/HPC332_40X_GL_MAP2_NeuN_01282019_s45_H_F2_XY1548703344_Z00_T0_C0-1.tif z24.tif
    

###run code below, sets working dir to the sobel feld, then does hist equalization
os.chdir("C:/Users/User/Downloads/Ambrosio-Tortorelli-Minimizer-master/Ambrosio-Tortorelli-Minimizer-master/")
from AmbrosioTortorelliMinimizer import *
import cv2
import numpy as np
from matplotlib import pyplot as plt

#mypath = "E:/Theo/from_deepika/map2_neun_40x/subimages/final/final_bkg_sub_png/"
#mypath = "E:/Theo/from_deepika/map2_neun_40x/343/images/bkg_sub/"
#mypath = "E:/Theo/from_deepika/map2_neun_40x/subimages/final/final_bkg_sub_png/"
mypath = "E:/Theo/from_deepika/map2_neun_40x/343/processing/bkg_sub/"
mypath = "E:/Theo/from_deepika/map2_neun_40x/343/images/final_hist_eq/"
from os import listdir
from os.path import isfile, join
onlyfiles = [f for f in listdir(mypath) if isfile(join(mypath, f))]
onlyfiles
i=onlyfiles[0]
for i in onlyfiles:
        img = cv2.imread(mypath+i, 0)        
        #img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        solver = AmbrosioTortorelliMinimizer(img)
        img, edges = solver.minimize()
        #equ = cv2.equalizeHist(img)
        #img = equ
        #clahe = cv2.createCLAHE(clipLimit=2.0, tileGridSize=(8,8))
        #cl1 = clahe.apply(img)
        name = i+"_sf_histeq.png"
        cv2.imwrite(name, img)




result, edges = [], []
for c in cv2.split(img):
	solver = AmbrosioTortorelliMinimizer(c, alpha = 1000, beta = 0.01, 
	epsilon = 0.01)
	
	f, v = solver.minimize()
	result.append(f)
	edges.append(v)

img = cv2.merge(result)
edges = np.maximum(*edges)



###histogram equalization
        
    4 
    5 img = cv2.imread('wiki.jpg',0)
    6 
    7 hist,bins = np.histogram(img.flatten(),256,[0,256])
    8 
    9 cdf = hist.cumsum()
   10 cdf_normalized = cdf * hist.max()/ cdf.max()


#imaging tools in python
import cv2
import PIL

myimg = "E:/Theo/from_deepika/map2_neun_40x/343/clahe b4 z project/testing_z23.png"
myimg = "E:/Theo/from_deepika/map2_neun_40x/343/MAX_HPC343 Map2_NeuN all (CI).sld - HPC343 MAP2_NeuN_01042019_s60_C_F2 - C=1 z57 take 2.tif"

img = cv2.imread(myimg, 0)        
        #img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
solver = AmbrosioTortorelliMinimizer(img)
img, edges = solver.minimize()
        #equ = cv2.equalizeHist(img)
        #img = equ
#clahe = cv2.createCLAHE(clipLimit=2.0, tileGridSize=(8,8))
#cl1 = clahe.apply(img)
#img = cv2.equalizeHist(img)
name = "testing_s60F2z57"+"stdhisteq2_.png"
cv2.imwrite(name, img)

