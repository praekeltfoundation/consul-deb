#!/bin/bash -e

# Standalone build file for building without Sideloader
export REPO_DIR="$(pwd)"

# Create the workspace
mkdir -p workspace
cd workspace
export WORKSPACE="$(pwd)"

# Build
$REPO_DIR/build.sh

# Wrap the postinstall script
echo "#!/bin/sh -e" > ./postinstall.sh
cat $REPO_DIR/postinstall.sh >> ./postinstall.sh
chmod 0755 ./postinstall.sh

# Run fpm
fpm -s dir -t deb -a amd64 -n consul -v 0.6.0 --after-install $WORKSPACE/postinstall.sh --prefix / *
