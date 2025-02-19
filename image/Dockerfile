ARG FROM_IMAGE
FROM $FROM_IMAGE

RUN yum -y install gnuplot ImageMagick

### Arguments that can be set at runtime, possibly with defaults
#
# Installer account -  UID/GID can be overridden if need be
ARG IA_USER_ID=7365
ARG IA_GROUP_ID=7365
# Local user account. No default: prefer to fail rather than assign badly.
ARG LU_USER_ID
ARG LU_GROUP_ID
#
## Specific versions of codebases that are needed by the AD2 code
## These should be compressed archives (e.g., .zip or .tgz)
ARG MGL_Tools='./AAD2_Dependencies/MGL_Tools'
ARG Vina_Carb='./AAD2_Dependencies/VC_1_0'
ARG AAD2_GLYLIB='./AAD2_Dependencies/AAD2_GLYLIB'
ARG AAD2_Code='AAD2'
ARG Python2='./AAD2_Dependencies/Python-2.7.8'
# 
## Expected directory names for the uncompressed source code
ARG D_MGL_Tools=MGL_Tools
ARG D_Vina_Carb=VC_1_0
ARG D_AAD2_GLYLIB=AAD2_GLYLIB
ARG D_AAD2_Code=AAD2
ARG D_Python2='Python-2.7.8'
#

### Prepare the system
#
## Uncompress and add the needed source code
COPY ${Python2} /programs/src/${D_Python2}/
COPY ${MGL_Tools} /programs/src/${D_MGL_Tools}/
COPY ${Vina_Carb} /programs/src/${D_Vina_Carb}/
COPY ${AAD2_GLYLIB} /programs/src/${D_AAD2_GLYLIB}/
COPY ${AAD2_Code} /programs/src/${D_AAD2_Code}/
#
## Create the installer account
RUN groupadd \
        --gid $IA_GROUP_ID -o \
        installer \
    && \
    useradd \
        --home-dir /home/installer -o \
        --shell /bin/bash \
        --create-home \
        --uid $IA_USER_ID \
        --gid $IA_GROUP_ID \
        installer ;
## Create the local user
RUN groupadd \
        --gid $LU_GROUP_ID -o \
        antibodydocking \
    && \
    useradd \
        --home-dir /home/antibodydocking -o \
        --shell /bin/bash \
        --create-home \
        --uid $LU_USER_ID \
        --gid $LU_GROUP_ID \
        antibodydocking ;
#
## Make directories with needed ownerships
RUN mkdir /programs/bin /programs/include /programs/lib && chown -R ${IA_USER_ID}:${IA_GROUP_ID} /programs

## Become antibodydocking
USER antibodydocking
RUN echo 'export PATH=/programs/bin:$PATH' >> /home/antibodydocking/.bashrc
RUN echo 'export PYTHON_HOME=/programs/include/python2.7' >> /home/antibodydocking/.bashrc
RUN echo 'export CPLUS_INCLUDE_PATH=/opt/boost_1.41.0/include' >> /home/antibodydocking/.bashrc
RUN echo 'export VINA_CARB=/programs/src/VC_1_0' >> /home/antibodydocking/.bashrc

## Become installer
USER installer 
RUN echo 'export PATH=/programs/bin:$PATH' >> /home/installer/.bashrc
RUN echo 'export PYTHON_HOME=/programs/include/python2.7' >> /home/installer/.bashrc
RUN echo 'export CPLUS_INCLUDE_PATH=/opt/boost_1.41.0/include' >> /home/installer/.bashrc
RUN echo 'export VINA_CARB=/programs/src/VC_1_0' >> /home/installer/.bashrc


### Install the software
#
## Python 2.7
RUN cd /programs/src/Python-2.7.8 \
    && ./configure --prefix=/programs \
    && make \
    && make install  
## MGL Tools
RUN export PYTHON_HOME="/programs/include/python2.7" \
    && export PATH=/programs/bin:$PATH \
    && cd /programs/src/${D_MGL_Tools} && ./install.sh -d /programs
## vina carb
RUN cp /programs/src/${D_Vina_Carb}/autodock_vina_1_1_2/build/linux/release/vina-carb /programs/bin/
## GLYLIB
RUN cd /programs/src/${D_AAD2_GLYLIB}/lib && make && cp libglylib.a /programs/lib
## Automated Antibody Docking 2
RUN cd /programs/src/${AAD2_Code} && ./Compile && ./Install /programs

