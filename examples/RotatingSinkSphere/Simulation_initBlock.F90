subroutine Simulation_initBlock(blockID)

#include "constants.h"
#include "Flash.h"
#include "Eos.h"

  use Simulation_data, ONLY:   sim_smallX, sim_gamma, sim_smallP,fattening_factor,beta_param,xmin,xmax
  use Grid_interface, ONLY : Grid_getBlkIndexLimits, &
    Grid_getCellCoords, Grid_putPointData
  use Eos_interface, ONLY : Eos, Eos_wrapped

  implicit none

  ! compute the maximum length of a vector in each coordinate direction 
  ! (including guardcells)
  
  integer, intent(in) :: blockID
  

  integer :: i, j, k, n,io
  integer :: iMax, jMax, kMax
  real :: xx, yy,  zz, xxL, xxR
  
  real,allocatable, dimension(:) ::xCenter,xLeft,xRight,yCoord,zCoord

  integer, dimension(2,MDIM) :: blkLimits, blkLimitsGC
  integer :: sizeX,sizeY,sizeZ
  integer, dimension(MDIM) :: axis

  
  real :: rhoZone, velxZone, velyZone, velzZone, presZone, & 
       eintZone, enerZone, ekinZone, gameZone, gamcZone
  
  real rmax, rho_c,xl,xr,xc,yl,yr,yc,zr,zl,zc,rr,dr,rc,rho0,rho1,rc0,rc1,rho_out,P_out,rho_edge,center
  real vx,vy,vz,phi,theta,omega
  real, dimension(3000,1) :: dens_arr
  
  logical :: gcell = .true.

  ! character (len=255) :: cwd  
  ! get the integer index information for the current block
  call Grid_getBlkIndexLimits(blockId,blkLimits,blkLimitsGC)
  
  sizeX = blkLimitsGC(HIGH,IAXIS)
  sizeY = blkLimitsGC(HIGH,JAXIS)
  sizeZ = blkLimitsGC(HIGH,KAXIS)
  allocate(xLeft(sizeX))
  allocate(xRight(sizeX))
  allocate(xCenter(sizeX))
  allocate(yCoord(sizeY))
  allocate(zCoord(sizeZ))
  xCenter = 0.0
  xLeft = 0.0
  xRight = 0.0
  yCoord = 0.0
  zCoord = 0.0

  if (NDIM == 3) call Grid_getCellCoords&
                      (KAXIS, blockId, CENTER,gcell, zCoord, sizeZ)
  if (NDIM >= 2) call Grid_getCellCoords&
                      (JAXIS, blockId, CENTER,gcell, yCoord, sizeY)

  call Grid_getCellCoords(IAXIS, blockId, LEFT_EDGE, gcell, xLeft, sizeX)
  call Grid_getCellCoords(IAXIS, blockId, CENTER, gcell, xCenter, sizeX)
  call Grid_getCellCoords(IAXIS, blockId, RIGHT_EDGE, gcell, xRight, sizeX)

  !Read in data from Lane Emden Numerical Integration result
  ! reading file from the location ./flash4 starts up which in our case is  FLASH4.3/object
  open(12,file="../density.txt")
  read(12,*,IOSTAT=io) dens_arr
  close(12)
!------------------------------------------------------------------------------
  rho_c = 1.1E-19 
  rmax=16.90 !dimensionless xi units 
  dr=0.01 !delta xi used to initialize np.arange for the numerical integration
  rho_edge =  rho_c*dens_arr(int(rmax*100),1)
!  print *,"rho_edge: ", rho_edge
  center = abs(xmin-xmax)/2.
  rho_out = 1e6*rho_edge
  P_out = fattening_factor*rho_edge*8.254E8
