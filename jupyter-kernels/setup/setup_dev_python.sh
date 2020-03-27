#!/bin/sh
function log () {
    if [[ $_V -eq 1 ]]; then
        echo "$@"
    fi
}

_V=0
while getopts "v" OPTION
do
  case $OPTION in
    v) _V=1
       ;;
  esac
done

export LSST_INST_DIR=/global/common/software/lsst/common/miniconda
export LSST_PYTHON_VER=dev

module unload python
module swap PrgEnv-intel PrgEnv-gnu
module swap gcc gcc/8.3.0
module rm craype-network-aries
module rm cray-libsci
module unload craype
export CC=gcc

# NaMaster
#module load cfitsio/3.47
#module load cray-fftw/3.3.8.2


unset PYTHONHOME
unset PYTHONPATH
export PYTHONNOUSERSITE=' '

if [ -n "$DESCPYTHONPATH" ]; then
    export PYTHONPATH="$DESCPYTHONPATH"
    echo "Including user python path: $DESCPYTHONPATH"
fi 

#export PATH=$LSST_INST_DIR/$LSST_PYTHON_VER/bin:$PATH
source $LSST_INST_DIR/$LSST_PYTHON_VER/etc/profile.d/conda.sh
conda activate desc
echo Now using $LSST_INST_DIR/$LSST_PYTHON_VER/envs/desc

export HDF5_USE_FILE_LOCKING=FALSE

# NaMaster dependencies
#export LD_LIBRARY_PATH=$CFITSIO_DIR/lib:/global/common/software/lsst/common/miniconda/namaster-1.0/lib:$FFTW_DIR:$LD_LIBRARY_PATH
