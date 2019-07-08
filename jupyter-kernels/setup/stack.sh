#!/bin/sh

source /opt/lsst/software/stack/loadLSST.bash ""
setup lsst_distrib
setup -r /opt/lsst/software/stack/obs_lsst
setup lsst_sims
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
