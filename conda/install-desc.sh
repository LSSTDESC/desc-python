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

# Try Miniforge latest
url="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
#url="$url/Miniforge-Linux-x86_64.sh"
curl -LO "$url"

echo "fresh install from miniforge"

bash ./Miniforge3-Linux-x86_64.sh -b -p $1
which python
#export PATH=$1/bin:$PATH
echo $DESC_PYTHON_INSTALL_DIR
#source $1/etc/profile.d/conda.sh
#conda activate base
setup_conda
export CONDA_PKGS_DIRS=$DESC_PYTHON_INSTALL_DIR/pkgs
#echo "installing mpich external"
#mamba install -c conda-forge -y mpich=4.2.2.*=external_*
which python
which conda
echo "before install"
#conda create -c conda-forge --name download_env --file $2 --download-only
mamba install -c conda-forge -y --file $2
#echo "after download"
#conda create --name desc --use-local --file $2
#conda activate desc

echo "going to pip install"
# Install jupyterlab at CC
if [[ -z $4 ]]
then	
  mamba install -c conda-forge -y jupyterlab
fi

pip download -d $DESC_PYTHON_INSTALL_DIR/pip-cache -r $3
# pip install --no-index --find-links $DESC_PYTHON_INSTALL_DIR/pip-cache -r $3  HMK doesn't work due to ceci
pip install --no-cache-dir -r $3 

#mamba env update -n desc --file $2 
#mamba env create -n desc -f $2
cd $DESC_PYTHON_INSTALL_DIR
#wget https://github.com/LSSTDESC/rail/archive/refs/tags/v1.0.0.tar.gz 
#tar xzf v1.0.0.tar.gz 
#rm v1.0.0.tar.gz 
git clone https://github.com/LSSTDESC/rail
cd rail 
git checkout v1.2.3
pip install . 
rail install --package-file rail_packages.yml 

cd $DESC_PYTHON_INSTALL_DIR
# Add LSSTDESC/Delight
git clone https://github.com/LSSTDESC/Delight.git
cd Delight
pip install .
cd $DESC_PYTHON_INSTALL_DIR

conda env export --no-builds > $DESC_PYTHON_INSTALL_DIR/desc-python-bleed-nobuildinfo.yml
conda env export > $DESC_PYTHON_INSTALL_DIR/desc-python-bleed.yml
conda list --explicit > $DESC_PYTHON_INSTALL_DIR/desc-python-bleed-explicit.wget
conda clean -y -a
cd $DESC_PYTHON_INSTALL_DIR
mkdir pkgs2
cd pkgs2
wget -i ../desc-python-bleed-explicit.wget
cd $DESC_PYTHON_INSTALL_DIR
awk -F '/' '/^http/ {print "/opt/desc/py/pkgs2/"$NF; next} {print} ' desc-python-bleed-explicit.wget > desc-python-bleed-local.yaml


# HMK then we can recreate the environment elsewhere
# conda create -n my_env --file desc-python-bleed-local.yaml --offline
# pip install --no-index --find-links $DESC_PYTHON_INSTALL_DIR/pip-cache -r $3  (remove ceci from requirements file)
# pip install ceci
# install RAIL and Delight from the source code cloned above

# conda clean -y -a # HMK Shouldn't clean if I'm trying to use the cache to rebuild the environment on another machine 



