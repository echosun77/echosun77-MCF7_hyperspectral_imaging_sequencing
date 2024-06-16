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
import pickle


def plot_bubble_spectrum(spectrum, wls):
    rcParams['pdf.fonttype'] = 42
    rcParams['font.sans-serif'] = "Arial"
    
    wls_ex = list(np.unique([x[0] for x in wls]))
    wls_em = list(np.unique([x[1] for x in wls]))
    nex = len(wls_ex)
    nem = len(wls_em)
    smax = spectrum.max()
    snorm = spectrum / smax

    fig, ax = plt.subplots(figsize=(0.5 + 0.4 * nem, 0.1 + 0.4 * nex), dpi=300)
    for (wex, wem), val in zip(wls, snorm):
        x = wls_em.index(wem)
        y = wls_ex.index(wex)
        r = (3 + 97 * val) / 200.
        alpha = 0.2 + 0.8 * val
        h = plt.Circle(
            (x, y), r, ec='none', fc='black', alpha=alpha,
            )
        ax.add_artist(h)
    ax.set_xlim(-0.6, nem - 0.4)
    ax.set_ylim(-0.6, nex - 0.4)
    ax.set_xticks(np.arange(nem))
    ax.set_yticks(np.arange(nex))
    ax.set_xticklabels([str(x) for x in wls_em])
    ax.set_yticklabels([str(x) for x in wls_ex])
    ax.set_xlabel('$\lambda_{emiss}$ [nm]')
    ax.set_ylabel('$\lambda_{exit}$ [nm]')

    fig.tight_layout()
    return {
        'fig': fig,
        'ax': ax,
    }


bubble_path = '/home/yike/projects/imaging-sequencing/data/20220201_imaging/bubble_spectrum/'

fn_out = bubble_path +'features.pkl'
with open(fn_out, 'rb') as f:
    features = pickle.load(f)

print('plot bubble spectrum')
cells = features[(features['doublets'] == 'No') & (features['#cells'] == 1)]
for i, image in enumerate(cells['image'].unique()):
    print('___________________________________')
    print('grid {}: {}'.format(str(i), image))
    cellsi = cells[cells['image'] == image]
    for index in cellsi.index:
        wlsi = cellsi.loc[index]['wavelengths']
        grid = cellsi.loc[index]['image']
        cell = cellsi.loc[index]['cell']

        # remove (339, 575)
        bb_plot = plot_bubble_spectrum(cellsi.loc[index]['spectrum'][:-1], wlsi[:-1])['fig']
        title = grid + ' ' + index
        bb_plot.suptitle(title, x=0.6)
        bb_plot.tight_layout()
        
        path = bubble_path + image + '/'
        folder = os.path.exists(path)
        if not folder:
            os.makedirs(path) 
        bb_plot.savefig(path + title + '_bubble.png')
        bb_plot.savefig(path + title + '_bubble.pdf')
