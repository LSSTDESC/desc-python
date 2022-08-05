ARG OS_VER=20.04
FROM ubuntu:$OS_VER
MAINTAINER Heather Kelly <heather@slac.stanford.edu>

ARG DESC_PYTHON_DIR=/opt/desc

ARG PY_VER

WORKDIR $DESC_PYTHON_DIR

RUN apt update -y && \
    apt install -y curl \
    build-essential \
    gfortran \
    git \
    patch \
    wget && \
    apt-get clean  && \
    rm -rf /var/cache/apt && \
    usermod --shell /bin/bash root && \
    mkdir -p $DESC_PYTHON_DIR && \
    cd /tmp && \
    git clone https://github.com/LSSTDESC/desc-python && \
    cd desc-python && \
    cd conda && \ 
    bash install-mpich.sh && \
    cd /tmp 

#USER lsst

ENV PYTHONDONTWRITEBYTECODE 1

RUN cd /tmp/desc-python/docker && \ 
    bash install-desc-ci.sh /opt/desc/${PY_VER} Miniconda3-${PY_VER}_4.12.0-Linux-x86_64.sh && \
    find /opt/desc -name "*.pyc" -delete && \
    (find /opt/desc -name "doc" | xargs rm -Rf) || true && \
    (find /opt/desc -name "*.so" ! -path "*/xpa/*" | xargs strip -s -p) || true && \
    cd /tmp && \
    rm -Rf desc-python
    
    
ENV HDF5_USE_FILE_LOCKING FALSE
ENV PYTHONSTARTUP ''

RUN echo "source /opt/desc/$PY_VER/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc
    
ENV PATH="${DESC_PYTHON_DIR}/${PY_VER}/bin:${PATH}"
SHELL ["/bin/bash", "--login", "-c"]

#CMD ["/bin/bash"]
