
Note there are multiple yaml files: 

`desc-python-env.yml` Contains minimal explicit versions, only specifying version where it is important, such as `pyarrow`  This yaml can be used when initially setting up a conda environment where we just want to pick up the latest releases of most packages.

`desc-python-env-nersc-install-nobuildinfo.yml` Contains the exact versions without explicit build info of each package installed at NERSC. Use this to replicate what is currently installed at NERSC.

`desc-python-env-nersc-export.yml` Current full listing of what is installed at NERSC in desc-python

`desc-dev-python-env-nersc-export.yml` Current full listing of what is installed in desc-python-dev at NERSC

