# desc-python
Collection of DESC python environments and jupyter kernels

## Setup for use on the Command line
NERSC: ```source /global/common/software/lsst/common/miniconda/setup_current_python.sh```

CC-IN2P3: ```source /pbs/throng/lsst/software/desc/common/miniconda/setup_current_python.sh```

## Documentation
See the [doc directory](./doc/) for guides and how-to documentation, including:
- [How to Add User Installed Packages To Your Environment](./doc/Add-Packages-to-the-desc-python-environment.md)
- [Add Your Own Packages to the desc stack Environment](./doc/Add-Your-Own-Packages-to-the-desc-stack-Environment.md)

## Initial User setup for Jupyter (Only need to do this once)
See: https://confluence.slac.stanford.edu/display/LSSTDESC/Using+Jupyter+at+NERSC (Confluence log-in required)

### Current Jupyter Kernels
- desc-python:  Current producution release including all DESC requested packages
- desc-python-dev: Upcoming production release of desc-python
- desc-python-bleed: Picks up latest releases of all python packages. Updated weekly
- desc-python-old: Previous production release of desc-python

## List of Packages Included in the desc-python Environment
see [here](https://github.com/LSSTDESC/desc-python/blob/main/conda/lock/environment.yml) and [here](https://github.com/LSSTDESC/desc-python/blob/main/conda/lock/pyproject.toml) 

[Current versions of all packages](https://github.com/LSSTDESC/desc-python/blob/main/conda/desc-py-lock.yml)

