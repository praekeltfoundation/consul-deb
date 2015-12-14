#!/bin/bash -e

PROJECT="consul"
VERSION="0.6.0"
PLATFORM="linux_amd64"
BASE_URL="https://releases.hashicorp.com/$PROJECT/$VERSION"

BIN_DIR=/usr/bin
EMPTY_DIRS=( /var/run/consul /var/lib/consul /etc/consul.d )

function download_release_file() {
    echo "Downloading file '$1'..."
    curl -s -o $1 "$BASE_URL/$1"
}

echo "Downloading signature files..."
SHA_FILE="${PROJECT}_${VERSION}_SHA256SUMS"
SHA_SIG_FILE="$SHA_FILE.sig"
download_release_file $SHA_FILE
download_release_file $SHA_SIG_FILE

echo "Verifying $SHA_FILE signature..."
gpg --verify $SHA_SIG_FILE

ZIP_FILE="${PROJECT}_${VERSION}_${PLATFORM}.zip"
if [ ! -f $ZIP_FILE ]; then
    download_release_file $ZIP_FILE
else
    echo "File $ZIP_FILE found, not downloading."
fi

echo "Verifying $ZIP_FILE hash..."
grep $ZIP_FILE $SHA_FILE > sha256sum.txt
sha256sum -c sha256sum.txt

echo "Extracting $ZIP_FILE contents..."
unzip -qo $ZIP_FILE

# Move contents to correct location in package
# Hack sideloader to not build things in /var/praekelt - install files straight into the package directory
PACKAGE_DIR=$WORKSPACE/package
mkdir -p $PACKAGE_DIR
mkdir -p $PACKAGE_DIR$BIN_DIR
# Move the binary in to place
mv ./$PROJECT $PACKAGE_DIR$BIN_DIR
# Copy the package files
cp -r $(pwd)/$REPO/package/* $PACKAGE_DIR

# Create misc empty directories
for path in $EMPTY_DIRS; do
    mkdir -p $PACKAGE_DIR$path
done
