#!/bin/bash

INST_DIR=/global/cfs/cdirs/lsst/groups/TD
source $INST_DIR/setup_td.sh -k

if [ $# -gt 0 ] ; then
    exec python -m ipykernel $@
fi

