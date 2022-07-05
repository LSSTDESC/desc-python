
During the installation process we have two lists of packages one for conda-forge (conda/condalist.txt) and another for pip (conda/piplist.txt)

There are yaml files which describe what is installed at NERSC: 

`desc-python-env-nersc-install-nobuildinfo.yml` Contains the exact versions without explicit build info of each package installed at NERSC. Use this to replicate what is currently installed at NERSC at other sites.

`desc-python-env-nersc-export.yml` Current full listing of what is installed at NERSC in desc-python which includes build info.

