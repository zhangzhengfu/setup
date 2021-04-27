#!/bin/bash
# install zsh
set -e

ROOTDIR=${ZZROOT:-$HOME/app}
NAME="zsh"
TYPE=".tar.xz"
FILE="$NAME$TYPE"
DOWNLOADURL="https://sourceforge.net/projects/zsh/files/zsh/5.8/zsh-5.8.tar.xz"
NAME_DOC="zsh-doc"
TYPE_DOC=".tar.xz"
FILE_DOC="$NAME_DOC$TYPE_DOC"
DOWNLOADURL_DOC="https://sourceforge.net/projects/zsh/files/zsh-doc/5.8/zsh-5.8-doc.tar.xz"
echo $NAME, $NAME_DOC will be installed in "$ROOTDIR"
echo install ncurses first!

mkdir -p "$ROOTDIR/downloads"
cd "$ROOTDIR"

if [ -f "downloads/$FILE" ]; then
    echo "downloads/$FILE exist"
else
    echo "$FILE does not exist, downloading from $DOWNLOADURL"
    wget $DOWNLOADURL -O $FILE
    mv $FILE downloads/
fi

if [ -f "downloads/$FILE_DOC" ]; then
    echo "downloads/$FILE_DOC exist"
else
    echo "$FILE_DOC does not exist, downloading from $DOWNLOADURL_DOC"
    wget $DOWNLOADURL_DOC -O $FILE_DOC
    mv $FILE_DOC downloads/
fi

mkdir -p src/$NAME
tar xf downloads/$FILE -C src/$NAME --strip-components 1
tar xf downloads/$FILE_DOC -C src/$NAME --strip-components 1

cd src/$NAME

export CFLAGS=' -fPIC'
export CXXFLAGS=' -fPIC'
export CFLAGS="-I$ROOTDIR/include"
export CPPFLAGS="-I$ROOTDIR/include"
export LDFLAGS="-L$ROOTDIR/lib"

autoheader
autoconf
./configure --prefix="$ROOTDIR" --enable-shared
make -j"$(nproc)" && make install

echo $NAME installed on "$ROOTDIR"
echo put this in .bashrc
echo exec "$ROOTDIR"/bin/zsh -l
