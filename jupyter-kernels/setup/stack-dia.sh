#!/bin/sh

source /opt/lsst/software/stack/loadLSST.bash ""
setup lsst_distrib
setup lsst_sims
setup -r /global/common/software/lsst/cori-haswell-gcc/stack/dia/obs_lsst -j
export OMP_NUM_THREADS=1

unset PYTHONSTARTUP

export PYTHONNOUSERSITE=' '

if [ -n "$DESCPYTHONPATH" ]; then
    export PYTHONPATH="$DESCPYTHONPATH:$PYTHONPATH"
    echo "Including user python path: $DESCPYTHONPATH"
fi

export PYTHONPATH=".:$PYTHONPATH"

if [ $# -gt 0 ] ; then
    exec python -m ipykernel $@
fi
