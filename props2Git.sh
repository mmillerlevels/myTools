#!/bin/bash

GIT=`which git`
REPO_DIR=/reachengine/propBkps/
cd ${REPO_DIR}
${GIT} add --all .
${GIT} commit -m "Daily Update"
${GIT} push git@github:username/repo.git master
