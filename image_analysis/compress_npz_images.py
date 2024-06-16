# Compress images from Yike, which are 300MB each... uff 
import os
import sys
import numpy as np
 

fdn_Yike = '/home/yike/projects/imaging-sequencing/data/20220201_imaging/figures_npz/'
fdn_new = '/home/yike/projects/imaging-sequencing/data/20220201_imaging/figures_npz/cancer100cells/'


if __name__ == '__main__':

    # Crop each image to the cell, without *exact* cropping and with some margins
    # to allow for dilation if necessary
    margin_px = 30

    orig_fns = [i for i in os.listdir(fdn_Yike) if '.' in i]
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

        print('crop...')
        img_dict = {}
        for key, val in raw.items():
            img_dict[key] = val[i00: i01, i10: i11]

        print('save to file...')
        np.savez_compressed(fdn_new+fn, **img_dict)

        print('done')
