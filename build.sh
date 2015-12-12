#!/bin/bash -e

VERSION="0.6.0"
ZIP_FILE="consul_${VERSION}_linux_amd64.zip"
BIN_DIR=/usr/bin

if ! [ -f $ZIP_FILE ]; then
    echo "Downloading file $ZIP_FILE..."
    curl -sL -o $ZIP_FILE "https://releases.hashicorp.com/consul/$VERSION/$ZIP_FILE"
else
    echo "File $ZIP_FILE found, not downloading."
fi

echo "Verifying $ZIP_FILE signature..."
REPO_DIR="$(pwd)/$REPO"
cp $REPO_DIR/sha256sum.txt .
sha256sum -c sha256sum.txt

echo "Extracting $ZIP_FILE contents..."
unzip -qo $ZIP_FILE

# Move contents to correct location in package
# Hack sideloader to not build things in /var/praekelt - install files straight into the package directory
PACKAGE_DIR=$WORKSPACE/package
mkdir -p $PACKAGE_DIR
mkdir -p $PACKAGE_DIR$BIN_DIR
cp ./consul $PACKAGE_DIR$BIN_DIR
cp -r $REPO_DIR/etc $PACKAGE_DIR

# Create misc empty directories
for path in /var/run/consul /var/lib/consul /etc/consul.d; do
    mkdir -p $PACKAGE_DIR$path
done
