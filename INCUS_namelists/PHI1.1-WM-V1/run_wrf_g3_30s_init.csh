#PBS -S /bin/csh
#PBS -V
#PBS -q smd_ops
#PBS -lselect=84:ncpus=28:mpiprocs=28:model=bro,walltime=60:00:00
#PBS -W group_list=s2841
#PBS -j oe
#PBS -o wrf_mpt_g3_30s_init.log
#PBS -e wrf_error_g3_30s_init.log
#PBS -N PHI1.1_WM_G3_30s_INIT
#PBS -m be
#PBS -r n

setenv MPI_TYPE_DEPTH 16
module load comp-intel/2020.4.304
module load mpi-hpe/mpt
setenv NETCDF /nobackup/jbukowsk/WRF_PNETCDF/LIBRARY/INSTALL
setenv HDF5 /nobackup/jbukowsk/WRF_PNETCDF/LIBRARY/INSTALL
setenv PHDF5 /nobackup/jbukowsk/WRF_PNETCDF/LIBRARY/INSTALL
setenv PNETCDF /nobackup/jbukowsk/WRF_PNETCDF/LIBRARY/INSTALL
setenv LD_LIBRARY_PATH $NETCDF/lib:$LD_LIBRARY_PATH
setenv PATH $NETCDF/bin:$PATH
setenv NETCDFPAR /nobackup/jbukowsk/WRF_PNETCDF/LIBRARY/INSTALL

mpiexec -np 2352 ./wrf.exe >& wrf.exe.out_PHI1.1_morr_g3_30s_init
#mpiexec -np 2304 ./wrf.exe >& wrf.exe.out_PHI1.1_morr
