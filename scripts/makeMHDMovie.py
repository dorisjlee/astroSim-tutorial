from plotSim import *
SAVE_LOC = "/global/homes/d/dorislee/data_astroSim/MHD_y_vel_B/"
START= 0
END = 198
INTERVAL = 1
import os
os.chdir("/global/homes/d/dorislee/proj/dlee/FLASH4.3/SimDataMHDSphere/")
for i in np.arange(START,END,INTERVAL):
    print "Working on t =", i
    plot_var(i,cut="y",physical_quantity="density",magnetic=True,velocity=True,scale=True,save_path=SAVE_LOC)    
os.system("convert -delay 0.1 {}* mhd_sphere_density.gif".format(SAVE_LOC))
