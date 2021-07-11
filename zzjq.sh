#!/bin/bash
# install jq
set -e

ROOTDIR=${ZZROOT:-$HOME/app}
NAME="jq"
TYPE=".tar.gz"
FILE="$NAME$TYPE"
DOWNLOADURL="https://github.com/stedolan/jq/releases/download/jq-1.6/jq-1.6.tar.gz"
echo $NAME will be installed in "$ROOTDIR"

mkdir -p "$ROOTDIR/downloads"
cd "$ROOTDIR"

if [ -f "downloads/$FILE" ]; then
    echo "downloads/$FILE exist"
else
    echo "$FILE does not exist, downloading from $DOWNLOADURL"
    wget $DOWNLOADURL -O $FILE
    mv $FILE downloads/
fi

mkdir -p src/$NAME
tar xf downloads/$FILE -C src/$NAME --strip-components 1

cd src/$NAME

autoreconf -i
./configure --prefix="$ROOTDIR" --disable-maintainer-mode
make -j"$(nproc)" && make install

echo $NAME installed on "$ROOTDIR"
