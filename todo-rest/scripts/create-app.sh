#!/bin/bash
# Create Todo(REST) tutorial completed app.
# Required variables:
#   ${ARCHETYPE_ARTIFACT_ID}=Artifact ID of blank project's archetype.
#   ${ARCHETYPE_VERSION}=Version of blank project's archetype.
#   ${VERSION}=Version of tutorial project.

case "$ARCHETYPE_ARTIFACT_ID" in
    terasoluna-gfw-web-blank-archetype )
        export GROUP_ID=com.example.todo
        export ARTIFACT_ID=todo-api
        ;;
    terasoluna-gfw-web-blank-mybatis3-archetype )
        export GROUP_ID=com.example.todo
        export ARTIFACT_ID=todo-api-mybatis3
        ;;
    terasoluna-gfw-multi-web-blank-mybatis3-archetype )
        export GROUP_ID=com.example.todo
        export ARTIFACT_ID=todo-api-mybatis3-multi
        ;;
    terasoluna-gfw-web-blank-jpa-archetype )
        export GROUP_ID=com.example.todo
        export ARTIFACT_ID=todo-api-jpa
        ;;
    terasoluna-gfw-multi-web-blank-jpa-archetype )
        export GROUP_ID=com.example.todo
        export ARTIFACT_ID=todo-api-jpa-multi
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

bash ../../common/scripts/generate-project.sh

bash ../scripts/copy-sources.sh

bash ../scripts/convert-rest-test.sh `pwd`

case "$ARCHETYPE_ARTIFACT_ID" in
    *mybatis2* | *jpa* ) bash ../../todo/scripts/convert-todo-infra.sh `pwd` ;;
    * ) ;;
esac

bash ../scripts/convert-rest-java.sh `pwd`

bash ../scripts/convert-rest-msg.sh `pwd`

bash ../scripts/convert-rest-xml.sh `pwd`

popd
