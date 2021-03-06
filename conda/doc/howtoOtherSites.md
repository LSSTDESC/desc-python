# How to set up a new DESC python enviroment at Other Sites

* If installing a shared conda environment
  * Check the default Access Control List (ACL) for the installation directory ie. `getfacl <PathToYourInstallDirectory>`
  * If group permissions allow write access, consider setting the default ACL group permissions to just rx
      * `setfacl -d -m"group::rx" <PathToYourInstallDirectory>`
* Run `bash ./install-desc.sh <path to installation> <name of yaml file>`

Example:  `bash ./install-desc.sh $CSCRATCH/test-install desc-python-env-nersc-install-nobuildinfo.yml`

## Environment Set Up After Installation

To prepare your environment to use the new `desc` conda environment, the following must be done:

```
source <path to installation>/etc/profile.d/conda.sh
conda activate desc
```

When finished with the `desc` conda environment, do:  `conda deactivate`

### Permissions
fast3tree builds its library on the fly.  Initially, write access is required to allow this library to be built.  This is handled in the install-desc.sh script.
