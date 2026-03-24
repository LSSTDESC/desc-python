# Build container
FROM continuumio/miniconda3:latest as conda

ARG DESC_PYTHON_DIR=/opt/desc
ENV PYTHONDONTWRITEBYTECODE 1
ADD conda/desc-py-bleed-lock.yml /locks/conda-linux-64.lock
RUN conda create -p $DESC_PYTHON_DIR --copy --file /locks/conda-linux-64.lock && \
    find /$DESC_PYTHON_DIR -name "*.pyc" -delete && \
    (find $DESC_PYTHON_DIR -name "doc" | xargs rm -Rf) || true

FROM ubuntu:22.04
MAINTAINER Heather Kelly <heather@slac.stanford.edu>

ARG DESC_PYTHON_DIR=/opt/desc

COPY --from=conda $DESC_PYTHON_DIR $DESC_PYTHON_DIR

#ARG PR_BRANCH=bleed

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
    cd conda
    bash install-mpich.sh 

ARG LSST_USER=lsst
ARG LSST_GROUP=lsst


#WORKDIR $DESC_PYTHON_DIR
   
USER lsst

ENV PYTHONDONTWRITEBYTECODE 1

#RUN cd /opt/tmp/desc-python/conda && \ 
#    bash install-desc.sh /opt/desc/py conda-pack.txt pip-pack.txt NERSC && \
#    find /$DESC_PYTHON_DIR -name "*.pyc" -delete && \
#    (find $DESC_PYTHON_DIR -name "doc" | xargs rm -Rf) || true
    
#USER root

#RUN ln -s /opt/desc/py /usr/local/py

#USER lsst
    
ENV HDF5_USE_FILE_LOCKING FALSE
ENV PYTHONSTARTUP ''


RUN echo "source /opt/desc/py/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc
    
ENV PATH="${DESC_PYTHON_DIR}/${PY_VER}/bin:${PATH}"
SHELL ["/bin/bash", "--login", "-c"]


