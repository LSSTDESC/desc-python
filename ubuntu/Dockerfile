FROM ubuntu:20.04
MAINTAINER heather@slac.stanford.edu

#ARG PR_BRANCH=bleed

# Basic compilers and tools dependencies
RUN apt-get update -y && DEBIAN_FRONTEND="noninteractive" apt-get install -y gcc g++ gfortran \
    cmake swig wget make libopenblas-dev libchealpix-dev \
    pkg-config curl python3 python3-distutils python3-dev python3-pip \
    libcfitsio-dev  libfftw3-dev   git  libgsl-dev autoconf libbz2-dev zsh \ 
    pkg-config time sed \
    && apt-get clean all

#RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 10
#RUN update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 10

# Manual installation of mpich seems to be required to work on NERSC
RUN echo $PWD && ls && mkdir /opt/mpich && cd /opt/mpich \
    && wget http://www.mpich.org/static/downloads/3.3.1/mpich-3.3.1.tar.gz \
    && tar xvzf mpich-3.3.1.tar.gz &&  cd mpich-3.3.1 && ./configure --disable-wrapper-rpath && make -j4 \
    && make install && rm -rf /opt/mpich

# Need to install manually because we want MPI-enabled version
RUN mkdir /opt/hdf && cd /opt/hdf \
    && wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.12/hdf5-1.12.0/src/hdf5-1.12.0.tar.gz \
    && tar xvf hdf5-1.12.0.tar.gz \
    && cd hdf5-1.12.0 \
    && ./configure --enable-parallel --prefix=/usr/local CC=mpicc \
    && make \
    && make install \
    && rm -rf /opt/hdf


# Some env vars
ENV HDF5_MPI ON
ENV HDF5_USE_FILE_LOCKING FALSE
ENV LD_LIBRARY_PATH /usr/local/lib
ENV C_INCLUDE_PATH /usr/local/include

RUN groupadd -g 1000 -r lsst && useradd -u 1000 --no-log-init -m -r -g lsst lsst && \
# #   cd /tmp && \
# #   git clone https://github.com/LSSTDESC/desc-python && \
# #   cd desc-python && \ 
# #   git checkout $PR_BRANCH && \
    cd conda && \
    bash install-desc.sh /opt/desc/py desc-python-env.yml NERSC 
#    cd /tmp && \
#    rm -Rf desc-python
    
# Also need a manual install of mpi4py so that it uses the right libraries - pip seems not to work
#RUN pip install -vv --no-binary=mpi4py mpi4py
    
ENV PYTHONSTARTUP ''


# Install h5py, recompiling so that we use HDF5 with MPI
#RUN pip install --no-cache-dir --no-binary=h5py h5py==3.1.0




# Holding cuda stuff off for now
#RUN apt-get update -y \
#    && apt-get install -y libpulse-mainloop-glib0 \
#    && apt-get clean all

#RUN apt-get update -y \
#    && apt-get install -y nvidia-cuda-dev \
#    && apt-get clean all

#RUN apt-get update -y \
#    && apt-get install -y nvidia-cuda-toolkit \
#    && apt-get clean all

#RUN pip install --no-cache-dir cupy-cuda101


