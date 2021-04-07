FROM nersc/spark-3.1.1:v1
MAINTAINER Heather Kelly <heather@slac.stanford.edu>

#    git clone https://github.com/LSSTDESC/desc-python && \
#    git checkout pyspark && \
#    cd desc-python/conda && \

COPY conda /tmp

# Temporary while waiting for new NERSC spark image
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/bin/spark-3.1.1/bin/

RUN ls /tmp && \
    curl -LO https://repo.anaconda.com/archive/Anaconda3-2020.11-Linux-x86_64.sh && \
    bash ./Anaconda3-2020.11-Linux-x86_64.sh -b -p /opt/desc/py && \
    rm ./Anaconda3-2020.11-Linux-x86_64.sh

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/desc/py/bin:/usr/local/bin/spark-3.1.1/bin/

RUN conda install -c conda-forge -y mamba && \
    mamba install -c conda-forge -y --file=/tmp/desc-python-conda-install.txt && \
    pip install -r /tmp/desc-python-pip-install.txt && \
    cd /tmp && \
    rm -Rf conda
    
ENV HDF5_USE_FILE_LOCKING FALSE
ENV PYTHONSTARTUP ''
ENV PYSPARK_DRIVER_PYTHON ipython
