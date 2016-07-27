module Simulation_data
use Particles_sinkData
use pt_sinkInterface, only: pt_sinkCreateParticle, pt_sinkGatherGlobal
#include "constants.h"
#include "Flash.h"
#include "Particles.h"
  implicit none
  integer,save  :: sim_globalMe
  real, save :: fattening_factor,beta_param,xmin,xmax,alpha
  real, save :: sim_gamma, sim_smallP, sim_smallX
  logical, save :: sim_gCell
  integer, save :: sim_meshMe
end module Simulation_data


