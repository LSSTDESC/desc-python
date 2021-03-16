FROM nersc/spark-3.1.1:v1
MAINTAINER Heather Kelly <heather@slac.stanford.edu>

RUN cd /tmp && \
    git clone https://github.com/LSSTDESC/desc-python && \
    git checkout pyspark && \
    cd desc-python/conda && \
    conda install -c conda-forge -y --file=/tmp/desc-python/conda/desc-python-conda-install.txt && \
    pip install -r /tmp/desc-stack/desc-python-pip-install.txt && \
    cd /tmp && \
    rm -Rf desc-python
    
ENV HDF5_USE_FILE_LOCKING FALSE
ENV PYTHONSTARTUP ''
