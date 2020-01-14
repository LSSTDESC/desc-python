FROM centos:7
MAINTAINER Heather Kelly <heather@slac.stanford.edu>

RUN yum update -y && \
    yum install -y bash && \
    bison && \
    blas && \
    bzip2 && \
    bzip2-devel && \
    cmake && \
    curl && \
    flex && \
    fontconfig && \
    freetype-devel && \
    gawk && \
    gcc-c++ && \
    gcc-gfortran && \
    gettext && \
    git && \
    glib2-devel && \
    java-1.8.0-openjdk && \
    libcurl-devel && \
    libuuid-devel && \
    libXext && \
    libXrender && \
    libXt-devel && \
    make && \
    mesa-libGL && \
    ncurses-devel && \
    openssl-devel && \
    patch && \
    perl && \
    perl-ExtUtils-MakeMaker && \
    readline-devel && \
    sed && \
    tar && \
    which && \
    zlib-devel && \
    devtoolset-6
    
RUN yum clean -y all && \
    rm -rf /var/cache/yum && \
    groupadd -g 1000 -r lsst && useradd -u 1000 --no-log-init -m -r -g lsst lsst
    
USER lsst

RUN curl -sSL https://repo.continuum.io/miniconda/Miniconda3-4.7.12.1-Linux-x86_64.sh -o /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -bfp /usr/local/ && \
    rm -rf /tmp/miniconda.sh && \
    conda install -y python=3 && \
    conda update conda && \
    conda clean --all --yes 
