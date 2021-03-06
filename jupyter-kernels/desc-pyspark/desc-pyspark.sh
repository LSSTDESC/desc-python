#!/bin/bash
# Where the Spark logs will be stored
# Logs can be then be browsed from the Spark UI
if [ -z ${SCRATCH} ]; then
  SCRATCH=`mktemp -d`
fi
LOGDIR=${SCRATCH}/spark/event_logs
mkdir -p ${LOGDIR}

# Spark defaults to /tmp, overridden using the SPARK_LOCAL_DIRS environment variable
# The directory `/global/cscratch1/sd/<user>/tmpfiles` will be created if it
# does not exist to store temporary files used by Spark.
mkdir -p ${SCRATCH}/sparktmp
export SPARK_LOCAL_DIRS="${SCRATCH}/sparktmp"

# Path to LSST miniconda installation at NERSC
LSSTCONDA="/global/common/software/lsst/common/miniconda"
LSSTCONDABIN="${LSSTCONDA}/dev/envs/desc/bin"

# Since the default NERSC Apache Spark runs inside of Shifter, we use
# a custom local version of it. This is maintained by me (Julien Peloton)
# at NERSC. If you encounter problems, let me know (peloton at lal.in2p3.fr)!
SPARKPATH="/global/homes/p/peloton/myspark/spark-3.0.0-bin-hadoop2.7"

# Here is the environment needed for Spark to run at NERSC.
export SPARK_HOME="${SPARKPATH}"
export PYSPARK_SUBMIT_ARGS="--master local[4] --driver-memory 8g --executor-memory 8g --packages com.github.astrolabsoftware:spark-fits_2.11:0.8.4 --conf spark.driver.extraJavaOptions=-Dio.netty.tryReflectionSetAccessible=true --conf spark.eventLog.enabled=true --conf spark.eventLog.dir=file://${SCRATCH}/spark/event_logs --conf spark.history.fs.logDirectory=file://${SCRATCH}/spark/event_logs pyspark-shell"
export PYTHONSTARTUP="${SPARKPATH}/python/pyspark/shell.py"

# Make sure the version of py4j is correct.
export DESCPYTHONPATH="${SPARKPATH}/python/lib/py4j-0.10.9-src.zip:${SPARKPATH}/python:${DESCPYTHONPATH}"

# Should correspond to desc-python
export PYSPARK_PYTHON="${LSSTCONDABIN}/python"
export PYSPARK_DRIVER_PYTHON="${LSSTCONDABIN}/ipython"

export JAVA_HOME="/usr/lib64/jvm/java"

# desc-python activation script
source ${LSSTCONDA}/kernels/python-dev.sh
