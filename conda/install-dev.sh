#!/bin/sh

## bash install-dev.sh <pathToExistingCondaInstall> ./desc-python-env.yml NERSC  

if [ -z "$1" ]
then	
	echo "Please provide a full path install directory"
	exit 1
fi

unset PYTHONPATH

which python
export PATH=$1/bin:$PATH
source $1/etc/profile.d/conda.sh
which python

conda env create -n desc-dev -f $2

conda activate desc-dev

# Finish installing fast3tree by forcing the creation of its library
echo -e "from fast3tree.make_lib import make_lib\nmake_lib(3, True)\nmake_lib(3, False)\nmake_lib(2, True)\nmake_lib(2, False)" >> ./install_fast3tree.py
python ./install_fast3tree.py
rm ./install_fast3tree.py

# Install jupyterlab at CC
if [[ -z $3 ]]
then	
  pip install jupyterlab
fi



