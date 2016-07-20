!!****if* source/Simulation/SimulationMain/Sod/Simulation_init

subroutine Simulation_init()
  
  use Simulation_data
  use Driver_interface, ONLY : Driver_getMype, Driver_abortFlash
  use RuntimeParameters_interface, ONLY : RuntimeParameters_get
  use Logfile_interface, ONLY : Logfile_stamp
  implicit none
#include "constants.h"
#include "Flash.h"
  call Driver_getMype(MESH_COMM, sim_meshMe)
  call RuntimeParameters_get('fattening_factor',fattening_factor ) 
  call RuntimeParameters_get('gamma', sim_gamma)
  call Logfile_stamp( "initializing Sphere problem",  &
       "[Simulation_init]")
end subroutine Simulation_init
