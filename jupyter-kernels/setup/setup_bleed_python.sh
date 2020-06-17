#!/bin/sh

export DESC_INST_DIR=/usr/local/
export DESC_PYTHON_VER=py3.7

export OMP_NUM_THREADS=1

unset PYTHONHOME
unset PYTHONPATH

unset PYTHONSTARTUP

export PYTHONNOUSERSITE=' '

export DESC_GCR_SITE='nersc'

source $DESC_INST_DIR/$DESC_PYTHON_VER/etc/profile.d/conda.sh
conda activate desc
if [ -n "$DESCUSERENV" ]; then
   conda activate $DESCUSERENV
fi

export HDF5_USE_FILE_LOCKING=FALSE

if [ $# -gt 0 ] ; then
    exec python -m ipykernel $@
fi
