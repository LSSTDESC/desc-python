#!/bin/bash

INST_DIR=/global/common/software/lsst/common/miniconda
source $INST_DIR/setup_current_python.sh ""

exec python -m ipykernel $@
