# How to set up a new DESC python enviroment

* Run `bash ./install-desc.sh <path to installation> <name of yaml file>`

Example:  `bash ./install-desc.sh $CSCRATCH/test-install desc-python-env.yml`

Note there are two yaml files: 

`desc-python-env.yml` Contains minimal explicit versions, only specifying version where it is important, such as `pyarrow`

`desc-python-env-nersc-vers.yml` Contains the exact versions of each package installed at NERSC


### Permissions
fast3tree builds its library on the fly.  Initially, write access is required to allow this library to be built.
