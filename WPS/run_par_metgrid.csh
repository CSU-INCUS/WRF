#PBS -S /bin/csh
#PBS -V
#PBS -q devel
#PBS -lselect=5:ncpus=28:mpiprocs=28:model=bro,walltime=02:00:00
#PBS -W group_list=s2841
#PBS -j oe
#PBS -o metgrid.out
#PBS -N metgrid.log
#PBS -m be
#PBS -r n

module load comp-intel/2020.4.304
#module load mpi-hpe/mpt
mpi-hpe/mpt.2.28_25Apr23_rhel87
module load szip/2.1.1
module load hdf4/4.2.12
module load hdf5/1.8.18_mpt
module load netcdf/4.4.1.1_mpt

mpiexec -np 140 ./metgrid.exe >& metgrid.exe.out


