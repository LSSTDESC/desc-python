#!/bin/sh
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

module unload python
module swap PrgEnv-intel PrgEnv-gnu
module swap gcc gcc/6.3.0
module rm craype-network-aries
module rm cray-libsci
module unload craype
export CC=gcc

unset PYTHONHOME
unset PYTHONPATH
export PYTHONNOUSERSITE=' '

if [ -n "$DESCPYTHONPATH" ]; then
    export PYTHONPATH="$DESCPYTHONPATH"
    echo "Including user python path: $DESCPYTHONPATH"
fi 

export PATH=$LSST_INST_DIR/$LSST_PYTHON_VER/bin:$PATH
source activate stack
echo Now using $LSST_INST_DIR/$LSST_PYTHON_VER
