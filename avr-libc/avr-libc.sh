#!/bin/bash

set -e

. config

set -x

DEST=$PACKAGES/binutils-avr
BUILD=$BASEDIR/build

rm -rf $DEST $BUILD
mkdir -pv $DEST $BUILD

cd $BUILD
$SRC/avr-libc-$VERSION/configure --prefix=/usr --build=$HOST_ARCH --host=avr
make $PARALLEL
make DESTDIR=$DEST install

# cleanup
#rm -rf $DEST/$TARGET_LIBDIR/*.la
#rm -rf $DEST/usr/share/info

mkdir -pv $DEST/DEBIAN
cp -v $BASEDIR/avr-libc.control $DEST/DEBIAN/control
cd $PACKAGES
fakeroot dpkg-deb --build $DEST $BASEDIR
