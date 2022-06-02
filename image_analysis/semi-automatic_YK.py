# vim: fdm=indent
'''
author:     Yike
date:       16/05/22
content:    Semi-automatic script: the user selects the points.

LICENSE

This program is released to the public domain.
'''
# Modules
import os
import re
import imageio
import sys
from operator import *
from collections import defaultdict
import numpy as np
from scipy import ndimage as nd

import matplotlib as mpl
from matplotlib import pyplot as plt
from matplotlib.path import Path
from matplotlib import patches

import tkinter.filedialog as tkFileDialog
from tkinter import Button, Tk, Frame

# Classes
class InitialWindow(Frame):

    def createWidgets(self):
        self.QUIT = Button(self)
        self.QUIT["text"] = "Quit"
        self.QUIT["command"] = self.quit

        self.QUIT.pack({"side": "left"})


        self.browse_but = Button(self, text = "Browse",
                                 command = self.loadtemplate,
                                 width = 10).pack({"side": "left"})

    def loadtemplate(self): 
        foldername = tkFileDialog.askdirectory()
        if foldername:
            self.dir_folder.append(foldername)

        self.quit()


    def __init__(self, dir_folder):
        Frame.__init__(self)
        self.pack()
        self.createWidgets()
        self.dir_folder = dir_folder

class LineBuilder(object):
    def __init__(self, fig1, return_code): # lengths
        self.return_code = return_code
        self.fig1 = fig1
        self.objs = {'label': 'cell',
                         'points': [],
                         'coordinates': [],
                         'color': 'red'} 

        # self.lengths = lengths
        self.cid_mouse = self.fig1.canvas.mpl_connect('button_press_event', self.onclick)
        self.cid_keyboard = self.fig1.canvas.mpl_connect('key_press_event', self.onpress)

    # Callback for keyboard exiting
    def onpress(self, event):
        if event.key in ['enter']:
            self.return_code.append('close')
            plt.close(self.fig1)
        else:
            self.return_code.append('close all')
            plt.close(self.fig1)

    # Callback for mouse click events
    def onclick(self, event):
        '''Select that point and, if not already present, draw a point'''

        # Left button is the cell
        if event.button == 1:
            label = 'cell'
            self.objs['coordinates'].append([event.xdata, event.ydata])
            p = event.inaxes.scatter(event.xdata, event.ydata, s=20,
                facecolor=self.objs['color'], edgecolor='none')
            self.objs['points'].append(p)

        else:
            return
        event.canvas.draw()

# Functions
def find_image_files(foldername='.'):
    foldername = foldername.rstrip(os.path.sep)+os.path.sep
    return [foldername+f for f in os.listdir(foldername)
            if (len(f) > 3) and f[-3:] in
            ['jpg', 'JPG', 'jpeg', 'JPEG', 'png', 'PNG', 'npz']]

def analyze_image(fn, return_code):
    # Load image
    if 'npz' in fn:
        img= np.load(fn)
        image = np.empty(list(img[img.files[0]].shape) + [3])
        for i, j in enumerate([4, 9, 13]): 
            dd = (img[img.files[j]] / img[img.files[j]].max() * 255).astype(np.uint8)
            dd = (dd * 30.0 / np.bincount(dd.ravel()).argmax()).astype(np.uint8)# normalized brightfield
            image[:, :, i] = dd
            image = image.astype('uint8')

    else:
        image = imageio.imread(fn)

    # Make figure
    fig1, ax1 = plt.subplots(figsize=(5, 5), dpi=300)
    #ax1 = fig1.add_subplot(111)
    ax1.set_title('{}\n'.format(fn.split('/')[-1].split('.')[0]) +
        'Press Enter to continue or any other key to stop')
    ax1.imshow(image)
    ax1.axis('off')
    ax1.autoscale(False)
    plt.tight_layout()

    coord = LineBuilder(fig1, return_code)
 
    plt.ioff()
    plt.show()

    return coord.objs['coordinates'], image

def save_results(coord, foldername):
    if not len(coord):
        return

    # Write results
    foldername = foldername.rstrip(os.path.sep)+os.path.sep

    if not os.path.exists(foldername+'coordinates.txt'):
        with open(foldername + 'coordinates.txt', 'w') as f:
            f.write('\t'.join(['# Image filename',
                               'coordinates'])+'\n')
            f.write('\t'.join(map(str, [os.path.basename(fn).split('.')[0],
                coord]))+'\n')
    else:
        with open(foldername + 'coordinates.txt', 'a') as f:
            f.write('\t'.join(map(str, [os.path.basename(fn).split('.')[0],
                coord]))+'\n')

def add_new_seg(fn, coord, image):
    img = np.load(fn)

    # matplotlib path
    path = Path(coord)
    xmin, ymin, xmax, ymax = np.asarray(path.get_extents(), dtype=int).ravel()

    # create a mesh grid of the shape of the final mask
    x, y = np.mgrid[: image.shape[1], : image.shape[0]]
    # mesh grid to points
    points = np.vstack((x.ravel(), y.ravel())).T

    # mask for the point included in the path
    mask = path.contains_points(points)
    mask = mask.reshape(x.shape).T
    data = dict(img)
    data['new_segmentation'] = mask
    np.savez_compressed(fn, **data)

# Script
if __name__ == '__main__':

    # Dialog window for folder choice
    dir_folder = []
    root = Tk()
    app = InitialWindow(dir_folder)
    app.mainloop()
    root.destroy()
    if not dir_folder:
        sys.exit(0)

    foldername = dir_folder[0].rstrip(os.path.sep)+os.path.sep
    image_filenames = find_image_files(foldername)

    # Iterate over images
    # lengths = {}
    for i, fn in enumerate(image_filenames):

        print('File {}: {}'.format(str(i + 1), fn.split('/')[-1].split('.')[0]))
        return_code = []
        try:
            coord, image = analyze_image(fn, return_code)
        except IOError:
            print(fn.split('/')[-1].split('.')[0], 'ignored, continuing with next image...')
            continue

        # lengths[fn] = lengths_dict
        if len(return_code) > 0:
            if return_code[0] == 'close all':
                break
        # Save
        save_results(coord, foldername) 
        if 'npz' in fn:
            add_new_seg(fn, coord, image)

    sys.exit(0)

