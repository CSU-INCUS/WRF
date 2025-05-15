#PBS -S /bin/csh
#PBS -V
#PBS -q smd_ops
#PBS -lselect=150:ncpus=28:mpiprocs=28:model=bro,walltime=60:00:00
#PBS -W group_list=s2841
#PBS -j oe
#PBS -o wrf_mpt_g3_30s_init.log
#PBS -e wrf_error_g3_30s_init.log
#PBS -N ARG1.1_WT_G3_30s_INIT 
#PBS -m be
#PBS -r n

setenv MPI_TYPE_DEPTH 16
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

mpiexec -np 4200 ./wrf.exe >& wrf.exe.out_ARG1.1_WT_G3_30s_INIT


