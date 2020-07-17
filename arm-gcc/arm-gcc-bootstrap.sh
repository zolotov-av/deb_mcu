#!/bin/bash

set -e

. config

set -x

TEMP=$PACKAGES/temp
DEST=$PACKAGES/arm-gcc
BUILD=$BASEDIR/build

rm -rf $TEMP $DEST $BUILD
mkdir -pv $TEMP $DEST $BUILD

cd $BUILD
$SRC/gcc-$VERSION/configure --prefix=/usr --libdir=$HOST_LIBDIR --build=$HOST_ARCH --host=$HOST_ARCH --target=$ARM_ARCH --enable-multilib --enable-shared --enable-languages=c,c++ --disable-nls --disable-libssp --with-dwarf2 --without-headers --with-newlib
make $PARALLEL all-gcc
make DESTDIR=$TEMP install-gcc

rsync -a $TEMP/ $DEST/

# cleanup
#rm -rf $DEST/usr/lib/lib/libcc1.*
#rmdir $DEST/usr/lib/lib
rm -rf $DEST/usr/share/info
rm -rf $DEST/usr/share/man/man7

mkdir -pv $DEST/DEBIAN
cp -v $BASEDIR/arm-gcc.control $DEST/DEBIAN/control
cd $PACKAGES
fakeroot dpkg-deb --build $DEST $BASEDIR
