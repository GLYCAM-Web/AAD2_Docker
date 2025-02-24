#!/usr/bin/env bash

USAGE="""
Usage: 

        ${0} <ImageName:ImageTag> 

	This script checks to see whether the specified image is available.
"""

if [ -z "${1}" ] ; then
	echo "Must supply image information. Exiting."
	echo "${USAGE}"
	exit 1
fi

does_image_exist() {
        if [ "$( docker images --format {{.Repository}}:{{.Tag}} | grep -c ${1} )" -eq "0" ]; then
                return 1
        fi
        return 0
}


if does_image_exist "${1}" ; then
    echo "The specified image is available."
else
    echo "The specified image:
    ${1}
is not avaiable."
fi
