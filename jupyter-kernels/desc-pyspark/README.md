# Apache Spark + DESC python kernel for Cori@NERSC

This kernel allows DESC members to use the desc-python kernel with PySpark at NERSC.
By default the kernel uses 4 threads. It has been generated using:
https://github.com/astrolabsoftware/spark-kernel-nersc#apache-spark-kernel-for-desc-members-recommended

The Apache Spark version in use is currently 3.0.0. This version is maintained by Julien Peloton at NERSC and it is not intended for running batch or interactive jobs. For that purpose see rather:
https://github.com/LSSTDESC/desc-spark#working-at-nersc-batch-mode

If you have trouble with this kernel, contact me (Julien Peloton, peloton@lal.in2p3.fr).

# Logbook

- 12/11/2018: Initial release of the kernel using Spark 2.4.0
- 17/07/2020: Update Spark version to 3.0.0
