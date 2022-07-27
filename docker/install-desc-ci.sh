#!/bin/bash

## To Run a fresh install
## bash install-desc-python.sh <pathToCondaInstall> 

## To Install using an input YAML file
## bash install-desc-python.sh <pathToCondaInstall> ./desc-python-env-nersc-install-nobuildinfo.yml

if [ -z "$1" ]
then	
	echo "Please provide a full path install directory"
	exit 1
fi


unset PYTHONPATH

curl -LO https://repo.anaconda.com/miniconda/$2

bash ./$2 -b -p $1
which python
source $1/etc/profile.d/conda.sh
conda activate base
conda install -c conda-forge -y mamba
mamba install -c conda-forge -y mpich=3.3.*=external_*
which python
which conda

if [[ -z "$3" ]]
then
  mamba install -c conda-forge -y --file ../conda/condalist.txt
  pip install --no-cache-dir -r ../conda/piplist.txt
else
  mamba env update -n base -f $3
fi

conda clean -y -a 
#python -m compileall $1

# Install jupyterlab at CC
if [[ -z "$NERSC_HOST" ]]
then	
  pip install jupyterlab
fi

conda env export --no-builds > $1/desc-python-nobuildinfo.yml
conda env export > $1/desc-python.yml

exit



