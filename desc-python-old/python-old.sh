#!/bin/bash

INST_DIR=/global/common/software/lsst/common/miniconda
source $INST_DIR/setup_old_python.sh ""

if [ $# -gt 0 ] ; then
    exec python -m ipykernel $@
fi
