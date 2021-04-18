# metamers

code for generating visual metamers as described in 

> freeman and simoncelli, metamers of the ventral stream, nature neuroscience, 2011
> http://www.nature.com/neuro/journal/v14/n9/abs/nn.2889.html

see `contents.m` for what's in here and `metamerTest.m` for testing basic functionality.

written in matlab a long time ago, could probably be greatly improved or enhanced using more modern tools!

This fork of the original metamers repository adds the ability to generate metamers for 360 images in equirectangular format. These can be generated using makeMetamer360SubIm.m in main/. Note that this implementation just processes the 180 degree horizontal region around the fixation point to speed things up (as of early 2021 most headsets have FoVs significantly smaller than 180 degrees).

## Setup

This requires the matlab pyramid tools toolbox from https://github.com/LabForComputationalVision/matlabPyrTools. Before running any of this code make sure to add the matlabPyrTools and this main metamers folder and their subfolders to your matlab PATH (right click on the folders and select "Add to Path -> Selected Folders and Subfolders").

Note that matlabPyrTools uses some MEX files which you might need to compile for your platform (see https://uk.mathworks.com/help/matlab/ref/mex.html).

## Generation

`main/generateMetamer.m` contains code to generate a single 2D metameric image using the parameters from the paper.
