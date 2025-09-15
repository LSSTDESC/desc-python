#!/bin/bash

# Avoid passing parameters from this script to cosmosis
wrapcosmosis() {
    source cosmosis-configure
}


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
module load PrgEnv-gnu
module unload cray-libsci
module load cray-mpich-abi


unset PYTHONHOME
unset PYTHONPATH
export PYTHONNOUSERSITE=' '

export DESC_GCR_SITE='nersc'

#source $LSST_INST_DIR/$LSST_PYTHON_VER/etc/profile.d/conda.sh
#conda activate base

source $LSST_INST_DIR/$LSST_PYTHON_VER/bin/activate
conda activate desc

export FIRECROWN_DIR=$CONDA_PREFIX/firecrown
#
# Fixes missing support in the Perlmutter libfabric:
# https://docs.nersc.gov/development/languages/python/using-python-perlmutter/#missing-support-for-matched-proberecv
export MPI4PY_RC_RECV_MPROBE=0

# Tries to prevent cosmosis from launching any subprocesses, since that is
# not allowed on Perlmutter.
export COSMOSIS_NO_SUBPROCESS=1

if [ -n "$DESCUSERENV" ]; then
   conda activate $DESCUSERENV
fi

wrapcosmosis

if [ -n "$DESCPYTHONPATH" ]; then
    export PYTHONPATH=$PYTHONPATH:"$DESCPYTHONPATH"
    echo "Including user python path: $DESCPYTHONPATH"
fi 

export PYTHONPATH=$PYTHONPATH:$LSST_INST_DIR/$LSST_PYTHON_VER

OUTPUTPY="$(which python)"
echo Now using "${OUTPUTPY}"

export HDF5_USE_FILE_LOCKING=FALSE


