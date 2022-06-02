'''
author:     Yike
date:       17/05/22
content:    Get features from 100 segmented cells
'''

import numpy as np
import pandas as pd
import pickle

def extract_features(fn):
    img = np.load(fn)

    mask = img['new_segmentation']
    area = mask.sum()
    # Horizontal length
    length = mask.any(axis=0).nonzero()[0]
    length = length[-1] - length[0]
    # Vertical width (waist line)
    width = mask.any(axis=1).nonzero()[0]
    width = width[-1] - width[0]

    # Eccentricity
    ecc = length / width

    # Spectrum
    data = np.empty(list(mask.shape) + [15])
    for i, file in enumerate(img.files[1:-1]):
        data[:, :, i] = img[file] * mask
    spectrum = data.sum(axis=0).sum(axis=0)

    # Wavelengths
    wls = [(int(wl.split('_')[1]), int(wl.split('_')[2])) for wl in img.files[1:-1]]

    feas = {
        'area': area,
        'length': length,
        'width': width,
        'eccentricity': ecc,
        'spectrum': spectrum,
        'image': fn.split('/')[-1].split('.')[0],
        'wavelengths': wls
    }

    return feas


# load single cells
df = pd.read_csv('/home/yike/phd/cancer_cells_img_seq/data/20220201_NextSeq/raw_with_gene_names_obs.tsv', 
                 sep='\t', index_col=0)
sg_cells = df[(df['#feature'] != 'FALSE') & (df['doublets'] == 'No')].index

# file informaton
npz_fdn = '/home/yike/phd/cancer_cells_img_seq/figures/segmentation/cancer100cells/'
save_path = '/home/yike/phd/cancer_cells_img_seq/data/20220201_imaging/'

# extract features of each single cell
features = []
for i, cell in enumerate(sg_cells):
    print('{} cell: {}'.format(i+1, cell))
    feas = extract_features(npz_fdn + cell + '.npz')
    features.append(feas)
features_all = pd.DataFrame(features)

# save features as a pickle file
with open(save_path + 'features.pkl', 'wb') as f:
    pickle.dump(features_all, f)
