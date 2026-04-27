# Installing your own copy of desc-python

Using [conda-lock](https://github.com/conda/conda-lock) you can quickly and easily install your own copy of most DESC conda environments where lock files are available.

## At NERSC

`conda-lock` is available for all DESC members at NERSC, just add `$CFS/lsst/utilities/bin`to your PATH

`export PATH=$CFS/lsst/utilities/bin:$PATH`

In this example we will install a copy of `desc-python`.

To use the current production version of `desc-python`, let us assume $curBuildDir points to your desired installation directory

```bash
git clone https://github.com/LSSTDESC/desc-python.git`
cp desc-python/conda/sitecustomize.py $curBuildDir
cp desc-python/conda/desc-py-lock.yml $curBuildDir
cp desc-python/conda/pip.config $curBuildDir
cd $curBuildDir

module unload python
module load cpu
module unload cray-libsci
module load cray-mpich-abi/8.1.30
export CONDA_PKGS_DIRS=$curBuildDir/pkgs

# use your own copy of Miniforge
url="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
curl -LO "$url"

bash ./Miniforge3-Linux-x86_64.sh -b -p $curBuildDir/py
source $curBuildDir/py/bin/activate

export PIP_CONFIG_FILE=$curBuildDir/pip.config

conda-lock install --mamba -n my-desc-python $curBuildDir/desc-py-lock.yml

conda activate my-desc-python

conda env config vars set CSL_DIR=${CONDA_PREFIX}/cosmosis-standard-library
cd ${CONDA_PREFIX}
source ${CONDA_PREFIX}/bin/cosmosis-configure
cosmosis-build-standard-library main
```

And that's it!

#### To use your my-desc-python environment

Create two environment variables and add them to your NERSC `$HOME/.bashrc`. 

`DESCUSERENV_DIR` should point to your conda installation's directory that contains `bin` and `DESCUSERENV_NAME` should be the name of your conda environment.

```bash
export DESCUSERENV_DIR=$curBuildDir/py
export DESCUSERENV_NAME=my-desc-python
```

Now you can source setup_current_python.sh as usual, and your installation will be initialized.  Similarly when using the `desc-python` kernel in NERSC's jupyter, you will be using your own copy of the environment.

```bash
source /global/comon/software/lsst/common/miniconda/setup_current_python.sh
```
