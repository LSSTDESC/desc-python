FROM ubuntu:20.04
MAINTAINER Heather Kelly <heather@slac.stanford.edu>

ARG PR_BRANCH=master

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
    ls && \
    pwd && \
    cd desc-python && \
    ls && \
    pwd && \
    cd conda && \ 
    ls && \
    pwd && \
    bash install-mpich.sh && \
    cd /tmp && \
    chown -R lsst desc-python 

USER lsst

RUN cd /tmp/desc-python/docker && \ 
    bash install-desc-ci.sh /opt/desc/py37 Miniconda3-py37_4.12.0-Linux-x86_64.sh && \
    which conda && \
    bash install-desc-ci.sh /opt/desc/py38 Miniconda3-py38_4.12.0-Linux-x86_64.sh && \
    which conda && \
    bash install-desc-ci.sh /opt/desc/py39 Miniconda3-py39_4.12.0-Linux-x86_64.sh && \
    cd /tmp && \
    rm -Rf desc-python
    
#USER root

#RUN ln -s /opt/desc/py /usr/local/py

#USER lsst
    
ENV HDF5_USE_FILE_LOCKING FALSE
ENV PYTHONSTARTUP ''

# echo "source /opt/desc/py/etc/profile.d/conda.sh" >> ~/.bashrc && \
# echo "conda activate base" >> ~/.bashrc && \
#ENV PATH="${DESC_PYTHON_DIR}:${PATH}"


CMD ["/bin/bash"]
