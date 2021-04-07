#!/bin/sh

## To Run at NERSC
## bash install-dev.sh <pathToExistingCondaInstall> ./desc-python-env-nersc-install-nobuildinfo.yml NERSC
## Note the inclusion of NERSC parameter skips the install of jupyterlab below

## To Run at other sites
## bash install-dev.sh <pathToExistingCondaInstall> ./desc-python-env-nersc-install-nobuildinfo.yml

if [ -z "$1" ]
then	
	echo "Please provide a full path install directory"
	exit 1
fi

unset PYTHONPATH

curl -LO https://repo.anaconda.com/miniconda/Miniconda3-py38_4.9.2-Linux-x86_64.sh

bash ./Miniconda3-py38_4.9.2-Linux-x86_64.sh -b -p $1
which python
#export PATH=$1/bin:$PATH
source $1/etc/profile.d/conda.sh
conda activate base
which python

conda env create -n desc -f $2

#source $1/etc/profile.d/conda.sh
conda activate desc

# Install jupyterlab at CC
if [[ -z $3 ]]
then	
  pip install jupyterlab
fi



