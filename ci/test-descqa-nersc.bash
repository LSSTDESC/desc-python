#!/bin/bash

set -e

expectedPyPath=/global/common/software/lsst/common/miniconda

# Clone main branch of descqa for testing
git clone https://github.com/LSSTDESC/descqa.git

# User current setup_current_python.sh script located in this repo for testing
source jupyter-kernels/setup/setup_current_python.sh

actualPyPath="$(which python)"
if [[ $actualPyPath != *$expectedPyPath* ]]; then
   echo "Unexpected Python installation location"
   exit 1
fi

export OUTPUTDIR=$PWD
cd descqa

python -E -c "import descqarun; descqarun.main()" "$OUTPUTDIR" -m ci-testing -t SkyArea -c cosmoDC2_v1.1.4_small
if [ $? = 0 ]; then
    exit 0
fi
exit 1

