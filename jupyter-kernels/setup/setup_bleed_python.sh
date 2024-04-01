#!/bin/bash

export DESC_INST_DIR=/opt/desc
export DESC_PYTHON_VER=py

export OMP_NUM_THREADS=1

unset PYTHONHOME
unset PYTHONPATH

unset PYTHONSTARTUP

export PYTHONNOUSERSITE=' '

export DESC_GCR_SITE='nersc'

source $DESC_INST_DIR/$DESC_PYTHON_VER/etc/profile.d/conda.sh
conda activate base
if [ -n "$DESCUSERENV" ]; then
   conda activate $DESCUSERENV
fi

python_ver_major=$(python -c 'import sys; print(sys.version_info.major)')
python_ver_minor=$(python -c 'import sys; print(sys.version_info.minor)')
export DESCPYTHONVER="python$python_ver_major.$python_ver_minor"

export PYTHONPATH=$PYTHONPATH:$LSST_INST_DIR/$LSST_PYTHON_VER

if [ -n "$DESCPYTHONBLEEDUSERBASE" ]; then
    export PYTHONUSERBASE=$DESCPYTHONBLEEDUSERBASE
    unset PYTHONUSERSITE
    export PYTHONPATH="$PYTHONUSERBASE/lib/$DESCPYTHONVER/site-packages:$PYTHONPATH"
    echo "using DESCPYTHONBLEEDUSERBASE: $DESCPYTHONBLEEDUSERBASE"
fi


export HDF5_USE_FILE_LOCKING=FALSE

if [ $# -gt 0 ] ; then
    exec python -m ipykernel $@
fi
