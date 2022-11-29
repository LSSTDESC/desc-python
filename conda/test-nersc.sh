#!/bin/bash

set -eo pipefail

module unload python
module swap PrgEnv-intel PrgEnv-gnu
module unload craype-network-aries
module unload cray-libsci
module unload craype
module load cray-mpich-abi/7.7.19
export LD_LIBRARY_PATH=$CRAY_MPICH_BASEDIR/mpich-gnu-abi/8.2/lib:$LD_LIBRARY_PATH

unset PYTHONPATH

# Set to 1 to install into the common sofware area
installFlag=$1

commonDevBuildDir=/global/common/software/lsst/gitlab/desc-python-dev
commonProdBuildDir=/global/common/software/lsst/gitlab/desc-python-prod


if [ "$CI_COMMIT_REF_NAME" = "dev" ];
then
    curBuildDir=$commonDevBuildDir/$CI_PIPELINE_ID
    echo "Dev Install Build: " $curBuildDir
elif [[ "$installFlag" ]];
then
    if [[ -z "$CI_COMMIT_TAG" ]];
    then
        prodBuildDir=$CI_PIPELINE_ID
    else
        prodBuildDir=$CI_COMMIT_TAG
    fi
    curBuildDir=$commonProdBuildDir/$prodBuildDir
    echo "Prod Build: " $curBuildDir
fi

source $curBuildDir/py/etc/profile.d/conda.sh
conda activate base

python -c 'import astropy'
python -c 'import pyccl'
