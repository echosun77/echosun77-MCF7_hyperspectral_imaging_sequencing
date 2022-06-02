import os
import sys
import numpy as np
import pandas as pd
import subprocess as sp



if __name__ == '__main__':
    fn_samplesheet = '/home/yike/projects/imaging-sequencing/data/20220201_NextSeq/read_files.tsv'
    df = pd.read_csv(fn_samplesheet, sep='\t')
    
    fdn_ref = '/home/yike/Downloads/human_genome/GRCH38_index/'
    
    for _, row in df.iterrows():
        fn_r1 = row['R1']
        fn_r2 = row['R2']
        sn = row['Sample']
        fdn_out = f'/home/yike/projects/imaging-sequencing/data/20220201_NextSeq/STAR/{sn}/'

        print(f'Sample {sn}')
        os.makedirs(fdn_out, exist_ok=True)

        call = '''
        STAR
        --runMode alignReads
        --runThreadN 16
        --genomeDir '''+fdn_ref+'''
        --outFileNamePrefix '''+fdn_out+'''
        --outSAMtype BAM Unsorted
        --outSAMunmapped None
        --outFilterMismatchNmax 10
        --quantMode GeneCounts
        --readFilesIn '''+fn_r1+' '+fn_r2
        # this was 100 when generated and it's not worth making a
        # new STAR_DIR just for this
        #--sjdbOverhang 73

        call = call.replace('\n', ' ').replace('  ', ' ')
        print(call)
        if False:
            sp.run(call, shell=True, check=True)

    counts = {}
    for sn in df['Sample']:
        fn_counts = f'../../data/bam/20210601_MiSeq/{sn}/ReadsPerGene.out.tab'
        # The second column is the unstranded one
        count = pd.read_csv(
            fn_counts, sep='\t', index_col=0, usecols=[0, 1],
            squeeze=True, header=None)
        counts[sn] = count
    counts = pd.DataFrame(counts)
    counts.index.name = 'GeneName'

    fdn_counts = '/home/yike/projects/imaging-sequencing/data/20220201_NextSeq/STAR/'
    os.makedirs(fdn_counts, exist_ok=True)
    counts.to_csv(fdn_counts+'counts.tsv', sep='\t', index=True)



    
