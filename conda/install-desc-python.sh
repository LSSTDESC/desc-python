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


# Set up environment if running at NERSC
if [ "$NERSC_HOST" ]
then
  if [ "$NERSC_HOST" == "cori" ]
  then
    module unload python
    module swap PrgEnv-intel PrgEnv-gnu
    module unload cray-libsci
    module unload cray-mpich
    module load cray-mpich-abi/7.7.19
    export LD_LIBRARY_PATH=$CRAY_MPICH_BASEDIR/mpich-gnu-abi/8.2/lib:$LD_LIBRARY_PATH
  else
    module unload cray-libsci
    module load cray-mpich-abi/8.1.15
  fi
  module list
fi


unset PYTHONPATH

#curl -LO https://repo.anaconda.com/miniconda/Miniconda3-py38_4.9.2-Linux-x86_64.sh
#bash ./Miniconda3-py38_4.9.2-Linux-x86_64.sh -b -p $1

# Try Mambaforge latest
url="https://github.com/conda-forge/miniforge/releases/latest/download"
url="$url/Mambaforge-Linux-x86_64.sh"
curl -LO "$url"

bash ./Mambaforge-Linux-x86_64.sh -b -p $1
which python
source $1/etc/profile.d/conda.sh
conda activate base
#conda install -c conda-forge -y mamba
mamba install -c conda-forge -y mpich=3.4.*=external_*
which python
which conda

if [[ -z "$2" ]]
then
  mamba install -c conda-forge -y --file ./conda-pack.txt
  pip install --no-cache-dir -r ./pip-pack.txt
else
  mamba env update -n base -f $2
fi

conda clean -y -a 
python -m compileall $1

# Install jupyterlab at CC
if [[ -z "$NERSC_HOST" ]]
then	
  pip install jupyterlab
fi

conda env export --no-builds > $1/desc-python-nobuildinfo.yml
conda env export > $1/desc-python.yml


# Set permissions if running at NERSC
if [ "$NERSC_HOST" ]
then
  setfacl -R -m group::rx $1
  setfacl -R -d -m group::rx $1

  setfacl -R -m user:desc:rwx $1
  setfacl -R -d -m user:desc:rwx $1
  cp ./sitecustomize.py $1
fi


