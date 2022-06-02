import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import os



###########
npz_fdn = '/home/yike/phd/cancer_cells_img_seq/figures/segmentation/cancer100cells/'
save_path = '/home/yike/phd/cancer_cells_img_seq/figures/hyperspectral_images/cancer100cells/'

fns = [i for i in os.listdir(npz_fdn) if ('npz' in i) & (i.split('.')[0] + 'png.png' not in
                                                       os.listdir(save_path))]

for i, fn in enumerate(fns):

    image = np.load(npz_fdn + fn)
    sample = fn.split('.')[0]
    
    print(f'This is the {i} cell {sample}')
    fig, axs = plt.subplots(4, 4)
    axs = axs.ravel()

    for i, file in enumerate(image.files[:16]):
        axs[i].imshow(image[file], interpolation='nearest')
        axs[i].set_title(file)
        axs[i].axis('off')

    plt.savefig(save_path + sample + '.png', dpi=300, bbox_inches='tight')
    plt.clf()


