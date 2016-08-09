# astroSim

------------------------------------------------

[![Binder](http://mybinder.org/badge.svg)](http://mybinder.org:/repo/dorisjlee/astrosim-tutorial)
[![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.59657.svg)](http://dx.doi.org/10.5281/zenodo.59657)

Jupyter Notebook tutorials on how to run astrophysical simulations through a classic example of the gravitational collapse of a magnetized, rotating sphere.


<center>
<a href="http://www.youtube.com/watch?feature=player_embedded&v=XnIdxSPN0_A" target="_blank"><img src="https://github.com/dorisjlee/remote/blob/master/astroSim-tutorial-img/sinkmovie.png?raw=true" 
alt="Rotating Sink Sphere" width="300" height="180" border="10" /></a>
<a href="http://www.youtube.com/watch?feature=player_embedded&v=sVQfQ41Z3Xs" target="_blank"><img src="https://github.com/dorisjlee/remote/blob/master/astroSim-tutorial-img/mhdmovie.png?raw=true" 
alt="MHD Sphere" width="300" height="180" border="10" /></a>
</center>
------------------------------------------------
# Table of Contents

- [1-Setting Up FLASH](http://nbviewer.jupyter.org/github/dorisjlee/astroSim-tutorial/blob/master/tutorial/1-Setting%20Up%20FLASH.ipynb)
- [2-Creating Your Own Initial Conditions](http://nbviewer.jupyter.org/github/dorisjlee/astroSim-tutorial/blob/master/tutorial/2-Creating%20Your%20Own%20Initial%20Conditions.ipynb)
- [3-Lane Emden Numerical Solution](http://nbviewer.jupyter.org/github/dorisjlee/astroSim-tutorial/blob/master/tutorial/3-Lane%20Emden%20Numerical%20Solution.ipynb)
- [4-Physics of an Isothermal Sphere](http://nbviewer.jupyter.org/github/dorisjlee/astroSim-tutorial/blob/master/tutorial/4-Physics%20of%20an%20Isothermal%20Sphere.ipynb)
- [5-Running the Simulation](http://nbviewer.jupyter.org/github/dorisjlee/astroSim-tutorial/blob/master/tutorial/5-Running%20the%20Simulation.ipynb)
- [6-Data Analysis and visualization with yt](http://nbviewer.jupyter.org/github/dorisjlee/astroSim-tutorial/blob/master/tutorial/6-Data%20Analysis%20and%20visualization%20with%20yt.ipynb)
- [7-Sink Particles](http://nbviewer.jupyter.org/github/dorisjlee/astroSim-tutorial/blob/master/tutorial/7-Sink%20Particles.ipynb)
- [8-Rotation and Discs](http://nbviewer.jupyter.org/github/dorisjlee/astroSim-tutorial/blob/master/tutorial/8-Rotation%20and%20Discs.ipynb)
- [9-Magnetohydrodynamics](http://nbviewer.jupyter.org/github/dorisjlee/astroSim-tutorial/blob/master/tutorial/9-Magnetohydrodynamics.ipynb)
- [10-Tips and Tricks](http://nbviewer.jupyter.org/github/dorisjlee/astroSim-tutorial/blob/master/tutorial/10-Tips%20and%20Tricks.ipynb)

------------------------------------------------

### How to use the tutorial? 

The notebook links above are read-only, it is much cooler if you could actually run the code interactively by following one of these : 

- To save the fuss of installing all the dependencies, you can simply follow [this link](http://mybinder.org:/repo/dorisjlee/astrosim-tutorial), which magically start off a computational environment for you to execute the code in the notebooks. Note that these instances only last for one hour if inactive, so while it provides a nice playground for learning the material. If you decide to make notes or significant code changes, remember to download your notebook to save your progress.

- Alternatively, if you already have Python and Jupyter notebook installed, you can run it locally: 
```
git clone git@github.com:dorisjlee/astroSim-tutorial.git
cd astroSim/tutorial
ipython notebook 
```
------------------------------------------------
# Motivation: 

These set of tutorial comes from an undergrad's attempt to learn how to use a hydro code to run astrophysical simulation. 
While most hydro code has fairly in-depth documentation,it is often difficult to piece together how different parts of the simulation workflow fits together: from submitting the jobs (HPC knkowledge), understanding numerical methods, writing the code (C,Fortran), data management(Bash,UNIX), analysis and visualization (Python,yt, VisIT..etc). We hope that this step-by-step tutorial of how to simulate the graviational collapse of young star illustrates how these pieces fit together.

------------------------------------------------
# For Developers:

After fiddling with different hydro codes over the past 2 years, we learned that most hydro codes are more alike than they are different (from the user's perspective). Since the tutorial contain not only information how to use the FLASH code but also regarding the phsyics and computation, these base templates makes it easy for developers to fork the repo and adapt it for another hydro code, such as Athena, RAMSES, Enzo ..etc. Also, feel free to submit any errata through pull requests to improve these tutorials. Thanks!
