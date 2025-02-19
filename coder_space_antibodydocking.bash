#!/usr/bin/env bash

#### General settings
source ./settings.bash
Container_Dir="/programs/code-temp"

if [ "${1}zzz" == "zzz" ] ; then
	Host_Dir="$(pwd)"
	echo "No local directory specified. Mounting the current directory"
else
	Host_Dir="${1}"
fi

echo """This directory on the host:

    ${Host_Dir}

Will be mounted into the container at:

    ${Container_Dir}
"""

COMMAND="""docker run \
    --rm -it \
    -u antibodydocking \
    --name ad_coder_temp \
    --mount \
    type=bind,src=${Host_Dir},dst=${Container_Dir} \
    ${ImageName}:${ImageTag} \
    bash"""

echo "Starting a container with this command:
${COMMAND}
"
( eval ${COMMAND} ) || {  echo "error starting ad container" && exit 1 ; }

