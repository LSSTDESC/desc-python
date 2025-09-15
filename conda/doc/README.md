
We are now using [conda-lock](https://github.com/conda/conda-lock)

A GitHub Action periodically runs to generate lock files that will ultimately be used for installation at NERSC and elsewhere. 

The GitHub Action references two files that define the set of packages in the build conda/lock/environment.yml and conda/lock/pyproject.toml

