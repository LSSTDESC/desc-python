#!/bin/bash

for GROUP in `groups`
do
    if [[ $GROUP = "lsst" ]]; then HAS_LSST=1; fi
done

if [[ $HAS_LSST != 1 ]]; then
    echo "Contact Richard Dubois <richard@slac.stanford.edu> or Debbie Bard <djbard@lbl.gov> to request joining the 'lsst' group."
    exit 1
fi

module unload python
INST_DIR=/global/common/software/lsst/common/miniconda
source $INST_DIR/setup_current_python.sh
jupyter kernelspec install $INST_DIR/kernels/desc-python --user
jupyter kernelspec install $INST_DIR/kernels/desc-python-dev --user
jupyter kernelspec install $INST_DIR/kernels/desc-python-old --user
jupyter kernelspec install $INST_DIR/kernels/desc-stack --user
jupyter kernelspec install $INST_DIR/kernels/desc-stack-dev --user
jupyter kernelspec install $INST_DIR/kernels/desc-stack-old --user
jupyter kernelspec install $INST_DIR/kernels/desc-pyspark --user
jupyter kernelspec install $INST_DIR/kernels/desc-sims --user
echo "Your JupyterLab URL is: "
echo https://jupyter.nersc.gov/user/$USER/lab/tree/$HOME

