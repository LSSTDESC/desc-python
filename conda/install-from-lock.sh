#!/bin/bash

module unload python
module swap PrgEnv-intel PrgEnv-gnu
module unload cray-libsci
module load cray-mpich-abi/8.1.30

unset PYTHONPATH

setup_conda() {
    source $curBuildDir/py/etc/profile.d/conda.sh
}

config_cosmosis() {
   source ${CONDA_PREFIX}/bin/cosmosis-configure
}

# Set to 1 to install into the common sofware area
installFlag=$1

commonWeeklyBuildDir=/global/common/software/lsst/gitlab/desc-python-int
commonDevBuildDir=/global/common/software/lsst/gitlab/desc-python-dev
commonProdBuildDir=/global/common/software/lsst/gitlab/desc-python-prod

export BUILD_ID_DATE=`echo "$(date "+%F-%M-%S")"`
export CI_COMMIT_REF_NAME=prod
export CI_PIPELINE_ID=$BUILD_ID_DATE

if [ "$CI_COMMIT_REF_NAME" = "dev" ];  # dev
then
    curBuildDir=$commonDevBuildDir/$CI_PIPELINE_ID
    echo "Dev Install Build: " $curBuildDir
else  # Install Prod
    if [[ -z "$CI_COMMIT_TAG" ]];
    then
        prodBuildDir=$CI_PIPELINE_ID
    else
        prodBuildDir=$CI_COMMIT_TAG
    fi
    curBuildDir=$commonProdBuildDir/$prodBuildDir
    echo "Prod Build: " $curBuildDir
fi

mkdir -p $curBuildDir
#cp conda/conda-pack.txt $curBuildDir
#cp conda/pip-pack.txt $curBuildDir
#cp conda/setup-desc-python.sh $curBuildDir
cp conda/sitecustomize.py $curBuildDir
cp conda/desc-py-lock.yml $curBuildDir
#cp conda/lock/environment.yml $curBuildDir
#cp conda/lock/pyproject.toml $curBuildDir
cd $curBuildDir


# Build Steps
export PYTHONNOUSERSITE=1
export CONDA_PKGS_DIRS=$curBuildDir/pkgs

url="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
curl -LO "$url"

bash ./Miniforge3-Linux-x86_64.sh -b -p $curBuildDir/py
setup_conda
conda activate base

python -m pip cache purge
pip config set global.no-cache-dir true

conda-lock install --mamba -n desc desc-py-lock-main-2025-09-10.yml

conda activate desc

conda env config vars set CSL_DIR=${CONDA_PREFIX}/cosmosis-standard-library
cd ${CONDA_PREFIX}
config_cosmosis
cosmosis-build-standard-library main
cd $curBuildDir


conda clean -y -a 

python -m compileall $curBuildDir

conda config --set env_prompt "(desc-py)" --env

conda env export --no-builds > $curBuildDir/desc-python-nersc-$CI_PIPELINE_ID-nobuildinfo.yml
conda env export > $curBuildDir/desc-python-nersc-$CI_PIPELINE_ID.yml
#

# Set permissions
setfacl -R -m group::rx $curBuildDir
setfacl -R -d -m group::rx $curBuildDir

setfacl -R -m user:desc:rwx $curBuildDir
setfacl -R -d -m user:desc:rwx $curBuildDir



