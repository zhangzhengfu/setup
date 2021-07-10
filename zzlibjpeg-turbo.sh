#!/bin/bash
# install libjpeg-turbo
set -e

ROOTDIR=${ZZROOT:-$HOME/app}
NAME="libjpeg-turbo"
TYPE=".tar.gz"
FILE="$NAME$TYPE"
DOWNLOADURL="https://ftp.osuosl.org/pub/blfs/conglomeration/libjpeg-turbo/libjpeg-turbo-2.0.4.tar.gz"
echo $NAME will be installed in "$ROOTDIR"
echo Dependency: nasm, yasm

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

mkdir -p build
cd build
cmake -G"Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$ROOTDIR" ..
make -j"$(nproc)" && make install

echo $NAME installed on "$ROOTDIR"
