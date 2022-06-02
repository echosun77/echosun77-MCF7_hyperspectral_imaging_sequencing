import os
import subprocess as sp

db_ls = ['O4_S26', 'I5_S33', 'L6_S49', 'K9_S87', 'J10_S99', 'I11_S111',
       'M11_S115', 'E12_S120']

fn = '/home/yike/phd/cancer_cells_img_seq/figures/segmentation/cancer100cells/doublets/'
fns = os.listdir(fn)

for i in db_ls:
    command = 'mv ' + fn + i + '.npz ' + fn + 'distance_cells/' + i + '.npz '
    sp.run(command, shell=True)




