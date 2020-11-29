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

curl -LO https://repo.anaconda.com/miniconda/Miniconda3-4.7.12.1-Linux-x86_64.sh

bash ./Miniconda3-4.7.12.1-Linux-x86_64.sh -b -p $1
which python
#export PATH=$1/bin:$PATH
source $1/etc/profile.d/conda.sh
conda activate base
which python
conda env create -n desc -f $2
conda activate desc

# May no longer be required due to recent 0.4.0 release of fast3tree
# Finish installing fast3tree by forcing the creation of its library
#echo -e "from fast3tree.make_lib import make_lib\nmake_lib(3, True)\nmake_lib(3, False)\nmake_lib(2, True)\nmake_lib(2, False)" >> ./install_fast3tree.py
#python ./install_fast3tree.py
#rm ./install_fast3tree.py

# Install jupyterlab at CC
if [[ -z $3 ]]
then	
  pip install jupyterlab
fi



