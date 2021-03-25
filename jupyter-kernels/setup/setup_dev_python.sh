#!/bin/sh

unset PYTHONHOME
unset PYTHONPATH

source /usr/local/py3.8/etc/profile.d/conda.sh ""
#export OMP_NUM_THREADS=1

unset PYTHONSTARTUP

export PYTHONNOUSERSITE=' '

export DESC_GCR_SITE='nersc'

conda activate desc

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


export PYTHONPATH=".:$PYTHONPATH"

OUTPUTPY="$(which python)"
echo Now using "${OUTPUTPY}"

export HDF5_USE_FILE_LOCKING=FALSE

if [ $# -gt 0 ] ; then
    exec python -m ipykernel $@
fi
