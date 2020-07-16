#!/bin/bash

set -e

. config

set -x

DEST=$PACKAGES/gcc-avr
BUILD=$BASEDIR/build

rm -rf $DEST $BUILD
mkdir -pv $DEST $BUILD

cd $BUILD
$SRC/gcc-$VERSION/configure --prefix=/usr --libdir=$HOST_LIBDIR --build=$HOST_ARCH --host=$HOST_ARCH --target=avr --enable-multilib --enable-shared --disable-static --disable-nls --enable-languages=c,c++ --disable-libssp --with-dwarf2
make $PARALLEL
make DESTDIR=$DEST install-strip

# cleanup
rm -rf $DEST/usr/lib/lib/libcc1.*
rmdir $DEST/usr/lib/lib
rm -rf $DEST/usr/share/info
rm -rf $DEST/usr/share/man/man7

mkdir -pv $DEST/DEBIAN
cp -v $BASEDIR/gcc-avr.control $DEST/DEBIAN/control
cd $PACKAGES
fakeroot dpkg-deb --build $DEST $BASEDIR
