# vim: fdm=indent
'''
author:     Fabio Zanini
date:       03/06/21
content:    Make dataset file from counts and using gene names.
'''
import os
import sys
import numpy as np
import pandas as pd
import anndata
from pyensembl import EnsemblRelease


if __name__ == '__main__':


    print('Load raw count data')
    fn_counts = '/home/yike/phd/cancer_cells_img_seq/data/20220201_NextSeq/counts.tsv'
    counts_raw = pd.read_csv(fn_counts, index_col=0, sep='\t').astype(np.float32)

    print('Load biomart conversion table')
    ensembl = EnsemblRelease(77)

    print('Compute intersection')
    counts_raw['gene_name'] = ''
    for fea in counts_raw.index[:4]:
        counts_raw.loc[fea, 'gene_name'] = fea
    for eid in idx:
        counts_raw.loc[eid, 'gene_name'] = ensembl.gene_name_of_gene_id(eid)

    print('Prepare new counts')
    counts = counts_raw.set_index('gene_name').T

    print('Complement feature sheet')
    var = pd.DataFrame([], index=counts.columns)

    print('prepare meta sheet')
    obs = pd.read_csv('/home/yike/phd/cancer_cells_img_seq/data/20220201_NextSeq/read_files.tsv', sep='\t', index_col='Sample').loc[counts.index]
    obs['R1'] = [i[-1] for i in obs['R1'].str.split('/')]
    obs['R2'] = [i[-1] for i in obs['R2'].str.split('/')]

    print('Store to file')
    fn_counts = '/home/yike/phd/cancer_cells_img_seq/data/20220201_NextSeq/raw_with_gene_names.tsv'
    counts.to_csv(fn_counts, sep='\t', index=True)
    fn_varmeta = '/home/yike/phd/cancer_cells_img_seq/data/20220201_NextSeq/raw_with_gene_names_var.tsv'
    var.to_csv(fn_varmeta, sep='\t', index=True)
    obsmeta = '/home/yike/phd/cancer_cells_img_seq/data/20220201_NextSeq/raw_with_gene_names_obs.tsv'
    obs.to_csv(obsmeta, sep='\t', index=True)

    if True:
        X = counts.values

        print('Make anndata')
        adata = anndata.AnnData(
            X=X,
            var=var,
            obs=obs,
        )

        print('Write to file')
        fn_counts = '/home/yike/phd/cancer_cells_img_seq/data/20220201_NextSeq/raw.h5ad'
        adata.write(fn_counts)
