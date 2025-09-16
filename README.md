# desc-python
Collection of DESC python environments and jupyter kernels

## Setup for use on the Command line
NERSC: ```source/global/common/software/lsst/common/miniconda/setup_current_python.sh```

CC: ```source /pbs/throng/lsst/software/desc/common/miniconda/setup_current_python.sh```

## [How to Add User Installed Packages To Your Environment](https://github.com/LSSTDESC/desc-python/wiki/Add-Packages-to-the-desc-python-environment)

## Initial User setup for Jupyter (Only need to do this once)
See: https://confluence.slac.stanford.edu/display/LSSTDESC/Using+Jupyter+at+NERSC (Confluence log-in required)

### Current Jupyter Kernels
- desc-python:  Current producution release including all DESC requested packages
- desc-python-dev: Upcoming production release of desc-python
- desc-python-bleed: Picks up latest releases of all python packages. Updated weekly
- desc-python-old: Previous production release of desc-python

## List of Packages Included in the desc-python Environment
see [here](https://github.com/LSSTDESC/desc-python/blob/main/conda/lock/environment.yml) and [here]([https://github.com/LSSTDESC/desc-python/blob/main/conda/conda-pack.txt](https://github.com/LSSTDESC/desc-python/blob/main/conda/lock/pyproject.toml) 


## How to Add Packages to desc-python?

1. Clone this repo and checkout the "bleed" branch
2. Add new package names to the `desc-python/conda/conda-pack.txt` (for conda-forge) or `desc-pythonv/conda/pip-pack.txt` (for PyPI)
    * If this package is not installable from conda-forge or pip, please [open an issue](https://github.com/LSSTDESC/desc-python/issues) on this repository.
3. Commit and push your changes to the bleed branch
4. Once changes are pushed to the bleed branch an automated build will be triggered:
    * Docker builds are handled by GitHub actions and will be triggered immediately. The builds can be followed by viewing the [Actions](https://github.com/LSSTDESC/desc-python/actions) page.
        * A successful build will produce a new image available on [Dockerhub](https://hub.docker.com/r/lsstdesc/desc-python/tags): `lsstdesc/desc-python:bleed`
 5. If there are data files or set up commands needed for the new package, then please [open an issue](https://github.com/LSSTDESC/desc-python/issues) on this repository.

