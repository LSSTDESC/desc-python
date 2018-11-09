#!/bin/sh

source /opt/lsst/software/stack/loadLSST.bash
setup lsst_distrib
setup -r /opt/lsst/software/stack/obs_lsstCam
setup lsst_sims
export OMP_NUM_THREADS=1
mypy=$(which python)" -m ipykernel $@"
eval $mypy
#/opt/lsst/software/stack/python/miniconda3-4.5.4/envs/lsst-scipipe-10a4fa6/bin/python -m ipykernel $@

