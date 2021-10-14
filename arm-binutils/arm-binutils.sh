#!/bin/bash

set -e

. config

set -x

TEMP=$PACKAGES/temp
DEST=$PACKAGES/arm-binutils
BUILD=$BASEDIR/build

rm -rf $TEMP $DEST $BUILD
mkdir -pv $TEMP $DEST $BUILD

cd $BUILD
$SRC/binutils-$VERSION/configure --prefix=/usr --libdir=$HOST_LIBDIR --build=$HOST_ARCH --host=$HOST_ARCH --target=$ARM_ARCH --enable-multilib --disable-shared --disable-nls
make $PARALLEL
make DESTDIR=$TEMP install-strip

rsync -ac $TEMP/ $DEST/

# cleanup
rm -rf $DEST/$HOST_LIBDIR/*.la
rm -rf $DEST/usr/share/info
rm -rf $DEST/$HOST_LIBDIR/bfd-plugins/libdep.a
rmdir $DEST/$HOST_LIBDIR/bfd-plugins
rmdir $DEST/$HOST_LIBDIR/
rmdir $DEST/usr/lib

mkdir -pv $DEST/DEBIAN
cp -v $BASEDIR/arm-binutils.control $DEST/DEBIAN/control
cd $PACKAGES
fakeroot dpkg-deb --build $DEST $BASEDIR
