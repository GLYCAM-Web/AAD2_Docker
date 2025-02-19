#!/usr/bin/env bash

#### General settings
source ./settings.bash

COMMAND="""docker exec \
    -it \
    -u installer \
    ad_coder_temp \
    bash"""

echo "Attaching to an existing container with this command:
${COMMAND}
"
( eval ${COMMAND} ) || {  echo "error attaching to ad container" && exit 1 ; }

