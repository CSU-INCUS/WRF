#PBS -S /bin/csh
#PBS -V
#PBS -q smd_ops
#PBS -lselect=175:ncpus=28:mpiprocs=28:model=bro,walltime=60:00:00
#PBS -W group_list=s2841
#PBS -j oe
#PBS -o wrf_mpt_debug.log
#PBS -e wrf_error_debug.log
#PBS -N ARG1.2_WT_G3_DEBUG
#PBS -m be
#PBS -l site=needed=/nobackupp27
#PBS -r n

setenv MPI_TYPE_DEPTH 16
setenv MPI_LAUNCH_TIMEOUT 40
module load comp-intel/2020.4.304
module load mpi-hpe/mpt
#module load mpi-hpe/mpt.2.28_25Apr23_rhel87
setenv NETCDF /nobackup/jbukowsk/WRF_PNETCDF/LIBRARY/INSTALL
setenv HDF5 /nobackup/jbukowsk/WRF_PNETCDF/LIBRARY/INSTALL
setenv PHDF5 /nobackup/jbukowsk/WRF_PNETCDF/LIBRARY/INSTALL
setenv PNETCDF /nobackup/jbukowsk/WRF_PNETCDF/LIBRARY/INSTALL
setenv LD_LIBRARY_PATH $NETCDF/lib:$LD_LIBRARY_PATH
setenv PATH $NETCDF/bin:$PATH
setenv NETCDFPAR /nobackup/jbukowsk/WRF_PNETCDF/LIBRARY/INSTALL
set path = ($path /u/scicon/tools/bin)

several_tries mpiexec -np 4900 ./wrf.exe >& wrf.exe.out_ARG1.2_WT_G3_DEBUG
#mpiexec -np 2304 ./wrf.exe >& wrf.exe.out_PHI1.1_morr
