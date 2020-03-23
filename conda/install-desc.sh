#!/bin/sh

if [ -z "$1" ]
then	
	echo "Please provide a full path install directory"
	exit 1
fi

curl -LO https://repo.anaconda.com/miniconda/Miniconda3-4.7.12.1-Linux-x86_64.sh

bash ./Miniconda3-4.7.12.1-Linux-x86_64.sh -b -p $1
which python
export PATH=$1/bin:$PATH
which python

conda env create -f $2

source $1/etc/profile.d/conda.sh
conda activate desc

# Install additional packages that require special handling
pip install https://bitbucket.org/yymao/helpers/get/v0.3.2.tar.gz
pip install https://github.com/LSSTDESC/descqa/archive/v2.0.0-0.7.0.tar.gz
pip install https://github.com/LSSTDESC/desc-dc2-dm-data/archive/v0.5.0.tar.gz
pip install https://github.com/yymao/FoFCatalogMatching/archive/v0.1.0.tar.gz
pip install git+https://github.com/msimet/Stile

git clone https://github.com/LSSTDESC/CatalogMatcher.git
cd CatalogMatcher
python setup.py install
cd ..

# Install root_dir branch for now
git clone https://github.com/LSSTDESC/gcr-catalogs.git
cd gcr-catalogs
git checkout u/jrb/root_dir
python setup.py install
cd ..



