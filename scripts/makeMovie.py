from plotSim import *
SAVE_LOC = "/global/homes/d/dorislee/astroSim-tutorial/scripts/sphere_density"
START= 0
END = 100
INTERVAL = 5
import os
os.chdir("/global/homes/d/dorislee/proj/dlee/FLASH4.3/object/")
for i in np.arange(START,END,INTERVAL):
    print "Working on t =", i
    plot_dens(i,velocity=True,zmin=5e-22,zmax=1e-17,save_path=SAVE_LOC)

