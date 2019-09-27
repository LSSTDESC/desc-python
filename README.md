# jupyter-kernels
Collection of DESC jupyter kernels for use with JupyterLab at NERSC

## Initial User setup
See: https://confluence.slac.stanford.edu/display/LSSTDESC/Using+Jupyter+at+NERSC (Confluence log-in required)

## Current Kernels
- desc-python:  Current DM version of python + DM python packages + DESC requested packages
- desc-python-dev
- desc-pyspark
- desc-stack: Current DM version of python with functional DMstack (lsst_distrib + lsst_sims) + DESC requested packages
- desc-stack-dev
- desc-stack-old: Previous production version of desc-stack

## List of Packages Included in the Environment
See: https://github.com/LSSTDESC/ComputingInfrastructure/wiki/NERSC-Python-Installation

## Dockerfiles used to generate the underlying Shifter Image for desc-stack
See: https://github.com/LSSTDESC/dockerfiles/blob/master/jupyter/Dockerfile-python-sims

## Dockerhub
See: https://hub.docker.com/r/lsstdesc/stack-jupyter/tags

## desc-stack Releases

### Current Run2.1i Shifter Image 
lsstdesc/stack-jupyter:prod

### Final Run1.2i Shifter Image 
lsstdesc/stack-jupyter:w_2018_39-sims_2_11_1-run1.2-v14

## desc-python Releases

### First Run2.1i python env 
`/global/common/software/lsst/common/miniconda/py3-4.5.12` 

Set up using `source /global/common/software/lsst/common/miniconda/setup_current_python.sh`

### Final Run1.2i python env 
`/global/common/software/lsst/common/miniconda/py3-4.5.4`

Set up using `source /global/common/software/lsst/common/miniconda/setup_old_python.sh`
