# Complex Package Install Example (BATSim)

Example package: [BATSim](https://github.com/CMacM/BATSim)

Pip installation requires the GalSim C++ library

## Steps

How to pip install BATSim against the desc-stack[-weekly-latest] container?

1. Initialize your user package area and start the environment.

```bash
mkdir "$PSCRATCH/mypackages"
export DESCSTACKUSERBASE="$PSCRATCH/mypackages"
python /global/common/software/lsst/common/miniconda/start-kernel-cli.py desc-stack-weekly-latest
unset PYTHONNOUSERSITE
```

2. Check the version of GalSim already installed in the container.

```bash
conda list galsim
```

For this example, the expected version is `galsim 2.8.3`.

3. Build/install the matching GalSim sources.

```bash
cd "$DESCSTACKUSERBASE"
git clone https://github.com/GalSim-developers/GalSim.git
cd GalSim
git checkout v2.8.3  # matching the version in the container
export FFTW_DIR="$CONDA_PREFIX"
export EIGEN_DIR="$CONDA_PREFIX/include/eigen3"
python setup.py build_shared_clib
python3 -m pip install --user --no-build-isolation .
cp "$DESCSTACKUSERBASE"/GalSim/build/shared_clib/*.so "$DESCSTACKUSERBASE"/lib/python3.13/site-packages/galsim
```

4. Install BATSim with the required include/library environment variables.

```bash
cd "$DESCSTACKUSERBASE"
git clone https://github.com/CMacM/BATSim.git
cd BATSim
export LD_LIBRARY_PATH="$DESCSTACKUSERBASE/lib/python3.13/site-packages/galsim:$LD_LIBRARY_PATH"
export LIBRARY_PATH="$DESCSTACKUSERBASE/lib/python3.13/site-packages/galsim:$LIBRARY_PATH"
export CPLUS_INCLUDE_PATH="$(python -c "import galsim, os; print(os.path.join(os.path.dirname(galsim.__file__), 'include'))"):$CPLUS_INCLUDE_PATH"
python3 -m pip install --user --no-build-isolation .
```

## Persist for Jupyter

To use this new installation of BATSim in jupyter.nersc.gov, add this to `$HOME/.bashrc`:

```bash
export DESCSTACKUSERBASE=$PSCRATCH/mypackages
```
