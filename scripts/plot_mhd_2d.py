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
def plot_dens(i,plane="z", velocity=False,grid=False,zmin ="",zmax="",magnetic=False, particle=False):
    ds = yt.load("mhd_sphere_hdf5_chk_{}".format(str(i).zfill(4)))
    physical_quantity="density"
    slc = yt.SlicePlot(ds, plane,physical_quantity)#,center=(0.5,0.5,0.5))
    slc.set_figure_size(5)
    if grid: slc.annotate_grids()
    if velocity: slc.annotate_velocity(normalize=True)
    if magnetic: slc.annotate_magnetic_field()
    slc.set_cmap("all","rainbow")
    if zmin!="" and zmax!="": slc.set_zlim(physical_quantity,zmin,zmax)
    if particle : 
        os.system("cp ../source/Simulation/SimulationMain/unitTest/SinkMomTest/utils/clean_sinks_evol.py .")
        os.system("python clean_sinks_evol.py")
        data =np.loadtxt("sinks_evol.dat_cleaned",skiprows=1)
        pcl_indx_at_t = np.where(np.isclose(int(ds.current_time.in_cgs()),data[:,1]))[0]
        print "Number of sink particles: " , len(pcl_indx_at_t)
        pcl_pos_at_t = data[pcl_indx_at_t,2:5]
        for pos in pcl_pos_at_t:
            slc.annotate_marker(pos, coord_system='data',marker='.',plot_args={'color':'black','s':3})
    slc.save(SAVE_PATH+"{0}_{1}.png".format(ds,physical_quantity))
def plot_var(i,physical_quantity,cut="z",velocity=False,grid=False,zmin ="",zmax="",particle=False):
    ds = yt.load("mhd_sphere_hdf5_chk_{}".format(str(i).zfill(4)))
    slc = yt.SlicePlot(ds, cut,physical_quantity)#,center=(0.5,0.5,0.5))
    slc.set_figure_size(5)
    if grid: slc.annotate_grids()
    if velocity: slc.annotate_velocity()
    magnetic = True
    if magnetic: slc.annotate_magnetic_field()
    slc.set_cmap("all","rainbow")
    if zmin!="" and zmax!="": slc.set_zlim(physical_quantity,zmin,zmax)
    #slc.show()
    slc.save(SAVE_PATH+"{0}_{1}_{2}.png".format(ds,physical_quantity,cut))

def plot_stuff(i):
    print "Plotting timestep ",i
    ds = yt.load("orszag_mhd_2d_hdf5_chk_{}".format(str(i).zfill(4)))
#    os.chdir(SAVE_PATH)
    xdir=0
    ydir=1
    slicedirection=2
    sl = ds.slice(slicedirection,0) ##Get the Slice
    w = [ds.domain_left_edge[xdir],ds.domain_right_edge[xdir],ds.domain_left_edge[ydir],ds.domain_right_edge[ydir]] 
    frb1 = FixedResolutionBuffer(sl,w,(128,128))  #Create FixedResolution Buffer
    plt.figure()
    plt.imshow(np.array(frb1["density"]))
    plt.colorbar()
    plt.savefig(SAVE_PATH+"{0}_density.png".format(ds))
    plt.figure()
    plt.imshow(np.array(frb1["magnetic_field_strength"]))
    plt.colorbar()
    plt.savefig(SAVE_PATH+"{0}_Bstrength.png".format(ds))
def all_direction_slices(timestep):
    from mpl_toolkits.axes_grid1 import AxesGrid
    ds = yt.load("mhd_sphere_hdf5_chk_{}".format(str(timestep).zfill(4)))
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
    physical_quantity='magnetic_field_strength'
    for i, direc in enumerate(direction):
        slc = yt.SlicePlot(ds,direc, physical_quantity)
        slc.set_axes_unit('pc')
        slc.set_font_size(12)
        slc.annotate_magnetic_field()
        plot = slc.plots[physical_quantity]
        plot.figure = fig
        slc.set_cmap(physical_quantity,"rainbow")
        plot.axes = grid[i].axes
        plot.cax = grid.cbar_axes[i]
        slc._setup_plots()
    plt.savefig(SAVE_PATH+"{0}_alldir_Bstrength.png".format(ds))

END_TIME = 158
#plot_dens(0,grid=True,magnetic=True)
#plot_dens(1,grid=True,magnetic=True)
#for i in np.arange(0,END_TIME,20):
#    plot_dens(i,grid=True,magnetic=True)
#plot_dens(END_TIME,grid=True,magnetic=True)

#plot_var(0,"magnetic_field_strength")
#plot_var(1,"magnetic_field_strength")
#for i in np.arange(0,END_TIME,20):
#    plot_var(i,"magnetic_field_strength")
#plot_var(END_TIME,"magnetic_field_strength")

#all_direction_slices(0)
#all_direction_slices(1)
#for i in np.arange(0,END_TIME,20):
#    all_direction_slices(i)
#all_direction_slices(END_TIME)
plot_var(0,"density",cut="x")
plot_var(1,"density",cut="x")
for i in np.arange(0,END_TIME,20):
    plot_var(i,"density",cut="x")
plot_var(END_TIME,"density",cut="x")

