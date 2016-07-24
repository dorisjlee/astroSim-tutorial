import matplotlib
matplotlib.use('agg')
import matplotlib.pyplot as plt
import yt
from yt.units import second, g, cm ,dyne
from yt.visualization.fixed_resolution import FixedResolutionBuffer
G = 6.674e-8*cm**3/second**2/g
ctr = 5e18*cm
yt.mylog.setLevel(50)
import numpy as np
import os
os.chdir("../object")
SAVE_PATH = "/global/homes/d/dorislee/StarFormationCode/FLASH/"
fname = "sod"
i = 494	
ds = yt.load("{0}_hdf5_chk_{1}".format(fname,str(i).zfill(4)))
#print ds.all_data()["density"].max()
print ds.field_info()