!  print *,"P_out:",P_out
  omega = sqrt(2.2196e-25*beta_param) !Computed from 3*G*M/(rmax/1.057e-17)**3
  do k = blkLimits(LOW,KAXIS),blkLimits(HIGH,KAXIS)
     ! get the coordinates of the cell center in the z-direction
     zz = zCoord(k)-center
     do j = blkLimits(LOW,JAXIS),blkLimits(HIGH,JAXIS)
        ! get the coordinates of the cell center in the y-direction
        yy = yCoord(j)-center
        do i = blkLimits(LOW,IAXIS),blkLimits(HIGH,IAXIS)
           ! get the cell center, left, and right positions in x
           xx  = xCenter(i)-center
           rr = sqrt(xx**2 + yy**2 + zz**2)
           phi =  atan(yy/xx)
  !         print *, phi
           rc=rr*1.057E-17
           if (rc <= rmax) then
               rc0 = int(rc/dr)+1 !to prevent from hitting index 0 which is yields zero density
               rho0 =  rho_c*dens_arr(rc0,1)
               rho1 = rho_c*dens_arr(rc0+1,1)
               rc0 = rc0*dr
               rc1 = rc0+dr
               rhoZone = fattening_factor*(rho0+(rho1-rho0)*(rc-rc0)/(rc1-rc0) )!linear interpolation
           else
               rhoZone =  fattening_factor*rho_out!7.9856E-27 !rho_edge*10^-6
           endif
           velxZone = abs(omega*rr*sin(phi))
           velyZone = abs(omega*rr*cos(phi))

           if (xx<0) then
               velyZone=-velyZone
           endif
           if (yy>0) then
               velxZone=-velxZone
           endif
!           print *,xx,yy,phi,velxZone,velyZone
           if (rc >=18.719) then
               !velxZone = velxZone*exp(-((rc-18.719)/9.35)**2)
               !velyZone = velyZone*exp(-((rc-18.719)/9.35)**2)
               velxZone = velxZone*exp(-(rc-18.719)/9.35)
               velyZone = velyZone*exp(-(rc-18.719)/9.35)
           endif
           !if (velxZone <= 1.E-18) then 
           !   velxZone = 0 
           !endif 

           velzZone = 0.0
           !print *,omega
 !          print *,"vy: ",velyZone
           !Pressure 
           IF (rc .LE. rmax) THEN     
                presZone=rhoZone*8.254E8  !ideal gas law (T=10K inside)
           ELSE
                presZone=P_out !ideal gas law (T=10^7K outside)
           END IF           
           axis(IAXIS) = i
           axis(JAXIS) = j
           axis(KAXIS) = k

           ! Compute the gas energy and set the gamma-values needed for the equation of 
           ! state.
           ekinZone = 0.5 * (velxZone**2 + velyZone**2 + velzZone**2)
           eintZone = presZone / (sim_gamma-1.)
           eintZone = eintZone / rhoZone
           gameZone = sim_gamma
           gamcZone = sim_gamma
           enerZone = eintZone + ekinZone
           enerZone = max(enerZone, sim_smallP)

           ! store the variables in the current zone via Grid put methods
           ! data is put stored one cell at a time with these calls to Grid_putData           
           call Grid_putPointData(blockId, CENTER, DENS_VAR, EXTERIOR, axis, rhoZone)
           call Grid_putPointData(blockId, CENTER, PRES_VAR, EXTERIOR, axis, presZone)
           call Grid_putPointData(blockId, CENTER, VELX_VAR, EXTERIOR, axis, velxZone)
           call Grid_putPointData(blockId, CENTER, VELY_VAR, EXTERIOR, axis, velyZone)
           call Grid_putPointData(blockId, CENTER, VELZ_VAR, EXTERIOR, axis, velzZone)

#ifdef ENER_VAR
           call Grid_putPointData(blockId, CENTER, ENER_VAR, EXTERIOR, axis, enerZone)   
#endif
#ifdef EINT_VAR
           call Grid_putPointData(blockId, CENTER, EINT_VAR, EXTERIOR, axis, eintZone)   
#endif
#ifdef GAME_VAR          
           call Grid_putPointData(blockId, CENTER, GAME_VAR, EXTERIOR, axis, gameZone)
#endif
#ifdef GAMC_VAR
           call Grid_putPointData(blockId, CENTER, GAMC_VAR, EXTERIOR, axis, gamcZone)
#endif
#ifdef TEMP_VAR
# ifdef SIMULATION_TWO_MATERIALS
           call Grid_putPointData(blockId, CENTER, TEMP_VAR, EXTERIOR, axis, eosData(EOS_TEMP))
# else
           call Grid_putPointData(blockId, CENTER, TEMP_VAR, EXTERIOR, axis, 1.e-10)
# endif
#endif
        enddo
     enddo
  enddo

  deallocate(xLeft)
  deallocate(xRight)
  deallocate(xCenter)
  deallocate(yCoord)
  deallocate(zCoord)
  return
end subroutine Simulation_initBlock

