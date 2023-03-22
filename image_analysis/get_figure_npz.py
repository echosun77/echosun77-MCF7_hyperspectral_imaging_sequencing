import numpy as np
import pandas as pd
import scipy as sp
import matplotlib.pyplot as plt
import matplotlib as mpl
from matplotlib import rcParams
from skimage import io #import image
import os
import cv2
import h5py

def read_image(fn):
    with h5py.File(fn, 'r') as f:
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

def cell_labels(seg_fn):    
    print('import segmentated figure')
    if '_T' in seg_fn:
        seg = cv2.imread(seg_fn, 2).T # 1: color, 2: gray
    else:
        seg = cv2.imread(seg_fn, 2)

    print('get labels of each cell')
    from skimage.segmentation import watershed
    markers = np.zeros_like(seg)
    markers[seg == 2] = 1
    markers[seg == 1] = 2
    segmentation = watershed(seg, markers)

    from scipy import ndimage as ndi
    segmentation = ndi.binary_fill_holes(segmentation - 1)

    labeled, _ = ndi.label(segmentation)
    return seg, labeled

def save_data(img, wls, cell, seg, labeled, n_ls, save_path):
    img_data = {}

    raw = seg.copy()
    px = [np.bincount(labeled.ravel()).argsort()[::-1][int(i)] for i in n_ls]
    raw[ ~ np.isin(labeled, px)] = 2
    cell_seg = raw == 1
    img_data['segmentation'] = cell_seg
    
    img = img.astype(np.uint16)
    for i, wl in enumerate(wls):
        img_data['wls_{}_{}'.format(str(wl[0]), str(wl[1]))] = img[i].T

    np.savez_compressed(save_path + cell + '.npz', **img_data)
    
################################################
print('load segmentation information')
df = pd.read_csv('/home/yike/projects/imaging-sequencing/data/20220201_imaging/good_seg/raw_with_gene_names_obs.tsv', sep='\t', index_col=0)

n_cells = {}
for grid in df[: -4]['grid'].unique():
    n_cells[grid] = {}
    cells = df[df['grid'] == grid].index

    for cell in cells:
        if ',' in df.loc[cell]['#feature']:
            n_ls = df.loc[cell]['#feature'].split(',')
        else:
            n_ls = [df.loc[cell]['#feature']]
        n_cells[grid][cell] = n_ls

###########
seg_fdn = '/home/yike/projects/imaging-sequencing/data/20220201_imaging/good_seg/'
fdn_mat = '/home/yike/projects/imaging-sequencing/data/20220201_imaging/mat_fd/'
save_path = '/home/yike/projects/imaging-sequencing/data/20220201_imaging/figures/'

fns = [i for i in os.listdir(seg_fdn) if 'tiff' in i]

for i, fn in enumerate(fns):
    if '_T' in fn:
        grid = fn.split('.')[0][:-22]
    else:
        grid = fn.split('.')[0][:-20]
        
    print('___________________________')
    print('{} dish {}'.format(i, grid))
    print('get labeled arrays')
    
    seg, labeled = cell_labels(seg_fdn + fn)
    
    print('get image date')
    fn_mat = grid + '.mat'
    data = read_image(fdn_mat + fn_mat)
    img = data['data']
    wls = data['wavelengths']
        
    cells = n_cells[grid].keys()
    for j, cell in enumerate(cells):
        print('{} cell {}'.format(j, cell))
        n_ls = n_cells[grid][cell]
        
        if n_ls == ['FALSE']:
            continue
        
        print('save figure data')
        save_data(img, wls, cell, seg, labeled, n_ls, save_path)
