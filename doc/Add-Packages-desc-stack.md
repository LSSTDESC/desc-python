# Add Packages to the desc-stack Environment

If you are new to DESC and DESC python environments, please consult our related documentation for [NERSC](https://confluence.slac.stanford.edu/display/LSSTDESC/Getting+Started+at+NERSC) or [IN2P3](https://doc.lsst.eu/).

You may have additional packages or an updated version of a package that you want to install alongside desc-stack (or desc-stack-weekly or desc-stack-weekly-latest).

* If this is a package of general interest, please consult within your Working Groups and then request the package be added to desc-python and/or desc-stack by [opening an issue in desc-help](https://github.com/LSSTDESC/desc-help/issues).

## To add package(s) locally to your desc-stack environment
Create a directory to store the installation artifacts associated with your new packages, create the DESCSTACKUSERBASE environment variable and then pip install the packages you wish to add.
* ```
   cd $SCRATCH   # I just chose SCRATCH.. you could use another area
   mkdir <yourInstallArea>
   export DESCSTACKUSERBASE=$PWD/<yourInstallArea>   # This env var is recognized by the desc-stack-weekly setup, so --user installs will use this dir
   # For desc-python, use DESCPYTHONUSERAREA.  For desc-python-bleed, use DESCPYTHONBLEEDUSERBASE
   python /global/common/software/lsst/common/miniconda/start-kernel-cli.py desc-stack-weekly
   unset PYTHONNOUSERSITE
   pip install --user --no-build-isolation <NewPackage>
  ```
To enable your installed packages the next time you set up desc-stack-weekly in Jupyter or on the command line, you will need to set the following in your $HOME/.bashrc:

```
export DESCSTACKUSERBASE=<fullPathtoYourInstallArea>
```

