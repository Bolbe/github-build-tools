#!/bin/bash

set -e  # Exit on any error
set -u  # Treat unset variables as errors

#appName="QMLDemo"
appName="$1"

#Check if required arguments are provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <AppName>"
    echo "Example: $0 QMLDemo"
    echo "This will build the application and create a macOS app bundle named QMLDemo.app containing the binary QMLDemo."
    exit 1
fi

# Check $QT_PATH environment variable
if [ -z "${QT_PATH:-}" ]; then
    echo "Error: QT_PATH environment variable must be set to the Qt installation folder (e.g., /path/to/Qt-6.5.3)."
    exit 1
fi

echo "Starting macOS build process..."

# Clean and create build directory
rm -rf build
mkdir -p build
cd build

# Build the application
echo "Running qmake and make..."
$QT_PATH/bin/qmake ..
make -j$(sysctl -n hw.ncpu)

echo "Running macdeployqt to bundle dependencies..."
$QT_PATH/bin/macdeployqt ./$appName.app -qmldir=$QT_PATH/qml

echo "Removing unnecessary frameworks and plugins..."
rm -rf $appName.app/Contents/Frameworks/QtConcurrent.framework
rm -rf $appName.app/Contents/Frameworks/QtLabsFolderListModel.framework
rm -rf $appName.app/Contents/Frameworks/QtLabsQmlModels.framework
rm -rf $appName.app/Contents/Frameworks/QtQmlCore.framework
rm -rf $appName.app/Contents/Frameworks/QtQmlLocalStorage.framework
rm -rf $appName.app/Contents/Frameworks/QtQmlXmlListModel.framework
rm -rf $appName.app/Contents/Frameworks/QtQuick3D.framework
rm -rf $appName.app/Contents/Frameworks/QtQuick3DAssetImport.framework
rm -rf $appName.app/Contents/Frameworks/QtQuick3DAssetUtils.framework
rm -rf $appName.app/Contents/Frameworks/QtQuick3DEffects.framework
rm -rf $appName.app/Contents/Frameworks/QtQuick3DHelpers.framework
rm -rf $appName.app/Contents/Frameworks/QtQuick3DHelpersImpl.framework
rm -rf $appName.app/Contents/Frameworks/QtQuick3DParticleEffects.framework
rm -rf $appName.app/Contents/Frameworks/QtQuick3DParticles.framework
rm -rf $appName.app/Contents/Frameworks/QtQuick3DPhysics.framework
rm -rf $appName.app/Contents/Frameworks/QtQuick3DPhysicsHelpers.framework
rm -rf $appName.app/Contents/Frameworks/QtQuick3DRuntimeRender.framework
rm -rf $appName.app/Contents/Frameworks/QtQuick3DUtils.framework
rm -rf $appName.app/Contents/Frameworks/QtQuickDialogs2.framework
rm -rf $appName.app/Contents/Frameworks/QtQuickDialogs2QuickImpl.framework
rm -rf $appName.app/Contents/Frameworks/QtQuickDialogs2Utils.framework
rm -rf $appName.app/Contents/Frameworks/QtQuickEffects.framework
rm -rf $appName.app/Contents/Frameworks/QtQuickLayouts.framework
rm -rf $appName.app/Contents/Frameworks/QtQuickParticles.framework
rm -rf $appName.app/Contents/Frameworks/QtQuickShapes.framework
rm -rf $appName.app/Contents/Frameworks/QtQuickTest.framework
rm -rf $appName.app/Contents/Frameworks/QtQuickTimeline.framework
rm -rf $appName.app/Contents/Frameworks/QtShaderTools.framework
rm -rf $appName.app/Contents/Frameworks/QtSql.framework
rm -rf $appName.app/Contents/Frameworks/QtSvg.framework
rm -rf $appName.app/Contents/Frameworks/QtTest.framework
rm -rf $appName.app/Contents/Frameworks/QtWidgets.framework
rm -rf $appName.app/Contents/PlugIns/iconengines
rm -rf $appName.app/Contents/PlugIns/imageformats
rm -rf $appName.app/Contents/PlugIns/networkinformation
rm -rf $appName.app/Contents/PlugIns/sqldrivers
rm -rf $appName.app/Contents/PlugIns/styles
rm -rf $appName.app/Contents/PlugIns/tls
rm -rf $appName.app/Contents/PlugIns/quick/libeffectsplugin.dylib
rm -rf $appName.app/Contents/PlugIns/quick/liblabsmodelsplugin.dylib
rm -rf $appName.app/Contents/PlugIns/quick/libmodelsplugin.dylib
rm -rf $appName.app/Contents/PlugIns/quick/libparticlesplugin.dylib
rm -rf $appName.app/Contents/PlugIns/quick/libqmlfolderlistmodelplugin.dylib
rm -rf $appName.app/Contents/PlugIns/quick/libqmllocalstorageplugin.dylib
rm -rf $appName.app/Contents/PlugIns/quick/libqmlmetaplugin.dylib
rm -rf $appName.app/Contents/PlugIns/quick/libqmlplugin.dylib
rm -rf $appName.app/Contents/PlugIns/quick/libqmlshapesplugin.dylib
rm -rf $appName.app/Contents/PlugIns/quick/libqmlxmllistmodelplugin.dylib
rm -rf $appName.app/Contents/PlugIns/quick/libqquick3dphysicsplugin.dylib
rm -rf $appName.app/Contents/PlugIns/quick/libqquick3dplugin.dylib
rm -rf $appName.app/Contents/PlugIns/quick/libqquicklayoutsplugin.dylib
rm -rf $appName.app/Contents/PlugIns/quick/libqtqmlcoreplugin.dylib
rm -rf $appName.app/Contents/PlugIns/quick/libqtquick3dassetutilsplugin.dylib
rm -rf $appName.app/Contents/PlugIns/quick/libqtquick3deffectplugin.dylib
rm -rf $appName.app/Contents/PlugIns/quick/libqtquick3dhelpersimplplugin.dylib
rm -rf $appName.app/Contents/PlugIns/quick/libqtquick3dhelpersplugin.dylib
rm -rf $appName.app/Contents/PlugIns/quick/libqtquick3dparticleeffectsplugin.dylib
rm -rf $appName.app/Contents/PlugIns/quick/libqtquick3dparticles3dplugin.dylib
rm -rf $appName.app/Contents/PlugIns/quick/libqtquick3dphysicshelpersplugin.dylib
rm -rf $appName.app/Contents/PlugIns/quick/libqtquickcontrols2imaginestyleimplplugin.dylib
rm -rf $appName.app/Contents/PlugIns/quick/libqtquickcontrols2imaginestyleplugin.dylib
rm -rf $appName.app/Contents/PlugIns/quick/libqtquickcontrols2iosstyleimplplugin.dylib
rm -rf $appName.app/Contents/PlugIns/quick/libqtquickcontrols2iosstyleplugin.dylib
rm -rf $appName.app/Contents/PlugIns/quick/libqtquickcontrols2nativestyleplugin.dylib
rm -rf $appName.app/Contents/PlugIns/quick/libqtquickcontrols2universalstyleimplplugin.dylib
rm -rf $appName.app/Contents/PlugIns/quick/libqtquickcontrols2universalstyleplugin.dylib
rm -rf $appName.app/Contents/PlugIns/quick/libqtquickdialogs2quickimplplugin.dylib
rm -rf $appName.app/Contents/PlugIns/quick/libqtquickdialogsplugin.dylib
rm -rf $appName.app/Contents/PlugIns/quick/libqtquicktimelineplugin.dylib
rm -rf $appName.app/Contents/PlugIns/quick/libquicktestplugin.dylib
rm -rf $appName.app/Contents/PlugIns/quick/libquicktoolingplugin.dylib
rm -rf $appName.app/Contents/PlugIns/quick/libquickwindowplugin.dylib
rm -rf $appName.app/Contents/Resources/qml/Qt
rm -rf $appName.app/Contents/Resources/qml/QtCore
rm -rf $appName.app/Contents/Resources/qml/QtQuick3D
rm -rf $appName.app/Contents/Resources/qml/QtTest
rm -rf $appName.app/Contents/Resources/qml/QtQml/Base
rm -rf $appName.app/Contents/Resources/qml/QtQml/Models
rm -rf $appName.app/Contents/Resources/qml/QtQml/XmlListModel
rm -rf $appName.app/Contents/Resources/qml/QtQuick/Dialogs
rm -rf $appName.app/Contents/Resources/qml/QtQuick/Effects
rm -rf $appName.app/Contents/Resources/qml/QtQuick/Layouts
rm -rf $appName.app/Contents/Resources/qml/QtQuick/LocalStorage
rm -rf $appName.app/Contents/Resources/qml/QtQuick/NativeStyle
rm -rf $appName.app/Contents/Resources/qml/QtQuick/Particles
rm -rf $appName.app/Contents/Resources/qml/QtQuick/Shapes
rm -rf $appName.app/Contents/Resources/qml/QtQuick/Timeline
rm -rf $appName.app/Contents/Resources/qml/QtQuick/Window
rm -rf $appName.app/Contents/Resources/qml/QtQuick/tooling
rm -rf $appName.app/Contents/Resources/qml/QtQuick/Controls/Imagine
rm -rf $appName.app/Contents/Resources/qml/QtQuick/Controls/Universal
rm -rf $appName.app/Contents/Resources/qml/QtQuick/Controls/designer
rm -rf $appName.app/Contents/Resources/qml/QtQuick/Controls/iOS
rm -rf $appName.app/Contents/Resources/qml/QtQuick/Controls/impl

# We need to zip here because the macOS app bundle is a directory and GitHub Actions artifact upload doesn't support directories, but it does support zip files. After uploading, we can unzip it back to the .app format for distribution.
ditto -c -k --sequesterRsrc --keepParent $appName.app $appName.app.zip
mv $appName.app ..
