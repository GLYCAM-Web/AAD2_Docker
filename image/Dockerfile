ARG FROM_IMAGE
FROM $FROM_IMAGE

RUN yum -y install gnuplot ImageMagick

### Arguments that can be set at runtime, possibly with defaults
#
# Installer account -  UID/GID can be overridden if need be
ARG IA_USER_ID=7365
ARG IA_GROUP_ID=7365
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

RUN mkdir /programs && chown -R ${IA_USER_ID}:${IA_GROUP_ID} /programs

## Become installer
USER installer 
RUN echo 'export PATH=/programs/bin:$PATH' >> /home/installer/.bashrc
RUN echo 'export PYTHON_HOME=/programs/include/python2.7' >> /home/installer/.bashrc
RUN echo 'export CPLUS_INCLUDE_PATH=/opt/boost_1.41.0/include' >> /home/installer/.bashrc
RUN echo 'export VINA_CARB=/programs/src/VC_1_0' >> /home/installer/.bashrc

RUN mkdir /programs/bin /programs/include /programs/lib /programs/src
### Install the software
#
## Python 2.7
ARG Python2='./AAD2_Dependencies/Python-2.7.8'
ARG D_Python2='Python-2.7.8'
COPY --chown=installer:installer ${Python2} /programs/src/${D_Python2}/
RUN cd /programs/src/${D_Python2} \
    && ./configure --prefix=/programs \
    && make \
    && make install  
#
## MGL Tools
ARG MGL_Tools='./AAD2_Dependencies/MGL_Tools'
ARG D_MGL_Tools=MGL_Tools
COPY --chown=installer:installer ${MGL_Tools} /programs/src/${D_MGL_Tools}/
RUN export PYTHON_HOME="/programs/include/python2.7" \
    && export PATH=/programs/bin:$PATH \
    && cd /programs/src/${D_MGL_Tools} && ./install.sh -d /programs
#
## vina carb
ARG Vina_Carb='./AAD2_Dependencies/VC_1_0'
ARG D_Vina_Carb=VC_1_0
COPY --chown=installer:installer ${Vina_Carb} /programs/src/${D_Vina_Carb}/
RUN cp /programs/src/${D_Vina_Carb}/autodock_vina_1_1_2/build/linux/release/vina-carb /programs/bin/
#
## GLYLIB
ARG AAD2_GLYLIB='./AAD2_Dependencies/AAD2_GLYLIB'
ARG D_AAD2_GLYLIB=AAD2_GLYLIB
COPY --chown=installer:installer ${AAD2_GLYLIB} /programs/src/${D_AAD2_GLYLIB}/
RUN cd /programs/src/${D_AAD2_GLYLIB}/lib && make && cp libglylib.a /programs/lib
#
## Automated Antibody Docking 2
ARG AAD2_Code='AAD2'
ARG D_AAD2_Code=AAD2
COPY --chown=installer:installer ${AAD2_Code} /programs/src/${D_AAD2_Code}/
RUN cd /programs/src/${AAD2_Code} && ./Compile && ./Install /programs

USER root

# Local user account. No default: prefer to fail rather than assign badly.
ARG LU_USER_ID
ARG LU_GROUP_ID
#
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

## Become antibodydocking
USER antibodydocking
RUN echo 'export PATH=/programs/bin:$PATH' >> /home/antibodydocking/.bashrc
RUN echo 'export PYTHON_HOME=/programs/include/python2.7' >> /home/antibodydocking/.bashrc
RUN echo 'export CPLUS_INCLUDE_PATH=/opt/boost_1.41.0/include' >> /home/antibodydocking/.bashrc
RUN echo 'export VINA_CARB=/programs/src/VC_1_0' >> /home/antibodydocking/.bashrc

