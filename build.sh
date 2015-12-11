#!/bin/bash -e

VERSION="0.6.0"
ZIP_FILE="consul_${VERSION}_linux_amd64.zip"

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
BUILD_DIR="$(pwd)/$BUILDDIR"
mkdir -p $BUILD_DIR/usr/local/bin
cp ./consul $BUILD_DIR/usr/local/bin
cp -r $REPO_DIR/etc $BUILD_DIR
