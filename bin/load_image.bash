#!/usr/bin/env bash

USAGE="""
Usage: 

        ${0} <ImageName:ImageTag> [/path/to/images/dir/]

	If a path to an images directory is not provided, the script will look for the image will in the 
	current working directory.

	The format of the name will be: 

	    ImageName.ImageTag.tar

	The accompanying image-saving script will use this format.
"""

if [ -z "${1}" ] ; then
	echo "Must supply image information. Exiting."
	echo "${USAGE}"
	exit 1
fi

does_image_exist() {

does_image_exist() {
        if [ "$( docker images --format {{.Repository}}:{{.Tag}} | grep -c ${1} )" -eq "0" ]; then
                return 1
        fi
        return 0
}

if [ -z "${2}" ] ; then
	ImagePath="$(pwd)"
else
	ImagePath="${2}"
fi
filename="${ImagePath}/${1//:/$'.'}.tar"
#echo "Looking for image to load at: ${filename}"


if does_image_exist "${1}" ; then
    echo "The required image is already available. Not loading."
else
    echo "Loading image from file:
    ${filename}"
    docker load -i ${filename}
fi
