#!/bin/bash

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
export LSST_PYTHON_VER=gpu

module load PrgEnv-gnu
module load gpu
#  module load cpu
#  module load cudatoolkit
#  module load cray-mpich-abi/8.1.24


unset PYTHONHOME
unset PYTHONPATH
export PYTHONNOUSERSITE=' '

export DESC_GCR_SITE='nersc'

source $LSST_INST_DIR/$LSST_PYTHON_VER/etc/profile.d/conda.sh
conda activate base
if [ -n "$DESCUSERENV" ]; then
   conda activate $DESCUSERENV
fi

if [ -n "$DESCPYTHONPATH" ]; then
    export PYTHONPATH=$PYTHONPATH:"$DESCPYTHONPATH"
    echo "Including user python path: $DESCPYTHONPATH"
fi 

export PYTHONPATH=$PYTHONPATH:$LSST_INST_DIR/$LSST_PYTHON_VER

OUTPUTPY="$(which python)"
echo Now using "${OUTPUTPY}"

export HDF5_USE_FILE_LOCKING=FALSE


