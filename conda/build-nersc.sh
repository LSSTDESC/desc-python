#!/bin/bash

module unload python
module swap PrgEnv-intel PrgEnv-gnu
module unload craype-network-aries
module unload cray-libsci
module unload craype
module load cray-mpich-abi/8.1.28

export LD_LIBRARY_PATH=$CRAY_MPICH_BASEDIR/mpich-gnu-abi/8.2/lib:$LD_LIBRARY_PATH

unset PYTHONPATH

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
elif [[ "$installFlag" ]];  # Install Prod
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

mkdir -p $curBuildDir
cp conda/conda-pack.txt $curBuildDir
cp conda/pip-pack.txt $curBuildDir
#cp conda/setup-desc-python.sh $curBuildDir
cp conda/sitecustomize.py $curBuildDir
#sed -i 's|$1|'$curBuildDir'|g' $curBuildDir/setup-desc-python.sh
cd $curBuildDir


# Build Steps

# Try Mambaforge latest
url="https://github.com/conda-forge/miniforge/releases/latest/download"
url="$url/Mambaforge-Linux-x86_64.sh"
curl -LO "$url"

bash ./Mambaforge-Linux-x86_64.sh -b -p $curBuildDir/py
source $curBuildDir/py/etc/profile.d/conda.sh
conda activate base

mamba install -c conda-forge -y mpich=4.0.3=external_* 

#export LD_LIBRARY_PATH=/opt/cray/pe/mpt/7.7.19/gni/mpich-gnu-abi/8.2/lib:$LD_LIBRARY_PATH


cd $curBuildDir

mamba install -c conda-forge -y --file ./conda-pack.txt
pip install --no-cache-dir -r ./pip-pack.txt

conda clean -y -a 

conda config --set env_prompt "(desc-py)" --env

conda env export --no-builds > $curBuildDir/desc-python-nersc-$CI_PIPELINE_ID-nobuildinfo.yml
conda env export > $curBuildDir/desc-python-nersc-$CI_PIPELINE_ID.yml


# Set permissions
setfacl -R -m group::rx $curBuildDir
setfacl -R -d -m group::rx $curBuildDir

setfacl -R -m user:desc:rwx $curBuildDir
setfacl -R -d -m user:desc:rwx $curBuildDir



