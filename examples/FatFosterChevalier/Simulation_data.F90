!!****if* source/Simulation/SimulationMain/Sod/Simulation_data
!!
!! NAME
!!  Simulation_data
!!
!! SYNOPSIS
!!
!!  use Simulation_data
!!
!! DESCRIPTION
!!
!!  Store the simulation data for the Sod problem
!!
!! ARGUMENTS
!!
!!
!! PARAMETERS
!!
!!  sim_rhoLeft    Density in the left part of the grid
!!  sim_rhoRight   Density in the right part of the grid
!!  sim_pLeft      Pressure  in the left part of the grid
!!  sim_pRight     Pressure  in the righ part of the grid
!!  sim_uLeft      fluid velocity in the left part of the grid
!!  sim_uRight     fluid velocity in the right part of the grid
!!  sim_xangle     Angle made by diaphragm normal w/x-axis (deg)
!!  sim_ yangle    Angle made by diaphragm normal w/y-axis (deg)
!!  sim_posnR      Point of intersection between the shock plane and the x-axis
!!
!!
!!   
!!
!!***

module Simulation_data
#include "Flash.h"
  implicit none

  !! *** Runtime Parameters *** !!

  real, save :: sim_rhoLeft, sim_rhoRight, sim_pLeft, sim_pRight, fattening_factor 
  real, save :: sim_uLeft, sim_uRight, sim_xAngle, sim_yAngle, sim_posn
  real, save :: sim_gamma, sim_smallP, sim_smallX
#ifdef SIMULATION_TWO_MATERIALS
  real, save :: sim_abarLeft, sim_zbarLeft, sim_abarRight, sim_zbarRight
#endif

#ifdef FLASH_3T
  !! 3T Variables:
  real, save :: sim_pionLeft
  real, save :: sim_pionRight
  real, save :: sim_peleLeft
  real, save :: sim_peleRight
  real, save :: sim_pradLeft
  real, save :: sim_pradRight
#endif

  !! *** Variables pertaining to Simulation Setup 'Sod' *** !!
  real, save :: sim_xCos, sim_yCos, sim_zCos
  logical, save :: sim_gCell

  integer, save :: sim_meshMe
end module Simulation_data


