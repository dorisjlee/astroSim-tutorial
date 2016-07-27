from plotSim import *
SAVE_LOC = "/global/homes/d/dorislee/data_astroSim/sphere_density/"
START= 655
END = 658
INTERVAL = 1
import os
os.chdir("/global/homes/d/dorislee/proj/dlee/FLASH4.3/SimDataRotatingSinkSphere/")
for i in np.arange(START,END,INTERVAL):
    print "Working on t =", i
    if i<380:
    	plot_dens(i,zmin=5e-22,zmax=1e-17,save_path=SAVE_LOC)
    else:
	plot_dens(i,zmin=5e-22,zmax=1e-17,save_path=SAVE_LOC,zoom=1+(i-380)*0.003)
os.system("convert -delay 0.3 {}* sphere_density.gif".format(SAVE_LOC))
