#!/bin/bash

(
echo
echo '==========='
echo 'User groups'
echo '==========='
groups

echo
echo "==============="
echo "current modules"
echo "==============="
module list

echo 
echo "=============="
echo "current python"
echo "=============="
which python

echo
echo '====================='
echo 'Environment variables'
echo '====================='
echo "SHELL               = $SHELL"
echo "SHELL_PARSING       = $SHELL_PARSING"
echo "DESCPYTHONPATH      = $DESCPYTHONPATH"
echo "PYTHONHOME          = $PYTHONHOME"
echo "JUPYTER_CONFIG_DIR  = $JUPYTER_CONFIG_DIR"
echo "JUPYTER_RUNTIME_DIR = $JUPYTER_RUNTIME_DIR"
echo "JUPYTER_PATH        = $JUPYTER_PATH"

echo
echo '====================='
echo 'Content of ~/.condarc'
echo '====================='
cat ~/.condarc

echo
echo '==================='
echo 'Content of ~/.local'
echo '==================='
ls -R ~/.local

echo 
echo '=================================='
echo 'Content of desc-python kernel file'
echo '=================================='
cat ~/.local/share/jupyter/kernels/desc-python/kernel.json

echo 
echo '=================================='
echo 'Content of desc-stack kernel file'
echo '=================================='
cat ~/.local/share/jupyter/kernels/desc-stack/kernel.json

echo 
echo '========================'
echo 'Content of ~/.bashrc.ext'
echo '========================'
cat ~/.bashrc.ext

echo 
echo '========================='
echo 'Content of ~/.profile.ext'
echo '========================='
cat ~/.profile.ext

echo 
echo '=============================='
echo 'Content of ~/.bash_profile.ext'
echo '=============================='
cat ~/.bash_profile.ext

echo 
echo '========================'
echo 'Content of ~/jupyter.log'
echo '========================'
tail -n 100 ~/.jupyter.log
)
