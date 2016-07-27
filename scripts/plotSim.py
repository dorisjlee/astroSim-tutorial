import matplotlib
#matplotlib.use('agg')
import matplotlib.pyplot as plt
import yt
from yt.units import second, g, cm ,dyne
from yt.visualization.fixed_resolution import FixedResolutionBuffer
G = 6.674e-8*cm**3/second**2/g
ctr = 5e18*cm
yt.mylog.setLevel(50)
import numpy as np
import os
# Particle Clean File  
# cp ../source/Simulation/SimulationMain/unitTest/SinkMomTest/utils/clean_flashdat.py . 
# python clean_sinks_evol.py
def plot_dens(i,fname="sphere",plane="z", velocity=False,grid=False,zmin ="",zmax="",magnetic=False, particle=False,zoom="", save_path=""):
    ds = yt.load("{0}_hdf5_chk_{1}".format(fname,str(i).zfill(4)))
    physical_quantity="density"
    slc = yt.SlicePlot(ds, plane,physical_quantity)#,center=(0.5,0.5,0.5))
    slc.set_figure_size(5)
    slc.annotate_text((0.05, 0.02),"Time: {} Myr".format(round(ds.current_time.in_cgs().in_units('Myr'),3)), coord_system='axis')
    if zoom!="": slc.zoom(zoom)
    if grid: slc.annotate_grids()
    if velocity: slc.annotate_velocity(normalize=True)
    if magnetic: slc.annotate_magnetic_field()
    slc.set_cmap("all","rainbow")
    if zmin!="" and zmax!="": slc.set_zlim(physical_quantity,zmin,zmax)
    if particle : 
        #os.system("cp ../source/Simulation/SimulationMain/unitTest/SinkMomTest/utils/clean_sinks_evol.py .")
        os.system("python clean_sinks_evol.py")
        data =np.loadtxt("sinks_evol.dat_cleaned",skiprows=1)
        pcl_indx_at_t = np.where(np.isclose(int(ds.current_time.in_cgs()),data[:,1]))[0]
        print "Number of sink particles: " , len(pcl_indx_at_t)
        pcl_pos_at_t = data[pcl_indx_at_t,2:5]
        for pos in pcl_pos_at_t:
            slc.annotate_marker(pos, coord_system='data',marker='.',plot_args={'color':'black','s':3})
    if save_path !="":
        slc.save(save_path+"{0}_{1}.png".format(ds,physical_quantity))
    else:
	slc.show()
def plot_var(i,physical_quantity,fname="sphere",cut="z",velocity=False,grid=False,zmin ="",zmax="",particle=False,save_path=""):
    ds = yt.load("{0}_hdf5_chk_{1}".format(fname,str(i).zfill(4)))
    slc = yt.SlicePlot(ds, cut,physical_quantity)#,center=(0.5,0.5,0.5))
    slc.set_figure_size(5)
    if grid: slc.annotate_grids()
    if velocity: slc.annotate_velocity()
    slc.set_cmap("all","rainbow")
    if zmin!="" and zmax!="": slc.set_zlim(physical_quantity,zmin,zmax)
    if save_path !="":
        slc.save(save_path+"{0}_{1}.png".format(ds,physical_quantity))
    else:
        slc.show()
def all_direction_slices(i,fname="sphere",physical_quantity="density",zmin="",zmax="",zoom="",save_path=""):
    from mpl_toolkits.axes_grid1 import AxesGrid
    ds = yt.load("{0}_hdf5_chk_{1}".format(fname,str(i).zfill(4)))
    fig = plt.figure()
    grid = AxesGrid(fig, ( (0, 0, 0.8, 0.8)),
                    nrows_ncols = (1, 3),
                    axes_pad = 1.0,
                    label_mode = "1",
                    share_all = True,
                    cbar_location="right",
                    cbar_mode="each",
                    cbar_size="3%",
                    cbar_pad="0%")
    direction = ['x','y','z']
    for i, direc in enumerate(direction):
        slc = yt.SlicePlot(ds,direc, physical_quantity)
        slc.set_axes_unit('pc')
        slc.set_font_size(12)
	if zmin!="" and zmax!="": slc.set_zlim(physical_quantity,zmin,zmax)
	if zoom!="": slc.zoom(zoom)
        slc.annotate_magnetic_field()
        plot = slc.plots[physical_quantity]
        plot.figure = fig
        slc.set_cmap(physical_quantity,"rainbow")
        plot.axes = grid[i].axes
        plot.cax = grid.cbar_axes[i]
        slc._setup_plots()
    if save_path !="":
    	plt.savefig(save_path+"{0}_alldir_{1}.png".format(ds,physical_quantity))
    else:
        plt.show()
