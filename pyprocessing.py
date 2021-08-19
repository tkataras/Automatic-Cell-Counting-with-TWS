# -*- coding: utf-8 -*-
"""
Created on Tue Jul 23 12:06:17 2019

@author: User
"""
import os

os.getcwd()
os.chdir('E:/Theo/from_indira/2steptest/')

import numpy as np

import cv2
#pip install opencv-rolling-ball

import numpy as np

from medpy.filter.smoothing import anisotropic_diffusion


#anisodiff(img, niter=20, kappa = 20, gamma = )

from cv2_rolling_ball import subtract_background_rolling_ball


# Load an color image in grayscale
img = cv2.imread('J20_NeuN_Master List.sld - J20_7-s40-NeuN-052119-cortex-40x-F1 - C=0.tif',0)

img = anisotropic_diffusion(img)

img, background = subtract_background_rolling_ball(img, 60, light_background=False, use_paraboloid=False, do_presmooth=True)


#            img = cv2.equalizeHist(img.astype(np.uint8))

img = cv2.equalizeHist(img)

cv2.imshow("test",img)

#imwrite("testing1.jpg", img)
cv2.imwrite("testing1.jpg",img)
cv2.imwrite("testingbkg.jpg",background)

#### workin in the image subtraction, the processing can be done in imagej
entries = os.listdir('./')
entries

entries[6]
entries[entries == entries[1][1:73]]


entries intersection entries[1][1:73]


img2 = cv2.imread(entries[entries == entries[1]])

entries[1][1:73]

import re






J20_NeuN_Master List.sld - J20_10-s55-NeuN-052119-cortex-40x-F1 - C=0.tif




