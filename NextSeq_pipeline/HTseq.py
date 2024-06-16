import os
import subprocess as sp

path = '/home/yike/projects/imaging-sequencing/data/20220201_NextSeq/STAR/'

save_path = '/home/yike/projects/imaging-sequencing/data/20220201_NextSeq/HTseq/'
fdn = [fn for fn in os.listdir(path) if '.tsv' not in fn]


bams = ''
for fn in fns:

    namei = fn + '.bam'
    pathi = path + fn + '/' + namei
    save_pathi = save_path + namei
    bams + = namei + ' '

    call = '''
    cp Aligned.out.bam '''namei'''
    mv '''pathi''' '''save_pathi'''
    '''
    call = call.replace('\n', ' ').replace('  ', ' ')
    print(call)
    sp.run(call, shell=True, check=True)


call2 = '''
htseq-count 
--additional-attr exon_id 
--additional-attr gene_name 
--counts_output exon_count.tsv 
'''bams''' Homo_sapiens.GRCh38.104.gtf 
'''
sp.run(call2, shell=True, check=True)