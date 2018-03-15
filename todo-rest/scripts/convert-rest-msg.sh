#!/bin/bash
# Convert message resource(s) on blank project.
# Parameters:
#   $1 : (Optional) Target project path to convert.

TARGET_DIR=$1
if test -n $TARGET_DIR; then
  pushd "${TARGET_DIR}/${ARTIFACT_ID}"
fi

# application-message.properties
for i in ` find ./ -type f -name 'application-messages.properties' `; do echo -e ' 
# For this tutorial
E001 = [E001] The count of un-finished Todo must not be over {0}.
E002 = [E002] The requested Todo is already finished. (id={0})
E400 = [E400] The requested Todo contains invalid values.
E404 = [E404] The requested Todo is not found. (id={0})
E500 = [E500] System error occurred.
E999 = [E999] Error occurred. Caused by : {0}
' >> $i ;done

# ValidationMessages.properties
for i in ` find ./ -type f -name 'ValidationMessages.properties' `; do echo -e ' 
javax.validation.constraints.NotNull.message = {0} may not be null.
javax.validation.constraints.Size.message    = {0} size must be between {min} and {max}.
' >> $i ;done

if test -n $TARGET_DIR; then
  popd
fi
