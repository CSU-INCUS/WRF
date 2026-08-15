#PBS -S /bin/csh
#PBS -V
#PBS -q smd_ops
#PBS -lselect=110:ncpus=28:mpiprocs=28:model=bro_ele
#PBS -l site=static_broadwell
#PBS -l walltime=96:00:00
#PBS -W group_list=s2841
#PBS -j oe
#PBS -o wrf_mpt_init.log
#PBS -e wrf_error_init.log
#PBS -N NAM1.1_WM_G1_END5
#PBS -m be
#PBS -r n
#PBS -l site=needed=/nobackupp27

setenv MPI_TYPE_DEPTH 16
setenv MPI_LAUNCH_TIMEOUT 90
module load comp-intel/2020.4.304
#module load mpi-hpe/mpt
module load mpi-hpe/mpt.2.28_25Apr23_rhel87
setenv NETCDF /nobackup/jbukowsk/WRF_PNETCDF/LIBRARY/INSTALL
setenv HDF5 /nobackup/jbukowsk/WRF_PNETCDF/LIBRARY/INSTALL
setenv PHDF5 /nobackup/jbukowsk/WRF_PNETCDF/LIBRARY/INSTALL
setenv PNETCDF /nobackup/jbukowsk/WRF_PNETCDF/LIBRARY/INSTALL
setenv LD_LIBRARY_PATH $NETCDF/lib:$LD_LIBRARY_PATH
setenv PATH $NETCDF/bin:$PATH
setenv NETCDFPAR /nobackup/jbukowsk/WRF_PNETCDF/LIBRARY/INSTALL

setenv MPI_LAUNCH_TIMEOUT 40
set path = ($path /u/scicon/tools/bin)

several_tries mpiexec -np 3080 ./wrf.exe >& wrf.exe.out_NAM1.1_WM-G1_END5
#mpiexec -np 2304 ./wrf.exe >& wrf.exe.out_PHI2.1-morr-init
