#!/bin/bash
# Create Secure Login tutorial completed app.
# Required variables:
#   ${ARCHETYPE_ARTIFACT_ID}=Artifact ID of blank project's archetype.
#   ${ARCHETYPE_VERSION}=Version of blank project's archetype.
#   ${VERSION}=Version of tutorial project.
#   ${HOST_IP}=IP address for access to this web application. Defaults to 'localhost'.
#   ${APSRV_WEB_PORT}=Port number for access to this web application. Defaults to '8080'.
#   ${APSRV_H2DB_PORT}=Port number for access to H2DB. Defaults to '9212'.

case "$ARCHETYPE_ARTIFACT_ID" in
    terasoluna-gfw-multi-web-blank-mybatis3-archetype )
        export GROUP_ID=com.example.securelogin
        export ARTIFACT_ID=secure-login
        ;;
    * )
        echo "You can not select the specified ARCHETYPE_ARTIFACT_ID."
        exit 1
        ;;
esac

echo "create groupId is ${GROUP_ID}."
echo "create artifactId is ${ARTIFACT_ID}."
echo "create version is ${VERSION}."

SCRIPT_DIR=`dirname "$0"`
TARGET_DIR=${SCRIPT_DIR}/../target-project

# create dir for work
rm -rf "${TARGET_DIR}/${ARTIFACT_ID}"
mkdir "$TARGET_DIR"
pushd "$TARGET_DIR"

if test -z $HOST_IP; then
  export HOST_IP=localhost
fi

if test -z $APSRV_WEB_PORT; then
  export APSRV_WEB_PORT=8080
fi

if test -z $APSRV_H2DB_PORT; then
  export APSRV_H2DB_PORT=9212
fi

bash ../../common/scripts/generate-project.sh

bash ../scripts/copy-sources.sh

bash ../scripts/convert-secure-login-xml.sh `pwd`

bash ../scripts/convert-secure-login-jsp.sh `pwd`

bash ../scripts/convert-secure-login-infra.sh `pwd`

bash ../scripts/convert-secure-login-properties.sh `pwd`

bash ../scripts/convert-secure-login-css.sh `pwd`

bash ../scripts/convert-secure-login-test.sh `pwd`

popd
