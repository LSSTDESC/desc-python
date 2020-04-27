#!/bin/sh

if [ -z "$1" ]
then	
	echo "Please provide a full path install directory"
	exit 1
fi

unset PYTHONPATH

curl -LO https://repo.anaconda.com/miniconda/Miniconda3-4.7.12.1-Linux-x86_64.sh

bash ./Miniconda3-4.7.12.1-Linux-x86_64.sh -b -p $1
which python
export PATH=$1/bin:$PATH
which python

conda env create -f $2

source $1/etc/profile.d/conda.sh
conda activate desc

# Finish installing fast3tree by forcing the creation of its library
echo -e "from fast3tree.make_lib import make_lib\nmake_lib(3, True)\nmake_lib(3, False)\nmake_lib(2, True)\nmake_lib(2, False)" >> ./install_fast3tree.py
python ./install_fast3tree.py
rm ./install_fast3tree.py

# Install additional packages that require special handling
#pip install https://bitbucket.org/yymao/helpers/get/v0.3.2.tar.gz
#pip install https://github.com/LSSTDESC/descqa/archive/v2.0.0-0.7.0.tar.gz
#pip install https://github.com/LSSTDESC/desc-dc2-dm-data/archive/v0.5.0.tar.gz
#pip install https://github.com/yymao/FoFCatalogMatching/archive/v0.1.0.tar.gz
#pip install git+https://github.com/msimet/Stile

#git clone https://github.com/LSSTDESC/CatalogMatcher.git
#cd CatalogMatcher
#python setup.py install
#cd ..
#rm -Rf CatalogMatcher

# Install root_dir branch for now at CC
if [[ -z $3 ]]
then	
  pip install https://github.com/LSSTDESC/gcr-catalogs/archive/u/jrb/root_dir.tar.gz
  pip install jupyterlab
else
# Install latest release at NERSC
  pip install https://github.com/LSSTDESC/gcr-catalogs/archive/v0.15.0.tar.gz	
fi



