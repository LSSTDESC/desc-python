#!/bin/bash
# Where the Spark logs will be stored
# Logs can be then be browsed from the Spark UI
if [ -z ${SCRATCH} ]; then
  SCRATCH=`mktemp -d`
fi
LOGDIR=${SCRATCH}/spark/event_logs
mkdir -p ${LOGDIR}

# The directory `/global/cscratch1/sd/<user>/tmpfiles` will be created if it
# does not exist to store temporary files used by Spark.
mkdir -p ${SCRATCH}/tmpfiles

# Path to LSST miniconda installation at NERSC
lSSTCONDA="/global/common/software/lsst/common/miniconda"

# Since the default NERSC Apache Spark runs inside of Shifter, we use
# a custom local version of it. This is maintained by me (Julien Peloton)
# at NERSC. If you encounter problems, let me know (peloton at lal.in2p3.fr)!
SPARKPATH="/global/homes/p/peloton/myspark/spark-2.3.2-bin-hadoop2.7"

# Here is the environment needed for Spark to run at NERSC.
export SPARK_HOME="${SPARKPATH}"
export PYSPARK_SUBMIT_ARGS="--master local[4]   --driver-memory 32g --executor-memory 32g   --packages com.github.astrolabsoftware:spark-fits_2.11:0.7.1 --conf spark.eventLog.enabled=true --conf spark.eventLog.dir=file://${SCRATCH}/spark/event_logs --conf spark.history.fs.logDirectory=file://${SCRATCH}/spark/event_logs pyspark-shell"
export PYTHONSTARTUP="${SPARKPATH}/python/pyspark/shell.py"

# Make sure the version of py4j is correct, and
# propagate user $DESCPYTHONPATH
export DESCPYTHONPATH="${SPARKPATH}/python/lib/py4j-0.10.7-src.zip:${SPARKPATH}/python:${DESCPYTHONPATH}"

# Should correspond to desc-python
export PYSPARK_PYTHON="${lSSTCONDA}/current/bin/python"
export PYSPARK_DRIVER_PYTHON="${lSSTCONDA}/current/bin/ipython3"

# We use Java 8. Spark 2+ does not work with Java 7 and earlier versions.
export JAVA_HOME="/opt/java/jdk1.8.0_51"

# desc-python activation script
source ${lSSTCONDA}/kernels/python.sh

