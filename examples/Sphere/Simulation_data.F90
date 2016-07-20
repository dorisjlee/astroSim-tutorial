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
!!  Store the simulation data for the Collapsing Sphere problem
!!
!! PARAMETERS
!!
!!  fattening_factor The factor used for enhancing the density of the sphere based on the Lane-Emden solution 
!!
!!***

module Simulation_data
#include "Flash.h"
  implicit none

  real, save :: sim_gamma, fattening_factor
  logical, save :: sim_gCell
  integer, save :: sim_meshMe
end module Simulation_data


