# Add Packages to the desc-python Environment

If you are new to DESC and DESC python environments, please consult our related documentation for [NERSC](https://confluence.slac.stanford.edu/display/LSSTDESC/Getting+Started+at+NERSC) or [IN2P3](https://doc.lsst.eu/).

You may have additional packages or an updated version of a package that you want to install alongside desc-python.

* If this is a package of general interest, please consult within your Working Groups and then request the package be added to desc-python by [opening an issue in desc-help](https://github.com/LSSTDESC/desc-help/issues).

## First way to install additional package(s) for use with desc-python
```
cd $SCRATCH   # I just chose SCRATCH.. you could use another area
mkdir <yourInstallArea>
export DESCPYTHONUSERBASE=$PWD/<yourInstallArea>   # This env var is recognized by the desc-python setup, so --user installs will use this dir
# For desc-python-bleed, use DESCPYTHONBLEEDUSERBASE.  For desc-stack-weekly or desc-stack-weekly-latest, use DESCSTACKUSERBASE
python /global/common/software/lsst/common/miniconda/start-kernel-cli.py desc-python
unset PYTHONNOUSERSITE
pip install --user --no-build-isolation <NewPackage>
```
If you are updating a package already available in the conda environment, include the `-U` option:
```
pip install --user --no-build-isolation -U <NewPackage>
```
If you are installing a package from source code rather than from PyPI, first obtain a copy of the source code, enter the package directory and pip install by doing:
```
python3 -m pip install --user --no-build-isolation .
``` 

To enable your installed packages the next time you set up desc-python in Jupyter or on the command line, you will need to set the following in your $HOME/.bashrc:
```
export DESCPYTHONUSERBASE=<fullPathtoYourInstallArea>
```

## Another way to install package(s): create your own conda environment

* Create a full clone of the `desc-python` environment in your own area (this will take a few minutes)
    * ```
       python /global/common/software/lsst/common/miniconda/start-kernel-cli.py desc-python
       conda create --clone base -p <PathToYourDir>/mydesc
      ```
    * Activate your new environment and add your desired packages
      ```
         conda activate <PathToYourDir>/mydesc
         mamba install <Your Package> OR pip install <Your Package> OR mamba install <Your Package>
      ```

* To enable your cloned environment automatically when using the desc-python env, including when using Jupyter at NERSC, you need to set up an environment variable in your NERSC `$HOME/.bashrc` or `$HOME/.cshrc`.  
If using bash, you would add this to your $HOME/.bashrc (create this file if it does not already exist):

`export DESCUSERENV=<FullPathToYourCondaEnv>`

Example:

`export DESCUSERENV=/global/common/software/lsst/users/heatherk/mydesc`

With the `DESCUSERENV` environment variable set, the next time you start the `desc-python` jupyter kernel, you will be using your own environment, rather than the official `desc-python`.

**NOTE:** If you have previously set `DESCPYTHONPATH`, it is strongly recommended that you remove the `DESCPYTHONPATH` environment variable from your `$HOME/.bashrc` (or `$HOME/.bashrc.ext`).  

Here is a full concrete example at NERSC

```
python /global/common/software/lsst/common/miniconda/start-kernel-cli.py desc-python
conda create --clone base -p /global/common/software/lsst/users/heatherk/mydesc
conda activate /global/common/software/lsst/users/heatherk/mydesc
mamba install -c conda-forge astrocats
```
Now your package(s) are installed in your personal desc conda environment:
* Set up the `DESCUSERENV` environment variable, then you can enable your desc conda env by doing:
```
python /global/common/software/lsst/common/miniconda/start-kernel-cli.py desc-python
```
* If you later decide to ignore or discard your desc conda environment, just unset `DESCUSERENV` and the next time you enable `desc-python` you will be using the default desc conda environment.

### Example: Installing Firecrown

Assuming you have already set up your own desc conda environment, and set your DESCUSERENV env variable, you can add any additional packages by doing:

```
python /global/common/software/lsst/common/miniconda/start-kernel-cli.py desc-python
mamba install -c conda-forge firecrown
```

Now I have firecrown installed in my own `mydesc` conda environment.  To give it a try, I need the examples available in the firecrown git repo, so I clone it into my own area:
```
cd /global/common/software/lsst/users/heatherk
git clone https://github.com/LSSTDESC/firecrown
```
Then I try a simple example:
```
cd firecrown/examples/des_y1_3x2pt
firecrown compute des_y1_3x2pt.yaml
Watch out! Here comes a firecrown!
analysis id: 190918deca4946d8879ac0b3c3d19232
loglike: -236.47695322891724
```

A similar example starting from the default desc-python environment at CC:

```bash
source /pbs/throng/lsst/software/desc/common/miniconda/setup_current_python.sh
conda create --clone desc --prefix="$PWD/mydesc"
conda activate /pbs/home/h/hkelly/mydesc
pip install git+https://github.com/LSSTDESC/firecrown.git
```

The shell prompt changes shown in the original transcript are omitted here for readability.

Now I have firecrown installed in my own `mydesc` conda environment.  To give it a try, I need the examples available in the firecrown git repo, so I clone it into my own area:
```
git clone https://github.com/LSSTDESC/firecrown
```
Then I try a simple example, first starting up an interactive session on a compute node:

```bash
qlogin -l sps=1,s_fsize=1G,s_cpu=1:00:00,s_rss=1G
source /pbs/throng/lsst/software/desc/common/miniconda/setup_current_python.sh
conda activate /pbs/home/h/hkelly/mydesc
cd firecrown/examples/des_y1_3x2pt
firecrown compute des_y1_3x2pt.yaml
```

Example output:

```text
Watch out! Here comes a firecrown!
analysis id: 190918deca4946d8879ac0b3c3d19232
loglike: -236.47695322891724
```
## Developer mode (not thoroughly checked)
If a package is included in a cloned env, the logical steps would be
```
conda uninstall <package> --force
git clone <package>
cd <package> && pip install --no-deps -e .
```
