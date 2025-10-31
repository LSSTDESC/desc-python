#!/bin/bash

INST_DIR=/global/cfs/cdirs/lsst/groups/MCP
source $INST_DIR/setup-cosmology-dev.sh ""

if [ $# -gt 0 ] ; then
    exec python -m ipykernel $@
fi

