#!/bin/bash

set -e

. config

set -x

TEMP=$PACKAGES/temp
DEST=$PACKAGES/avr-binutils
BUILD=$BASEDIR/build

rm -rf $TEMP $DEST $BUILD
mkdir -pv $TEMP $DEST $BUILD

cd $BUILD
$SRC/binutils-$VERSION/configure --prefix=/usr --libdir=$HOST_LIBDIR --build=$HOST_ARCH --host=$HOST_ARCH --target=avr --enable-multilib --enable-shared --disable-static --disable-nls
make $PARALLEL
make DESTDIR=$TEMP install-strip

rsync -a $TEMP/ $DEST/

# cleanup
rm -rf $DEST/$TARGET_LIBDIR/*.la
rm -rf $DEST/usr/share/info

mkdir -pv $DEST/DEBIAN
cp -v $BASEDIR/avr-binutils.control $DEST/DEBIAN/control
cd $PACKAGES
fakeroot dpkg-deb --build $DEST $BASEDIR
