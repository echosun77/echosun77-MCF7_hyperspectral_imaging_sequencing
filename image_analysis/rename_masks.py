import subprocess as sp
import os

path = '/home/yike/phd/cancer_cells_img_seq/figures/segmentation/whole_figure_mask/'
obs = pd.read_csv('/home/yike/phd/cancer_cells_img_seq/data/20220201_NextSeq/raw_with_gene_names_obs.tsv', 
                  sep='\t', index_col=0)
files = os.listdir(path)
for file in files:
    name = file.split('-')[1].split('.')[0]
    mask_name = obs.loc[name]['mask_name'] + '.tiff'
    command = 'mv ' + path + file + ' ' + path + mask_name
    sp.run(command, shell=True)