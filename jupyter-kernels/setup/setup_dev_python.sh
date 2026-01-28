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

export DESC_PYTHON_VER=dev

if [ "$NERSC_HOST" ]
then
  export DESC_INST_DIR=/global/common/software/lsst/common/miniconda

  module unload python
  module load PrgEnv-gnu
  module unload cray-libsci
  module load cray-mpich-abi
  module load texlive

  export DESC_GCR_SITE='nersc'
elif [[ $(hostname -d) == *"in2p3.fr"* ]]; then
  module load mpich
  export DESC_INST_DIR=/pbs/throng/lsst/software/desc/common/miniconda
  export PATH=$PATH:/pbs/throng/lsst/software/desc/bin
fi

unset PYTHONHOME
unset PYTHONPATH
export PYTHONNOUSERSITE=' '


source $DESC_INST_DIR/$DESC_PYTHON_VER/bin/activate
conda activate desc-python

if [ -n "$DESCUSERENV" ]; then
   conda activate $DESCUSERENV
fi

# COSMOSIS Setup
wrapcosmosis


if [ "$NERSC_HOST" ]
then
  # Fixes missing support in the Perlmutter libfabric:
  # https://docs.nersc.gov/development/languages/python/using-python-perlmutter/#missing-support-for-matched-proberecv
  export MPI4PY_RC_RECV_MPROBE=0

  # Tries to prevent cosmosis from launching any subprocesses, since that is
  # not allowed on Perlmutter.
  export COSMOSIS_NO_SUBPROCESS=1
  export HDF5_USE_FILE_LOCKING=FALSE
fi

if [ -n "$DESCPYTHONPATH" ]; then
    export PYTHONPATH=$PYTHONPATH:"$DESCPYTHONPATH"
    echo "Including user python path: $DESCPYTHONPATH"
fi 

export PYTHONPATH=$PYTHONPATH:$DESC_INST_DIR/$DESC_PYTHON_VER

# Set this after conda environment is setup
python_ver_major=$(python -c 'import sys; print(sys.version_info.major)')
python_ver_minor=$(python -c 'import sys; print(sys.version_info.minor)')
export DESCPYTHONVER="python$python_ver_major.$python_ver_minor"

if [ -n "$DESCPYTHONUSERBASE" ]; then
    export PYTHONUSERBASE=$DESCPYTHONUSERBASE
    unset PYTHONUSERSITE
    export PATH=$PYTHONUSERBASE/bin:$PATH
    export PYTHONPATH="$PYTHONUSERBASE/lib/$DESCPYTHONVER/site-packages:$PYTHONPATH"
    echo "using DESCPYTHONUSERBASE: $DESCPYTHONUSERBASE"
fi

export FIRECROWN_DIR=$CONDA_PREFIX/firecrown

OUTPUTPY="$(which python)"
echo Now using "${OUTPUTPY}"
