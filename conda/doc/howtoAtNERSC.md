# How to set up a new DESC python enviroment at NERSC

* If installing a shared conda environment
  * Check the default Access Control List (ACL) for the installation directory ie. `getfacl <PathToYourInstallDirectory>`
  * If group permissions allow write access, consider setting the default ACL group permissions to just rx
      * `setfacl -d -m"group::rx" <PathToYourInstallDirectory>`
* Run `bash ./install-desc.sh <path to installation> <name of yaml file>`

To set up a new desc-python:
`bash ./install-desc-python.sh $CSCRATCH/test-install`

If reinstalling desc-python using an input yaml file
`bash ./install-desc-python.sh $CSCRATCH/test-install desc-python-env-nersc-install-nobuildinfo.yml`

To export a full list of versions without build info:
`conda env export --no-builds > desc-python-env-nersc-install-nobuildinfo.yml`
To be useful, this exported list must be modified for those packages requiring a full URL for installation such as:
```
    - https://bitbucket.org/yymao/helpers/get/v0.3.2.tar.gz
    - https://github.com/LSSTDESC/descqa/archive/v2.0.0-0.7.0.tar.gz
    - https://github.com/yymao/FoFCatalogMatching/archive/v0.1.0.tar.gz
    - https://github.com/msimet/Stile/archive/v0.1.tar.gz
    - https://github.com/LSSTDESC/CatalogMatcher/archive/master.tar.gz
```

## Environment Set Up After Installation

To prepare your environment to use the new conda environment:

```
source <path to installation>/etc/profile.d/conda.sh
conda activate base
```

When finished with the conda environment, do:  `conda deactivate`

