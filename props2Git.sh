#!/bin/bash

#Things
GIT=`which git`
REPO_DIR=/reachengine/propBkps/

#Grab the latest files we want
/bin/cat /reachengine/tomcat/conf/context.xml > ${REPO_DIR}context.xml
/bin/cat /reachengine/tomcat/lib/dynamic.reach-engine.properties > ${REPO_DIR}dynamic.reach-engine.properties
/bin/cat /reachengine/tomcat/lib/localContext.xml > ${REPO_DIR}localContext.xml
/bin/cat /reachengine/tomcat/lib/log4j.properties > ${REPO_DIR}log4j.properties
/bin/cat /reachengine/tomcat/lib/local.reach-engine.properties > ${REPO_DIR}local.reach-engine.properties
/bin/cat /reachengine/tomcat/conf/server.xml > ${REPO_DIR}server.xml
/bin/cat /reachengine/wfruntime/conf/local-applicationContext.xml > ${REPO_DIR}local-applicationContext.xml
/bin/cat /reachengine/wfruntime/conf/dynamic.wferuntime.properties > ${REPO_DIR}dynamic.wferuntime.properties
/bin/cat /reachengine/wfruntime/conf/log4j.properties > ${REPO_DIR}log4j.properties
/bin/cat /reachengine/wfruntime/conf/local.wferuntime.properties > ${REPO_DIR}local.wferuntime.properties

echo "Update Done!  `date`" >> ${REPO_DIR}commitLog.log

#Do the git stuff
cd ${REPO_DIR}
${GIT} add --all .
${GIT} commit -m "Daily Update"
${GIT} push git@github.com:username/repo.git master
