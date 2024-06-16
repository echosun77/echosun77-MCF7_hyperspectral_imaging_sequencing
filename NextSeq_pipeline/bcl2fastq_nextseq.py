import os
import sys
import argparse
import subprocess as sp


if __name__ == '__main__':

    pa = argparse.ArgumentParser()
    pa.add_argument('--demux', action='store_true')
    args = pa.parse_args()
    
    call = '''
    bcl2fastq
    --runfolder-dir ../../220120_NS500799_0723_AHKJ5VAFX3/
    --loading-threads 16
    --processing-threads 16
    --writing-threads 0
    --no-lane-splitting
    --create-fastq-for-index-reads  # FASTQ files for Index Read 1 and Index Read 2 are typically not necessary, but are generated when this is applied
    '''
    call = call.replace('\n', ' ').replace('  ', ' ')

    if args.demux:
        call += ' --sample-sheet ../../220120_NS500799_0723_AHKJ5VAFX3/SampleSheet.csv'
        call += ' --output-dir ../../220120_NS500799_0723_AHKJ5VAFX3/demuxed/'
    else:
        call += ' --create-fastq-for-index-reads'
        call += ' --output-dir ../../220120_NS500799_0723_AHKJ5VAFX3/muxed/'


    sp.run(call, shell=True, check=True)
