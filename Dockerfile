FROM nersc/spark-3.1.1:v1
MAINTAINER Heather Kelly <heather@slac.stanford.edu>

#    git clone https://github.com/LSSTDESC/desc-python && \
#    git checkout pyspark && \
#    cd desc-python/conda && \

COPY conda /tmp

RUN ls /tmp && \
    conda install -c conda-forge -y mamba && \
    mamba install -c conda-forge -y --file=/tmp/desc-python-conda-install.txt && \
    pip install -r /tmp/desc-python-pip-install.txt && \
    cd /tmp && \
    rm -Rf conda
    
ENV HDF5_USE_FILE_LOCKING FALSE
ENV PYTHONSTARTUP ''
ENV PYSPARK_DRIVER_PYTHON ipython
