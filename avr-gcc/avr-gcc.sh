#!/bin/bash

set -e

. config

set -x

TEMP=$PACKAGES/temp
DEST=$PACKAGES/avr-gcc
BUILD=$BASEDIR/build

rm -rf $DEST $BUILD
mkdir -pv $DEST $BUILD

cd $BUILD
$SRC/gcc-$VERSION/configure --prefix=/usr --libdir=$HOST_LIBDIR --build=$HOST_ARCH --host=$HOST_ARCH --target=avr --enable-multilib --enable-shared --disable-static --disable-nls --enable-languages=c,c++ --disable-libssp --with-dwarf2
make $PARALLEL
make DESTDIR=$TEMP install-strip

rsync -a $TEMP/ $DEST/

# cleanup
rm -rf $DEST/usr/lib/lib/libcc1.*
rmdir $DEST/usr/lib/lib
rm -rf $DEST/usr/share/info
rm -rf $DEST/usr/share/man/man7

mkdir -pv $DEST/DEBIAN
cp -v $BASEDIR/avr-gcc.control $DEST/DEBIAN/control
cd $PACKAGES
fakeroot dpkg-deb --build $DEST $BASEDIR
