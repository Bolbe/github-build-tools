#!/bin/bash

set -euo pipefail

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

mv $appName.app ..
