#!/bin/bash


export mpich=4.0.3
export mpich_prefix=mpich-$mpich

curl -LO https://www.mpich.org/static/downloads/$mpich/$mpich_prefix.tar.gz 
tar xvzf $mpich_prefix.tar.gz                                      
cd $mpich_prefix                                                        
unset F90
unset F90FLAGS
export FFLAGS=-fallow-argument-mismatch
export FCFLAGS=-fallow-argument-mismatch
./configure -with-device=ch4:ofi --disable-f08 --disable-collalgo-tests                                                        
make -j 4                                                               
make install                                                           
make clean                                                        
cd ..                                                              
rm -rf $mpich_prefix
rm $mpich_prefix.tar.gz 
/sbin/ldconfig

