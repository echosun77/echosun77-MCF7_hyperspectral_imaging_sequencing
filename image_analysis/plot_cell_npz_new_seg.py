import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import os



###########
npz_fdn = '/home/yike/phd/cancer_cells_img_seq/figures/segmentation/cancer100cells/doublets/distance_cells/'
save_path = '/home/yike/phd/cancer_cells_img_seq/figures/hyperspectral_images/cancer100cells/new_segmentation/'

fns = [i for i in os.listdir(npz_fdn) if ('I5_S33.npz' == i)]

for i, fn in enumerate(fns):

    image = np.load(npz_fdn + fn)
    sample = fn.split('.')[0]
    
    print(f'This is the {i} cell {sample}')
    fig, axs = plt.subplots(4, 4)
    axs = axs.ravel()

    for j, file in enumerate(image.files[1:-1]):
        axs[j].imshow(image[file] * (image['new_segmentation']))
        axs[j].set_title(file)
        axs[j].axis('off')
    axs[-1].imshow(image['new_segmentation'])
    axs[-1].set_title('new_segmentation')
    axs[-1].axis('off')

    plt.savefig(save_path + sample + '.png', dpi=300, bbox_inches='tight')
    plt.clf()


