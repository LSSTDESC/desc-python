FROM ubuntu:22.04
MAINTAINER Heather Kelly <heather@slac.stanford.edu>

ARG PR_BRANCH=bleed

ARG DESC_PYTHON_DIR=/opt/desc

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
    mkdir /opt/tmp && cd /opt/tmp && \
    git clone https://github.com/LSSTDESC/desc-python && \
    cd desc-python && \
    git checkout $PR_BRANCH && \
    cd conda && \ 
    bash install-mpich.sh && \
    cd /opt/tmp && \
    chown -R lsst desc-python && \ 
    mkdir -p $DESC_PYTHON_DIR && \
    chown lsst $DESC_PYTHON_DIR && \
    chgrp lsst $DESC_PYTHON_DIR

ARG LSST_USER=lsst
ARG LSST_GROUP=lsst


WORKDIR $DESC_PYTHON_DIR
   
USER lsst

ENV PYTHONDONTWRITEBYTECODE 1

RUN cd /opt/tmp/desc-python/conda && \ 
    bash install-desc.sh /opt/desc/py conda-pack.txt pip-pack.txt NERSC && \
    find /$DESC_PYTHON_DIR -name "*.pyc" -delete && \
    (find $DESC_PYTHON_DIR -name "doc" | xargs rm -Rf) || true && \
    (find $DESC_PYTHON_DIR -name "*.so" ! -path "*/xpa/*" | xargs strip -s -p) || true 
#    cd /opt/tmp && \
#    rm -Rf desc-python 
    
USER root

RUN ln -s /opt/desc/py /usr/local/py

USER lsst
    
ENV HDF5_USE_FILE_LOCKING FALSE
ENV PYTHONSTARTUP ''


RUN echo "source /opt/desc/py/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc
    
ENV PATH="${DESC_PYTHON_DIR}/${PY_VER}/bin:${PATH}"
SHELL ["/bin/bash", "--login", "-c"]


# echo "source /opt/desc/py/etc/profile.d/conda.sh" >> ~/.bashrc && \
# echo "conda activate base" >> ~/.bashrc && \
#ENV PATH="${DESC_PYTHON_DIR}:${PATH}"


#CMD ["/bin/bash"]
