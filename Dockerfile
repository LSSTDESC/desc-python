FROM ubuntu:20.04
MAINTAINER Heather Kelly <heather@slac.stanford.edu>

ARG PR_BRANCH=bleed

ARG GH_SHA
ARG DESC_PYTHON_DIR=/opt/desc

#RUN pwd && ls && echo $GH_SHA 

RUN apt update -y && \
    apt install -y curl \
    build-essential \
    gfortran \
    git \
    patch \
    wget && \
    apt-get clean  && \
    rm -rf /var/cache/apt && \
    groupadd -g 1000 -r lsst && useradd -u 1000 --no-log-init -m -r -g lsst lsst && \
    usermod --shell /bin/bash lsst && \
    mkdir -p $DESC_PYTHON_DIR && \
    chown lsst $DESC_PYTHON_DIR && \
    chgrp lsst $DESC_PYTHON_DIR

ARG LSST_USER=lsst
ARG LSST_GROUP=lsst


WORKDIR $DESC_PYTHON_DIR
   
    
RUN cd /tmp && \
    git clone https://github.com/LSSTDESC/desc-python && \
    cd desc-python && \ 
    git checkout $PR_BRANCH && \
    cd conda && \
    bash install-mpich.sh && \
    cd /tmp && \
    chown -R lsst desc-python 

USER lsst

RUN cd /tmp/desc-python/conda && \ 
    bash install-desc.sh /opt/desc/py desc-python-env.yml NERSC && \
    cd /tmp && \
    echo "source /opt/desc/py/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate desc" >> ~/.bashrc && \
    rm -Rf desc-python
    
ENV HDF5_USE_FILE_LOCKING FALSE
ENV PYTHONSTARTUP ''

ENV PATH="${DESC_PYTHON_DIR}:${PATH}"


CMD ["/bin/bash"]
