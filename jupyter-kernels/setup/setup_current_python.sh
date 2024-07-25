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
export LSST_PYTHON_VER=current


module load PrgEnv-gnu
module load cpu
module load cray-mpich-abi
module load texlive



unset PYTHONHOME
unset PYTHONPATH
export PYTHONNOUSERSITE=' '

export DESC_GCR_SITE='nersc'


#if [ -n "$DESCPYTHONUSERBASE" ]; then
#    export PYTHONUSERBASE=$DESCPYTHONUSERBASE	
#    unset PYTHONUSERSITE
#    echo "using DESCPYTHONUSERBASE: $DESCPYTHONUSERBASE"
#fi

source $LSST_INST_DIR/$LSST_PYTHON_VER/etc/profile.d/conda.sh
conda activate base
if [ -n "$DESCUSERENV" ]; then
   conda activate $DESCUSERENV
fi


# Set this after conda environment is setup
python_ver_major=$(python -c 'import sys; print(sys.version_info.major)')
python_ver_minor=$(python -c 'import sys; print(sys.version_info.minor)')
export DESCPYTHONVER="python$python_ver_major.$python_ver_minor"

if [ -n "$DESCPYTHONPATH" ]; then
    export PYTHONPATH=$PYTHONPATH:"$DESCPYTHONPATH"
    echo "Including user python path: $DESCPYTHONPATH"
fi 

export PYTHONPATH=$PYTHONPATH:$LSST_INST_DIR/$LSST_PYTHON_VER

if [ -n "$DESCPYTHONUSERBASE" ]; then
    export PYTHONUSERBASE=$DESCPYTHONUSERBASE	
    unset PYTHONUSERSITE
    export PATH=$PYTHONUSERBASE/bin:$PATH
    export PYTHONPATH="$PYTHONUSERBASE/lib/$DESCPYTHONVER/site-packages:$PYTHONPATH"
    echo "using DESCPYTHONUSERBASE: $DESCPYTHONUSERBASE"
fi

OUTPUTPY="$(which python)"
echo Now using "${OUTPUTPY}"

export HDF5_USE_FILE_LOCKING=FALSE
