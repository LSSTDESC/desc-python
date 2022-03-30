#!/bin/bash

for GROUP in `groups`
do
    if [[ $GROUP = "lsst" ]]; then HAS_LSST=1; fi
done

if [[ $HAS_LSST != 1 ]]; then
    echo "Contact Heather Kelly <heather@slac.stanford.edu> to request joining the NERSC 'lsst' group."
    exit 1
fi

module unload python
INST_DIR=/global/common/software/lsst/common/miniconda
source $INST_DIR/setup_current_python.sh
jupyter kernelspec install $INST_DIR/kernels/desc-python --user
jupyter kernelspec install $INST_DIR/kernels/desc-python-dev --user
jupyter kernelspec install $INST_DIR/kernels/desc-python-bleed --user
jupyter kernelspec install $INST_DIR/kernels/desc-python-old --user
jupyter kernelspec install $INST_DIR/kernels/desc-python-img --user
jupyter kernelspec install $INST_DIR/kernels/desc-stack --user
jupyter kernelspec install $INST_DIR/kernels/desc-stack-dev --user
jupyter kernelspec install $INST_DIR/kernels/desc-stack-old --user
jupyter kernelspec install $INST_DIR/kernels/desc-stack-weekly --user
jupyter kernelspec install $INST_DIR/kernels/desc-stack-weekly-latest --user
jupyter kernelspec install $INST_DIR/kernels/desc-pyspark --user
jupyter kernelspec install $INST_DIR/kernels/desc-td-env --user
echo "Your JupyterLab URL is: "
echo "https://jupyter.nersc.gov/user/$USER/cori-shared-node-cpu/lab/tree/$HOME"
