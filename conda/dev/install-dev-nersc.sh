#!/bin/sh


if [ -z "$1" ]
then	
	echo "Please provide a full path to the desc-python directory"
	exit 1
fi

if [ -z "$2" ]
then	
     export DESC_PYTHON_INSTALL_DIR=dev	
     echo $DESC_PYTHON_INSTALL_DIR
else
     export DESC_PYTHON_INSTALL_DIR=$2
fi

export LSST_INST_DIR=/global/common/software/lsst/common/miniconda

export DESC_PYTHON_PATH=$1
echo $DESC_PYTHON_INSTALL_DIR

module unload python
module swap PrgEnv-intel PrgEnv-gnu
module rm craype-network-aries
module rm cray-libsci
module unload craype
export CC=gcc

unset PYTHONHOME
unset PYTHONPATH
export PYTHONNOUSERSITE=' '

export DESC_GCR_SITE='nersc'

echo $DESC_PYTHON_INSTALL_DIR

source $DESC_PYTHON_PATH/conda/install-desc.sh $LSST_INST_DIR/$DESC_PYTHON_INSTALL_DIR $DESC_PYTHON_PATH/conda/dev/desc-dev-python-env-nersc-export.yml NERSC


