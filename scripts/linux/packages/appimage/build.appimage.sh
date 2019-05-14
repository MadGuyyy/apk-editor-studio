#!/bin/bash

clean() {
    rm -rf appdir 2> /dev/null
    if [[ $CI != true ]]; then
        make clean
        rm .qmake.stash Makefile*
    fi
}

# Prepare

cd "$(dirname "$0")"
source ../../environment.sh
source /opt/qt*/bin/qt*-env.sh
clean

# Build

if [[ $CI != true ]]; then
    qmake ../../../..
    make
    make install INSTALL_ROOT=appdir
fi

# Package

wget -c -nv "https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage"
chmod +x linuxdeployqt-continuous-x86_64.AppImage
./linuxdeployqt-continuous-x86_64.AppImage appdir/usr/share/applications/apk-editor-studio.desktop -appimage
mv APK_Editor_Studio*.AppImage apk-editor-studio_linux_$VERSION.AppImage
clean
