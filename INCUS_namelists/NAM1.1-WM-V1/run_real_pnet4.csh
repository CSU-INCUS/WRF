#PBS -S /bin/csh
#PBS -V
#PBS -q smd_ops
#PBS -lselect=3:ncpus=128:mpiprocs=128:model=rom_ait,walltime=2:00:00
#PBS -W group_list=s2841
#PBS -j oe
#PBS -o real_mpt.log
#PBS -e real_error.log
#PBS -N REAL_NAM1.1_WM
#PBS -m be
#PBS -r n
#PBS -l site=needed=/nobackupp27

setenv MPI_LAUNCH_TIMEOUT 60
setenv MPI_TYPE_DEPTH 16
module load comp-intel/2020.4.304
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

several_tries mpiexec -np 384 ./real.exe >& out.real

