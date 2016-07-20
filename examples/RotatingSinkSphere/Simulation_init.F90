!!****if* source/Simulation/SimulationMain/Sod/Simulation_init

subroutine Simulation_init()
  
  use Simulation_data
  use Driver_interface, ONLY : Driver_getMype, Driver_abortFlash
  use RuntimeParameters_interface, ONLY : RuntimeParameters_get
  use Logfile_interface, ONLY : Logfile_stamp
  implicit none
#include "constants.h"
#include "Flash.h"
  
  integer :: myPE, pno, blockID
  real    :: pt
  logical :: restart

  ! do nothing on restart
  call RuntimeParameters_get("restart", restart)

  call Driver_getMype(GLOBAL_COMM, myPE)
  sim_globalMe = myPE
  call RuntimeParameters_get('smallp', sim_smallP)
  call RuntimeParameters_get('smallx', sim_smallX) 
  call RuntimeParameters_get('fattening_factor',fattening_factor) 
  call RuntimeParameters_get('beta_param',beta_param)
  call RuntimeParameters_get('gamma', sim_gamma)
  call RuntimeParameters_get('xmax',xmax)
  call RuntimeParameters_get('xmin',xmin)
  call Logfile_stamp( "initializing  Sphere problem","[Simulation_init]")

end subroutine Simulation_init
