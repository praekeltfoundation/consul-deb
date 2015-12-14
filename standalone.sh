#!/bin/bash -e

# Standalone build file for building without Sideloader. Expects to be run from
# the root of the repo and will create a 'workspace' directory within the repo
# in which to run the build.

NAME="consul"
VERSION="0.6.0"
BUILDSCRIPT="build.sh"
POSTINSTALL="postinstall.sh"

export REPO_DIR="$(pwd)"

# Create the workspace
mkdir -p workspace
cd workspace
export WORKSPACE="$(pwd)"

# Build
"$REPO_DIR/$BUILDSCRIPT"

# Wrap the postinstall script and make it executable
echo "#!/bin/sh -e" > ./postinstall.sh
cat "$REPO_DIR/$POSTINSTALL" >> ./postinstall.sh
chmod 0755 ./postinstall.sh

# Run fpm
cd package
fpm -f -s dir -t deb -a amd64 -n $NAME -v $VERSION --after-install $WORKSPACE/postinstall.sh --prefix / *
