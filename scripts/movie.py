import yt
from matplotlib import animation
from tempfile import NamedTemporaryFile
import base64

VIDEO_TAG = """<video controls>
 <source src="data:video/x-webm;base64,{0}" type="video/webm">
 Your browser does not support the video tag.
</video>"""

def anim_to_html(anim):
    if not hasattr(anim, '_encoded_video'):
        with NamedTemporaryFile(suffix='.webm') as f:
            anim.save(f.name, fps=6, extra_args=['-vcodec', 'libvpx'])
            video = open(f.name, "rb").read()
        anim._encoded_video = base64.b64encode(video)
    
    return VIDEO_TAG.format(anim._encoded_video.decode('ascii'))
from IPython.display import HTML

def display_animation(anim):
    plt.close(anim._fig)
    return HTML(anim_to_html(anim))
yt.mylog.setLevel(50)
import matplotlib.pyplot as plt
from matplotlib.backends.backend_agg import FigureCanvasAgg
import os 
os.chdir("/global/homes/d/dorislee/proj/dlee/FLASH4.3/object/")
fname="sphere"
i=0
ds = yt.load("{0}_hdf5_chk_{1}".format(fname,str(i).zfill(4)))
physical_quantity="density"
slc = yt.SlicePlot(ds, 'z',physical_quantity)
slc.set_figure_size(5)
# if zoom!="": slc.zoom(zoom)
# if grid: slc.annotate_grids()
slc.annotate_velocity(normalize=True)
slc.set_cmap("all","rainbow")
slc.set_zlim(physical_quantity,5e-22,1e-17)
fig =slc.plots[physical_quantity].figure
def animate(i):
    ds = yt.load("sphere_hdf5_chk_{}".format(str(i).zfill(4)))
    slc._switch_ds(ds)

# call the animator.  blit=True means only re-draw the parts that have changed.
anim = animation.FuncAnimation(fig, animate, frames=44, interval=200, blit=False)
anim.save("movie.mpg")
# call our new function to display the animation
display_animation(anim)
