#!/bin/bash

set -o pipefail
set -e

if [ -z "$1" ]
then
  echo "Please provide an installation directory"
  exit 1
fi

if [ -z "$2" ]
then
  export CONDA_LOCK_INSTALL_DIR=/pbs/throng/lsst/users/hkelly/installation/bin
else
  export CONDA_LOCK_INSTALL_DIR=$2
fi

if [ "$NERSC_HOST" ]
then
  module unload python
  #module swap PrgEnv-intel PrgEnv-gnu
  module unload cray-libsci
  module load cray-mpich-abi/8.1.30
else
  export PATH=$CONDA_LOCK_INSTALL_DIR:$PATH
fi

unset PYTHONPATH

setup_conda() {
    source $curBuildDir/py/etc/profile.d/conda.sh
}

config_cosmosis() {
   source ${CONDA_PREFIX}/bin/cosmosis-configure
}

export BUILD_ID_DATE=`echo "$(date "+%F-%M-%S")"`

curBuildDir=$1/$BUILD_ID_DATE
echo "Install Directory: " $curBuildDir

mkdir -p $curBuildDir
# Set permissions
chgrp lsst $curBuildDir
chmod g+rx $curBuildDir
if [ "$NERSC_HOST" ]
then
  setfacl -R -m user:desc:rwx $curBuildDir
  setfacl -R -d -m user:desc:rwx $curBuildDir
fi

if [ "$NERSC_HOST" ]
then
  cp conda/sitecustomize.py $curBuildDir
fi

cp conda/desc-py-lock.yml $curBuildDir
cp conda/pip.config $curBuildDir
cd $curBuildDir


# Build Steps
export PYTHONNOUSERSITE=1
export CONDA_PKGS_DIRS=$curBuildDir/pkgs

url="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
curl -LO "$url"

bash ./Miniforge3-Linux-x86_64.sh -b -p $curBuildDir/py
setup_conda
conda activate base

#python -m pip cache purge
#ret=`pip config get global.no-cache-dir; echo $?`
#if [ret -eq 1]
#if [`pip config get global.no-cache-dir; echo $?` -eq 1]
export PIP_CONFIG_FILE=$curBuildDir/pip.config
#if pip config get global.no-cache-dir >/dev/null 2>&1; then
#  DESC_PIPCACHEUNSET=1
#else
#  current_cache_flag=`pip config get global.no-cache-dir`
#fi

#pip config set global.no-cache-dir true
pip config -v list

conda-lock install --mamba -n desc-python desc-py-lock.yml

conda activate desc-python

conda env config vars set CSL_DIR=${CONDA_PREFIX}/cosmosis-standard-library
cd ${CONDA_PREFIX}
config_cosmosis
cosmosis-build-standard-library main
cd $curBuildDir

echo "Set up cosmosis"

echo "Cleaning"


conda clean -y -a 

#conda config --set env_prompt "(desc-py)" --env

cd $curBuildDir
echo "Setting up copy of firecrown"
firecrown_ver=$(conda list firecrown | grep firecrown|tr -s " " | cut -d " " -f 2)
echo $firecrown_ver
curl -LO https://github.com/LSSTDESC/firecrown/archive/refs/tags/v$firecrown_ver.tar.gz
tar xvzf v$firecrown_ver.tar.gz
# Set up a common directory name without version info to set FIRECROWN_DIR more easily
ln -s firecrown-$firecrown_ver firecrown

conda env export --no-builds > $curBuildDir/desc-python-nersc-$CI_PIPELINE_ID-nobuildinfo.yml
conda env export > $curBuildDir/desc-python-nersc-$CI_PIPELINE_ID.yml

# Reset pip caching to whatever it was before
#if [ DESC_PIPCACHEUNSET ] 
#then
#  pip config unset global.no-cache-dir
#else
#  pip config set global.no-cache-dir $current_cache_flag
#fi

python -m compileall $curBuildDir/py/envs/desc-python
echo "Done compiling"
