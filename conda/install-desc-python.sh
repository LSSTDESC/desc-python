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

DESC_PYTHON_INSTALL_DIR=$1


# Set up environment if running at NERSC
if [ "$NERSC_HOST" ]
then
  module unload cray-libsci
  module load cray-mpich-abi/8.1.30
  module list
fi

setup_conda() {
    source $DESC_PYTHON_INSTALL_DIR/etc/profile.d/conda.sh
    conda activate base
}

unset PYTHONPATH

export PYTHONNOUSERSITE=1
#export CONDA_CACHE_DIR=$1/pkgs
export CONDA_PKGS_DIRS=$1/pkgs

#
url="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
curl -LO "$url"

bash ./Miniforge-Linux-x86_64.sh -b -p $1
which python
setup_conda
mamba install -c conda-forge -y mpich=4.2.2=external_*
which python
which conda


python -m pip cache purge

if [[ -z "$2" ]]
then
  mamba install -c conda-forge -y --file ./conda-pack.txt
  pip download -d $1/pip-cache -r $3
  pip install --no-cache-dir -r ./pip-pack.txt


  git clone https://github.com/LSSTDESC/rail
  cd rail
  git checkout v1.2.3
  pip install .
  rail install --package-file rail_packages.yml

  cd $1
  # Add LSSTDESC/Delight
  git clone https://github.com/LSSTDESC/Delight.git
  cd Delight
  pip install .
  cd $1

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


