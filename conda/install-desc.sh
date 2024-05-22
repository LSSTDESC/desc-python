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

DESC_PYTHON_INSTALL_DIR=$1

setup_conda() {
  source $DESC_PYTHON_INSTALL_DIR/etc/profile.d/conda.sh
  conda activate base
}

unset PYTHONPATH

# Try Mambaforge latest
url="https://github.com/conda-forge/miniforge/releases/latest/download"
url="$url/Mambaforge-Linux-x86_64.sh"
curl -LO "$url"

bash ./Mambaforge-Linux-x86_64.sh -b -p $1
which python
#export PATH=$1/bin:$PATH
echo $DESC_PYTHON_INSTALL_DIR
#source $1/etc/profile.d/conda.sh
#conda activate base
setup_conda
#conda create --name desc -y
#conda activate desc
#conda install -c conda-forge -y "mamba>=0.22.1"
mamba install -c conda-forge -y mpich=4.1.2.*=external_*
which python
which conda
#mamba install -c conda-forge -y --file $2
mamba install -c conda-forge -y --file $2
pip install --no-cache-dir -r $3 
#mamba env update -n desc --file $2 
#mamba env create -n desc -f $2

wget https://github.com/LSSTDESC/rail/archive/refs/tags/v1.0.0.tar.gz 
tar xzf v1.0.0.tar.gz 
rm v1.0.0.tar.gz 
cd rail-1.0.0 
pip install . 
rail install --package-file rail_packages.yml 

conda clean -y -a 

# Install jupyterlab at CC
if [[ -z $4 ]]
then	
  pip install jupyterlab
fi



