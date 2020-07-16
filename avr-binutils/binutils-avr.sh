#!/bin/bash

set -e

. config

set -x

DEST=$PACKAGES/binutils-avr
BUILD=$BASEDIR/build

rm -rf $DEST $BUILD
mkdir -pv $DEST $BUILD

cd $BUILD
$SRC/binutils-$VERSION/configure --prefix=/usr --libdir=$HOST_LIBDIR --build=$HOST_ARCH --host=$HOST_ARCH --target=avr --enable-multilib --enable-shared --disable-static --disable-nls
make $PARALLEL
make DESTDIR=$DEST install-strip

# cleanup
rm -rf $DEST/$TARGET_LIBDIR/*.la
rm -rf $DEST/usr/share/info

mkdir -pv $DEST/DEBIAN
cp -v $BASEDIR/binutils-avr.control $DEST/DEBIAN/control
cd $PACKAGES
fakeroot dpkg-deb --build $DEST $BASEDIR
