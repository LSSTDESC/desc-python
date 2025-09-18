# How to set up a new DESC python enviroment at Other Sites

* If installing a shared conda environment
  * Check the default Access Control List (ACL) for the installation directory ie. `getfacl <PathToYourInstallDirectory>`
  * If group permissions allow write access, consider setting the default ACL group permissions to just rx
      * `setfacl -d -m"group::rx" <PathToYourInstallDirectory>`

Run the installation script from the `desc-python` directory
```
cd desc-python
bash ./conda/install-desc-python.sh <path to installation>
```

Example:  `bash ./conda/install-from-lock.sh $SCRATCH/test-install`

Set up a symlink named `current` pointing to your new installation
```
cd <PathToYourInstallDirectory>
ln -s <buildDirectory>/py current
```

## Environment Set Up After Installation

To prepare your environment to use the conda environment, copy the desc-python/jupyter-kernels/setup/setup_current_python.sh` to a convenient location, check the setting of `DESC_INST_DIR` in the script and then do:

```
source setup_current_python.sh
```

