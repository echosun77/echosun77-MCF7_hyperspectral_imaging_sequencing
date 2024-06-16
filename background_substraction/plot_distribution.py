'''
Date: 13/Feb/2023
Aim: plot the distribution of samples and waters
Author: Yike Xie
'''

import os
import numpy as np
import scipy as sp
import pandas as pd
import h5py

import matplotlib.pyplot as plt

from matplotlib.path import Path
from matplotlib.lines import Line2D


wls = [
      (325, 414),
      (343, 414),
      (370, 414),
      (343, 451),
      (370, 451),
      (373, 451),
      (343, 575),
      (393, 575),
      (406, 575),
      (441, 575),
      (400, 594),
      (406, 594),
      (431, 594),
      (480, 594),
      (339, 575),
 ]

def read_image(fn):
    with h5py.File(fn) as f:
        print('Read metadata about excitation/emission lambdas')
        keys = ['excitationWavelength', 'emission']
        wls = {key: [] for key in keys}
        for key in keys:
            tmp = f['HAC_Image']['imageStruct']['protocol']['channel'][key]
            n_colors = tmp.size
            for i in range(n_colors):
                tmpi = f[f[tmp[i, 0]][0, 0]][:, 0]
                wl = int(tmpi.astype(dtype=np.uint8).tobytes().decode())
                wls[key].append(wl)
        wls['combo'] = []
        for i in range(n_colors):
            wls['combo'].append(
                (wls['excitationWavelength'][i], wls['emission'][i]),
                )

        print('Read image data')
        img = f['HAC_Image']['imageStruct']['data'][:, :, :]
    return {
        'data': img,
        'wavelengths': wls['combo'],
        'image': os.path.basename(fn).split('.')[0],
    }

fdn_ctl = '/home/yike/phd/cancer_cells_img_seq/data/20220201_imaging/control/'

imgs = {}
datas = {}

for fn in ['Water-1.mat', 'Water-2.mat']:
      res = read_image(os.path.join(fdn_ctl, fn))
      imgs[fn.split('.')[0]] = res['data']

fdn_s = '/home/yike/phd/cancer_cells_img_seq/data/20220201_imaging/'


