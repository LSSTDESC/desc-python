#!/bin/bash

source /opt/lsst/software/stack/loadLSST.bash ""
setup lsst_distrib


export OMP_NUM_THREADS=1

unset PYTHONSTARTUP

export PYTHONNOUSERSITE=' '

export DESC_GCR_SITE='nersc'

export RUBIN_SIM_DATA_DIR=/global/cfs/cdirs/lsst/groups/CO/rubin_sim

if [ -n "$DESCPYTHONPATH" ]; then
    export PYTHONPATH="$DESCPYTHONPATH:$PYTHONPATH"
    echo "Including DESCPYTHONPATH: $DESCPYTHONPATH"
    echo "Wondering Why? DESCPYTHONPATH is likely set in your $HOME/.basrhc, $HOME/.bashrc.ext, or similar config script"
fi


python_ver_major=$(python -c 'import sys; print(sys.version_info.major)')
python_ver_minor=$(python -c 'import sys; print(sys.version_info.minor)')
export DESCPYTHONVER="python$python_ver_major.$python_ver_minor"

#export PYTHONPATH=$PYTHONPATH:$LSST_INST_DIR/$LSST_PYTHON_VER

if [ -n "$DESCWLSHEARSIMSUSERBASE" ]; then
    export PYTHONUSERBASE=$DESCWLSHEARSIMSUSERBASE
    unset PYTHONUSERSITE
    unset PYTHONNOUSERSITE
    export PATH=$PYTHONUSERBASE/bin:$PATH       
    export PYTHONPATH="$PYTHONUSERBASE/lib/$DESCPYTHONVER/site-packages:$PYTHONPATH"
    echo "using DESCWLSHEARSIMSUSERBASE: $DESCWLSHEARSIMSUSERBASE"
fi


export PYTHONPATH=".:$PYTHONPATH"

if [ $# -gt 0 ] ; then
    exec python -m ipykernel $@
fi
