#!/bin/bash

export STACKCVMFS=/cvmfs/sw.lsst.eu/linux-x86_64/lsst_sims
export LSST_STACK_VERSION=sims_2_13_1

module load pe_archive
module unload python
module swap PrgEnv-intel PrgEnv-gnu
module swap gcc gcc/6.3.0
module rm craype-network-aries
module rm cray-libsci
module unload craype
export CC=gcc

source $STACKCVMFS/$LSST_STACK_VERSION/loadLSST.bash
setup lsst_sims

export OMP_NUM_THREADS=1

export PYTHONNOUSERSITE=' '

if [ -n "$DESCPYTHONPATH" ]; then
    export PYTHONPATH="$DESCPYTHONPATH:$PYTHONPATH"
    echo "Including user python path: $DESCPYTHONPATH"
fi

export PYTHONPATH=".:$PYTHONPATH"

if [ $# -gt 0 ] ; then
    exec python -m ipykernel $@
fi


