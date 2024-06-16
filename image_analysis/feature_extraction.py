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
 (339, 575)
]

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
        img = cv2.imread(seg_fn, 2).T # 1: color, 2: gray
    else:
        img = cv2.imread(seg_fn, 2)

    print('get labels of each cell')
    from skimage.segmentation import watershed
    markers = np.zeros_like(img)
    markers[img == 2] = 1
    markers[img == 1] = 2
    segmentation = watershed(img, markers)

    from scipy import ndimage as ndi
    segmentation = ndi.binary_fill_holes(segmentation - 1)

    labeled, _ = ndi.label(segmentation)
    return labeled

def plot_image(img, n_ls, fn_mat, labeled, save_path):
    '''
    plot all cells from a grid in all channels
    '''
    
#     info = read_image(fdn_mat + fn)
#     data = info['data']

    rcParams['pdf.fonttype'] = 42
    rcParams['font.sans-serif'] = "Arial"

    for n in n_ls:
        fig, axs = plt.subplots(3, 5, figsize=(7.87, 4.56), sharex=True, sharey=True, dpi=300)
        axs = axs.ravel()
        px = np.bincount(labeled.ravel()).argsort()[::-1][int(n)]
    
        for i, wl in enumerate(wls):
            row = img[i].copy().T
            row[labeled != px] = 0
            axs[i].imshow(row, interpolation='nearest')
            axs[i].set_title(str(wl[0]) + ' ' + str(wl[1]), fontsize=10)
            axs[i].set_xticks([])
            axs[i].set_yticks([])
        fig.suptitle(fn.split('.')[0] + ' ' + '#' + n)
        fig.tight_layout()
        
        path = save_path + fn_mat.split('.')[0] + '/' 
        folder = os.path.exists(path)
        if not folder: 
            os.makedirs(path)

        plt.savefig(path + '#' + n + '.png')
        plt.savefig(path + '#' + n + '.pdf')
        plt.clf()

def extract_features(img, n_ls, labeled):
    
    # dic = read_image(fdn_mat + fn)
    # img = dic['data']

    # for i in range(15):
    #     img[i, :, :] = img[i, :, :].T
    
    features_all = []
    for n in n_ls:
        px = np.bincount(labeled.ravel()).argsort()[::-1][int(n)]

        for i in range(img.shape[0]):
            img[i] = img[i].T
        raw = img.copy()
        raw[:, labeled != px] = 0
        img_max = raw.max(axis=0)
        img_bin = img_max > 0
        area = (img_max > 0).sum()
        # Horizontal length
        length = img_bin.any(axis=0).nonzero()[0]
        length = length[-1] - length[0]
        # Vertical width (waist line)
        width = img_bin.any(axis=1).nonzero()[0]
        width = width[-1] - width[0]

        # Eccentricity
        ecc = length / width

        # Spectrum
        spectrum = raw.sum(axis=1).sum(axis=1)

        feas = {
            'area': area,
            'length': length,
            'width': width,
            'eccentricity': ecc,
            'spectrum': spectrum,
            'image': fn.split('.')[0],
            'cell': n, 
            'wavelengths': wls
        }

        features_all.append(feas)
        
    features_all = pd.DataFrame(features_all)
    return features_all


print('load segmentation information')
df = pd.read_csv('/home/yike/projects/imaging-sequencing/data/20220201_imaging/good_seg/raw_with_gene_names_obs.tsv', 
                 sep='\t', index_col=0)

n_cells = {}
for grid in df[: -4]['grid'].unique():
    n_ls = df[df['grid'] == grid]['#feature'].tolist()
    
    if 'FALSE' in n_ls:
        n_ls.remove('FALSE')
    
    n_ls_new = []
    for i in n_ls:
        if ',' not in i:
            n_ls_new.append(i)
        else:
            n_ls_new = n_ls_new + i.split(',')
            
    n_cells[grid] = np.unique(n_ls_new).tolist()

# get roughly features
seg_fdn = '/home/yike/projects/imaging-sequencing/data/20220201_imaging/good_seg/'
fdn_mat = '/home/yike/projects/imaging-sequencing/data/20220201_imaging/mat_fd/'
save_path = '/home/yike/projects/imaging-sequencing/data/20220201_imaging/seg_cells/'

fns = [i for i in os.listdir(seg_fdn) if 'tiff' in i]

features = pd.DataFrame([])

for i, fn in enumerate(fns):
    if '_T' in fn:
        grid = fn.split('.')[0][:-22]
    else:
        grid = fn.split('.')[0][:-20]
    print('___________________________')
    print('{} dish {}'.format(i, grid))
    print('get labeled arrays')
    n_ls = n_cells[grid]
    labeled = cell_labels(seg_fdn + fn)
    
    print('get image date')
    fn_mat = grid + '.mat'
    img = read_image(fdn_mat + fn_mat)['data']

    print('plot segmented cells')
    plot_image(img, n_ls, fn_mat, labeled, save_path)
    print('extract features of each cell')
    fes = extract_features(img, n_ls, labeled)
    features = pd.concat([features, fes], axis=0)

# save features as a pickle file
import pickle
with open(seg_fdn + 'features.pkl', 'wb') as f:
    pickle.dump(features, f)
