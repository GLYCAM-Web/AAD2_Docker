#!/usr/bin/env bash

#### General settings
source ./settings.bash

if [ -z "${1}" ] ; then
        LU_WORKING_DIRECTORY="$(pwd)"
	echo "No local directory specified. Mounting the current directory"
else
        LU_WORKING_DIRECTORY="${1}"
fi

echo """This directory on the host:

    ${LU_WORKING_DIRECTORY}

Will be mounted into the container at:

    ${INTERNAL_WORKING_DIR}
"""

COMMAND="""docker run \
    --rm -it \
    -u antibodydocking \
    --name ad_coder_temp \
    --mount \
    type=bind,src=${LU_WORKING_DIRECTORY},dst=${INTERNAL_WORKING_DIR} \
    ${AAD2_IMAGE_NAME}:${AAD2_TAG_NAME} \
    bash"""

echo "Starting a container with this command:
${COMMAND}
"
eval ${COMMAND} 

