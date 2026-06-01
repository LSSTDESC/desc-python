#!/bin/bash


# Allows --user install
unset PYTHONNOUSERSITE

# Point to the area where --user packages should be installed
export PYTHONUSERBASE=$DESC_PY_EXTRA_PACKAGES

echo "Ready to pip install packages"
echo "pip install --user --no-deps --no-build-isolation <packageName>"
echo "If updating a package include the -U option"

