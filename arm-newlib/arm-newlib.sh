#!/bin/bash

set -e

. config

set -x

TEMP=$PACKAGES/temp
DEST=$PACKAGES/arm-newlib
BUILD=$BASEDIR/build

rm -rf $TEMP $DEST $BUILD
mkdir -pv $TEMP $DEST $BUILD

cd $BUILD
$SRC/newlib-$VERSION/configure --prefix=/usr --target=$ARM_ARCH
make $PARALLEL
make DESTDIR=$TEMP install

rsync -a $TEMP/ $DEST/

# cleanup
#rm -rf $DEST/$TARGET_LIBDIR/*.la
#rm -rf $DEST/usr/share/info

mkdir -pv $DEST/DEBIAN
cp -v $BASEDIR/arm-newlib.control $DEST/DEBIAN/control
cd $PACKAGES
fakeroot dpkg-deb --build $DEST $BASEDIR
