#!/bin/bash

stripPWD() {
    if ! ${WORKING_DIRECTORY+false};
    then
        cd - > /dev/null
    fi
    sed -E "s/$(pwd|sed 's/\//\\\//g')\///"
}

convertToGitHubActionsLoggingCommands() {
    sed -E 's/^(.*):([0-9]+):([0-9]+): (warning|error|[^:]+): (.*)/::\4 file=\1,line=\2,col=\3::\5/'
}

if [ -n "${CHANGED_FILES}" ]; then
    set -o pipefail && swiftlint $LINT_PARAMETERS -- $CHANGED_FILES | stripPWD | convertToGitHubActionsLoggingCommands
else
    echo "No Swift files changed"
fi
