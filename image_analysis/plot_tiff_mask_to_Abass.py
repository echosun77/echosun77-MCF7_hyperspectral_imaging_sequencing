import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import os
import cv2
from PIL import Image

# Functions
# def get_crop_mask(margin_px=30, ):

fdn_Yike = '/home/yike/phd/cancer_cells_img_seq/figures/segmentation/figures/'
fdn_new = '/home/yike/phd/cancer_cells_img_seq/figures/segmentation/cancer100cells/'
mask_fdn = '/home/yike/phd/cancer_cells_img_seq/figures/segmentation/whole_figure_mask/'

margin_px = 30

orig_fns = [i for i in os.listdir(fdn_new) if 'C3_S1' in i]
ncells = len(orig_fns)
for i, fn in enumerate(orig_fns):
    cellname = fn.split('.')[0]
    print(f'{cellname}: {i+1}/{ncells}')

    print('load...')
    raw = np.load(fdn_Yike+fn)
    seg = raw['segmentation']

    print('find ROI...')
    i0s = seg.any(axis=1).nonzero()[0]
    i1s = seg.any(axis=0).nonzero()[0]
    i00, i01 = i0s[0], i0s[-1] + 1
    i10, i11 = i1s[0], i1s[-1] + 1

    print('add margins...')
    i00 = max(0, i00 - margin_px)
    i10 = max(0, i10 - margin_px)
    i01 = min(seg.shape[0], i01 + margin_px)
    i11 = min(seg.shape[1], i11 + margin_px)

    mask = np.zeros([4096, 4096])
    crop_fn = fdn_new + fn
    mask[i00: i01, i10: i11] = 1 * np.load(fdn_new + fn)['new_segmentation']

    mask_mat = Image.fromarray(mask.T)
    mask_mat.save(mask_fdn + cellname + '.tiff')










