#!/usr/bin/env bash

#### General settings

export FROM_IMAGE="thecoulter/boost-1.41_gcc-4.4.7:latest"
export AD_BUILD_PROCS="4"
export IA_USER_ID="7365"
export IA_GROUP_ID="7365"
export LU_USER_ID="$( id -u )"
export LU_GROUP_ID="$( id -g )"

export ImageName="antibody-docking"
export ImageTag="2025-02-19-03-12-blf"

#### Optional settings customization
# Create a file called Local_Settings.bash to override the settings above
if [ -e "Local_Settings.bash" ] ; then
	. Local_Settings.bash
fi

