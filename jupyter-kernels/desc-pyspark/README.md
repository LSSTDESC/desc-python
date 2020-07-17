# Apache Spark + DESC python kernel for Cori@NERSC

This kernel allows DESC members to use the desc-python kernel with PySpark at NERSC.
By default the kernel uses 4 threads. It has been generated using:
https://github.com/astrolabsoftware/spark-kernel-nersc#apache-spark-kernel-for-desc-members-recommended

The Apache Spark version in use is currently 3.0.0. This version is maintained by Julien Peloton at NERSC and it is not intended for running batch or interactive jobs. For that purpose see rather:
https://github.com/LSSTDESC/desc-spark#working-at-nersc-batch-mode

If you have trouble with this kernel, contact me (Julien Peloton, peloton@lal.in2p3.fr).

## Using Pyarrow > 0.13

By default, the current desc-python version uses `pyarrow==0.13` which is not compatible with Spark 3.0.0. While waiting for an upgrade of the package (see this discussion for example https://github.com/LSSTDESC/desc-help/issues/25), you will need to install yourself a higher version of pyarrow:

```bash
# this will install 0.17+
pip install pyarrow --user --upgrade
```

and add it to the `DESCPYTHONPATH`:

```bash
# in your ~/.bashrc.ext for example
DESCPYTHONPATH=$HOME/.local/lib/python3.7/site-packages:$DESCPYTHONPATH
```

Beware if you have other things installed here - there could be conflicts!

# Logbook

- 12/11/2018: Initial release of the kernel using Spark 2.4.0
- 17/07/2020: Update Spark version to 3.0.0
