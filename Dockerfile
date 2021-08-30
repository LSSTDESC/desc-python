FROM centos:7
MAINTAINER Heather Kelly <heather@slac.stanford.edu>

ARG PR_BRANCH=bleed

RUN yum update -y && \
    yum install -y bash \
    bison \
    blas \
    bzip2 \
    bzip2-devel \
    cmake \
    curl \
    dvipng \
    flex \
    fontconfig \
    freetype-devel \
    gawk \
    gcc-c++ \
    gcc-gfortran \
    gettext \
    git \
    glib2-devel \
    java-1.8.0-openjdk \
    libcurl-devel \
    libuuid-devel \
    libXext \
    libXrender \
    libXt-devel \
    make \
    mesa-libGL \
    ncurses-devel \
    openssl-devel \
    patch  \
    perl \
    perl-ExtUtils-MakeMaker \
    readline-devel \
    sed \
    tar \
    texlive \
    time \
    which \
    zlib-devel \
    zsh
    
RUN yum clean -y all && \
    rm -rf /var/cache/yum && \
    groupadd -g 1000 -r lsst && useradd -u 1000 --no-log-init -m -r -g lsst lsst && \
    cd /tmp && \
    git clone https://github.com/LSSTDESC/desc-python && \
    cd desc-python && \ 
    git checkout $PR_BRANCH && \
    cd conda && \
    bash install-desc.sh /usr/local/py desc-python-env.yml NERSC && \
    cd /tmp && \
    rm -Rf desc-python
    
ENV HDF5_USE_FILE_LOCKING FALSE
ENV PYTHONSTARTUP ''
