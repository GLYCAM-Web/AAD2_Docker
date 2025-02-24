#!/usr/bin/env bash

USAGE="""
Usage: 

        ${0} <ImageName:ImageTag> [/path/to/output/dir/]

	If a path to an output directory is not provided, the image will be saved to a file in the 
	current working directory.

	The format of the name will be: 

	    ImageName.ImageTag.tar

	Use of the accompanying image-loading script will expect this format.
"""

if [ -z "${1}" ] ; then
	echo "Must supply image information. Exiting."
	echo "${USAGE}"
	exit 1
fi

if [ -z "${2}" ] ; then
	ImagePath="$(pwd)"
else
	ImagePath="${2}"
fi
#echo "Setting output directory to: ${ImagePath}"
filename="${ImagePath}/${1//:/$'.'}.tar"
echo "Setting output filename (with path) to:
    ${filename}"

does_image_exist() {
        if [ "$( docker images --format {{.Repository}}:{{.Tag}} | grep -c ${1} )" -eq "0" ]; then
                return 1
        fi
        return 0
}


if does_image_exist "${1}" ; then
    echo "The specified image is available. Saving."
    docker save -o ${filename} ${1}
else
    echo "The specified image:
    ${1}
is not available. Unable to save."
fi
