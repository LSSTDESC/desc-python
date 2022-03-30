#!/bin/bash

#INST_DIR=/global/common/software/lsst/cori-haswell-gcc/stack/td_env-prod/55219
#source $INST_DIR/setup_td_env.sh ""
INST_DIR=/global/cfs/cdirs/lsst/groups/TD
source $INST_DIR/setup_td_dev.sh -k

if [ $# -gt 0 ] ; then
    exec python -m ipykernel $@
fi

