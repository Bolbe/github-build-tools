#!/bin/bash

set -e  # Exit on any error
set -u  # Treat unset variables as errors

#LINUX_BIN_FILE="QMLDemo"
#LINUX_APP_IMAGE="qmldemo"

LINUX_BIN_FILE="$1"
LINUX_APP_IMAGE="$2"

# Check if required arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <Binary file name> <AppImageName>"
    echo "Example: $0 QMLDemo qmldemo"
    echo "This will build the application and create an AppImage named qmldemo.AppImage containing the binary QMLDemo."
    exit 1
fi

# Check $QT_PATH environment variable
if [ -z "${QT_PATH:-}" ]; then
    echo "Error: QT_PATH environment variable must be set to the Qt installation folder (e.g., /path/to/Qt-6.5.3)."
    exit 1
fi

echo "Starting build process..."

# Clean and create build directory
rm -rf build
mkdir -p build
cd build

# Build the application
echo "Running qmake and make..."
$QT_PATH/bin/qmake ..
make -j$(nproc)

echo "Creating package folder..."
mkdir -p package
cp ./$LINUX_BIN_FILE package/$LINUX_BIN_FILE
cp ../qml256.png package/qml256.png
cp ../AppRun package/AppRun
cp ../$LINUX_APP_IMAGE.desktop package/$LINUX_APP_IMAGE.desktop

echo "Copying shared libraries to lib folder..."
mkdir -p package/lib
cp $QT_PATH/lib/libQt6Core.so.6.5.3 package/lib/libQt6Core.so.6
cp $QT_PATH/lib/libQt6Gui.so.6.5.3 package/lib/libQt6Gui.so.6
cp $QT_PATH/lib/libQt6Network.so.6.5.3 package/lib/libQt6Network.so.6
cp $QT_PATH/lib/libQt6OpenGL.so.6.5.3 package/lib/libQt6OpenGL.so.6
cp $QT_PATH/lib/libQt6Qml.so.6.5.3 package/lib/libQt6Qml.so.6
cp $QT_PATH/lib/libQt6QmlModels.so.6.5.3 package/lib/libQt6QmlModels.so.6
cp $QT_PATH/lib/libQt6QmlWorkerScript.so.6.5.3 package/lib/libQt6QmlWorkerScript.so.6
cp $QT_PATH/lib/libQt6Quick.so.6.5.3 package/lib/libQt6Quick.so.6
cp $QT_PATH/lib/libQt6QuickControls2.so.6.5.3 package/lib/libQt6QuickControls2.so.6
cp $QT_PATH/lib/libQt6QuickControls2Impl.so.6.5.3 package/lib/libQt6QuickControls2Impl.so.6
cp $QT_PATH/lib/libQt6QuickTemplates2.so.6.5.3 package/lib/libQt6QuickTemplates2.so.6
cp $QT_PATH/lib/libQt6XcbQpa.so.6.5.3 package/lib/libQt6XcbQpa.so.6

echo "Copying plugins libraries to plugins folder..."
mkdir -p package/plugins/platforms
cp $QT_PATH/plugins/platforms/libqxcb.so package/plugins/platforms/
mkdir -p package/plugins/xcbglintegrations
cp $QT_PATH/plugins/xcbglintegrations/libqxcb-egl-integration.so package/plugins/xcbglintegrations/

echo "Copying QML files to qml folder..."
mkdir -p package/qml/QtQml
cp -r $QT_PATH/qml/QtQml/WorkerScript package/qml/QtQml/
cp $QT_PATH/qml/QtQml/libqmlmetaplugin.so package/qml/QtQml/
mkdir -p package/qml/QtQuick
cp -r $QT_PATH/qml/QtQuick/Controls package/qml/QtQuick/
rm -rf package/qml/QtQuick/Controls/designer
rm -rf package/qml/QtQuick/Controls/Imagine
rm -rf package/qml/QtQuick/Controls/Universal
cp -r $QT_PATH/qml/QtQuick/Templates package/qml/QtQuick/
cp $QT_PATH/qml/QtQuick/libqtquick2plugin.so package/qml/QtQuick/
cp $QT_PATH/qml/QtQuick/plugins.qmltypes package/qml/QtQuick/
cp $QT_PATH/qml/QtQuick/qmldir package/qml/QtQuick/

# Remove debug files
find package -name "*.debug" -type f -delete

echo "Changing runtime path to ./lib"
chrpath -r ./lib/ package/$LINUX_BIN_FILE

# Rename package directory
mv package $LINUX_APP_IMAGE

# Download and use appimagetool to create AppImage
echo "Downloading appimagetool..."
wget -q https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage
chmod +x appimagetool-x86_64.AppImage

echo "Packaging application with appimagetool..."
./appimagetool-x86_64.AppImage $LINUX_APP_IMAGE $LINUX_APP_IMAGE.AppImage

# Move the AppImage to the parent directory
mv $LINUX_APP_IMAGE.AppImage ..

echo "Build completed successfully."
