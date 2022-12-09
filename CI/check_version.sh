#!/bin/bash
# DCMS check_version.sh
set -e

# A local or jenkins builder will call this script from the root of the checked out git repo
# Another build mechanism might copy files to another directory before modifying them
if [ $# -eq 0 ];
# $D is root directory of files to be injected, assuming they have the same relative structure as the original repository
    then
        D=$PWD   # Assume we are in project root calling "./CI/inject_version.sh"
    else
        D=$1     # If argument given, that is new root dir of file to be injected. 
fi

REPO_DIR="$(dirname $0)/../"

VERSION_SOURCE="${D}/overrides/partials/footer.html"

FILES="$VERSION_SOURCE"
MISSING=""

for FILE in $FILES
do
    if [ ! -f $FILE ]; then
        echo "File not found: $FILE";
        MISSING="$MISSING $FILE";
    fi
done

# Previous version
V0=``
git show HEAD~1:overrides/partials/footer.html | grep -oE "([0-9]+)(nd|st) Edition, Revision ([0-9]+)" | grep -oE "([0-9]+)"

# New version
V1=`cat overrides/partials/footer.html | grep -oE "([0-9]+)(nd|st) Edition, Revision ([0-9]+)" | grep -oE "([0-9]+)")`

function version { echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'; }

if [ $(version $V1) -le $(version $V0) ]; then
    printf "Please increment version number\nPrevious: $V0\nCurrent: $V1\n"
    exit 1
fi

echo ${V1}


