!!****if* source/Simulation/SimulationMain/Sod/Simulation_init

subroutine Simulation_init()
  
  use Simulation_data
  use Driver_interface, ONLY : Driver_getMype, Driver_abortFlash
  use RuntimeParameters_interface, ONLY : RuntimeParameters_get
  use Logfile_interface, ONLY : Logfile_stamp
  use Multispecies_interface, ONLY : Multispecies_setProperty
  implicit none
#include "constants.h"
#include "Flash.h"
#include "Multispecies.h"

  
  call Driver_getMype(MESH_COMM, sim_meshMe)


  call RuntimeParameters_get('smallp', sim_smallP)
  call RuntimeParameters_get('smallx', sim_smallX) 
  call RuntimeParameters_get('fattening_factor',fattening_factor ) 
  call RuntimeParameters_get('gamma', sim_gamma)
  
  call RuntimeParameters_get('sim_rhoLeft', sim_rhoLeft)
  call RuntimeParameters_get('sim_rhoRight', sim_rhoRight)
  
  call RuntimeParameters_get('sim_pLeft', sim_pLeft)
  call RuntimeParameters_get('sim_pRight', sim_pRight)
  
  call RuntimeParameters_get('sim_uLeft', sim_uLeft)
  call RuntimeParameters_get('sim_uRight', sim_uRight)
  
  call RuntimeParameters_get('sim_xangle', sim_xAngle)
  call RuntimeParameters_get('sim_yangle', sim_yAngle)
  
  call RuntimeParameters_get('sim_posn', sim_posn)

#ifdef SIMULATION_TWO_MATERIALS
  call RuntimeParameters_get('sim_abarLeft', sim_abarLeft)
  call RuntimeParameters_get('sim_zbarLeft', sim_zbarLeft)
  call RuntimeParameters_get('sim_abarRight', sim_abarRight)
  call RuntimeParameters_get('sim_zbarRight', sim_zbarRight)
#endif

  call Logfile_stamp( "initializing Sod problem",  &
       "[Simulation_init]")
     
#ifdef SIMULATION_TWO_MATERIALS
  call Multispecies_setProperty(LEFT_SPEC, A, sim_abarLeft)
  call Multispecies_setProperty(LEFT_SPEC, Z, sim_zbarLeft)
  call Multispecies_setProperty(RGHT_SPEC, A, sim_abarRight)
  call Multispecies_setProperty(RGHT_SPEC, Z, sim_zbarRight)
#endif

#ifdef FLASH_3T
  call RuntimeParameters_get('sim_pionLeft' , sim_pionLeft )
  call RuntimeParameters_get('sim_pionRight', sim_pionRight)
  call RuntimeParameters_get('sim_peleLeft' , sim_peleLeft )
  call RuntimeParameters_get('sim_peleRight', sim_peleRight)
  call RuntimeParameters_get('sim_pradLeft' , sim_pradLeft )
  call RuntimeParameters_get('sim_pradRight', sim_pradRight)

  if (sim_pionLeft  < 0.0) call Driver_abortFlash("Must specify sim_pionLeft" )
  if (sim_pionRight < 0.0) call Driver_abortFlash("Must specify sim_pionRight")
  if (sim_peleLeft  < 0.0) call Driver_abortFlash("Must specify sim_peleLeft" )
  if (sim_peleRight < 0.0) call Driver_abortFlash("Must specify sim_peleRight")
  if (sim_pradLeft  < 0.0) call Driver_abortFlash("Must specify sim_pradLeft" )
  if (sim_pradRight < 0.0) call Driver_abortFlash("Must specify sim_pradRight")
#endif

  ! convert the shock angle paramters
  sim_xAngle = sim_xAngle * 0.0174532925 ! Convert to radians.
  sim_yAngle = sim_yAngle * 0.0174532925

  sim_xCos = cos(sim_xAngle)
  
  if (NDIM == 1) then
     sim_xCos = 1.
     sim_yCos = 0.
     sim_zCos = 0.
     
  elseif (NDIM == 2) then
     sim_yCos = sqrt(1. - sim_xCos*sim_xCos)
     sim_zCos = 0.
     
  elseif (NDIM == 3) then
     sim_yCos = cos(sim_yAngle)
     sim_zCos = sqrt( max(0., 1. - sim_xCos*sim_xCos - sim_yCos*sim_yCos) )
  endif
end subroutine Simulation_init
