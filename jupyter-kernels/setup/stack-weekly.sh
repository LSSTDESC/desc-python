#!/bin/bash

source /opt/lsst/software/stack/loadLSST.bash ""
setup lsst_distrib
[ -d "$LSST_HOME/obs_lsst" ] && setup -r $LSST_HOME/obs_lsst
[ -d "$LSST_HOME/supreme" ] && setup -r $LSST_HOME/supreme -j
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

if [ -n "$DESCSTACKUSERENV" ]; then
   conda activate $DESCSTACKUSERENV
   echo "Activated your DESCSTACKUSERENV: $DESCSTACKUSERENV"
    echo "Wondering Why? DESCSTACKUSERENV is likely set in your $HOME/.basrhc, $HOME/.bashrc.ext, or similar config script"
fi

python_ver_major=$(python -c 'import sys; print(sys.version_info.major)')
python_ver_minor=$(python -c 'import sys; print(sys.version_info.minor)')
export DESCPYTHONVER="python$python_ver_major.$python_ver_minor"

export PYTHONPATH=$PYTHONPATH:$LSST_INST_DIR/$LSST_PYTHON_VER

if [ -n "$DESCSTACKUSERBASE" ]; then
    export PYTHONUSERBASE=$DESCSTACKUSERBASE
    unset PYTHONUSERSITE
    export PATH=$PYTHONUSERBASE/bin:$PATH       
    export PYTHONPATH="$PYTHONUSERBASE/lib/$DESCPYTHONVER/site-packages:$PYTHONPATH"
    echo "using DESCPYTHONUSERBASE: $DESCSTACKUSERBASE"
fi


export PYTHONPATH=".:$PYTHONPATH"

if [ $# -gt 0 ] ; then
    exec python -m ipykernel $@
fi
