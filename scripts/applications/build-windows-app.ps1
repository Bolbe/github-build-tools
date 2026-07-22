#Requires -Version 5.1

$ErrorActionPreference = "Stop"

#$archive_dir = "qmldemo"
#$exe = "QMLDemo.exe"
# Check if required arguments are provided
if ($args.Count -ne 2) {
    Write-Host "Usage: .\build-windows.ps1 <ExecutableName> <ArchiveDirectoryName>"
    Write-Host "Example: .\build-windows.ps1 QMLDemo.exe qmldemo"
    Write-Host "This will build the application and create a directory named qmldemo containing the executable QMLDemo.exe and all necessary Qt dependencies."
    exit 1
}

$exe = $args[0]
$archive_dir = $args[1]

# Check environment variables
if (-not [Environment]::GetEnvironmentVariable('QT_PATH')) {
    Write-Error "Environment variable QT_PATH does not exist. It must be set to /path/to/QtMingw64 (folder containing bin/qmake.exe)"
    exit 1
}

if (-not [Environment]::GetEnvironmentVariable('MINGW_PATH')) {
    Write-Error "Environment variable MINGW_PATH does not exist. It must be set to /path/to/mingw64 (folder containing bin/mingw32-make.exe)"
    exit 1
}

Write-Host "Starting Windows build process..."

# Set PATH
$env:Path = "$env:QT_PATH\bin;$env:MINGW_PATH\bin;$env:Path"

# Clean and create build directory
if (Test-Path build) {
    Remove-Item -Recurse -Force build
}
New-Item -ItemType Directory -Force build | Out-Null
Set-Location build

# Build the application
Write-Host "Running qmake..."
qmake ..

Write-Host "Running mingw32-make..."
$cpuCount = (Get-CimInstance -ClassName Win32_ComputerSystem).NumberOfLogicalProcessors
mingw32-make -j $cpuCount

# Create archive directory
Write-Host "Creating package directory..."
New-Item -ItemType Directory -Force $archive_dir | Out-Null

# Copy executable
Copy-Item ./release/$exe ./$archive_dir/

cp $env:QT_PATH/bin/libgcc_s_seh-1.dll ./$archive_dir
cp $env:QT_PATH/bin/libstdc++-6.dll ./$archive_dir
cp $env:QT_PATH/bin/libwinpthread-1.dll ./$archive_dir
cp $env:QT_PATH/bin/Qt6Core.dll ./$archive_dir
cp $env:QT_PATH/bin/Qt6Gui.dll ./$archive_dir
cp $env:QT_PATH/bin/Qt6Network.dll ./$archive_dir
cp $env:QT_PATH/bin/Qt6OpenGL.dll ./$archive_dir
cp $env:QT_PATH/bin/Qt6Qml.dll ./$archive_dir
cp $env:QT_PATH/bin/Qt6QmlCore.dll ./$archive_dir
cp $env:QT_PATH/bin/Qt6QmlModels.dll ./$archive_dir
cp $env:QT_PATH/bin/Qt6QmlWorkerScript.dll ./$archive_dir
cp $env:QT_PATH/bin/Qt6Quick.dll ./$archive_dir
cp $env:QT_PATH/bin/Qt6QuickControls2.dll ./$archive_dir
cp $env:QT_PATH/bin/Qt6QuickControls2Impl.dll ./$archive_dir
cp $env:QT_PATH/bin/Qt6QuickTemplates2.dll ./$archive_dir

mkdir ./$archive_dir/plugins/platforms
cp $env:QT_PATH/plugins/platforms/qwindows.dll ./$archive_dir/plugins/platforms

mkdir ./$archive_dir/qml
cp $env:QT_PATH/qml/builtins.qmltypes ./$archive_dir/qml
cp $env:QT_PATH/qml/jsroot.qmltypes ./$archive_dir/qml
cp -R $env:QT_PATH/qml/QtQml ./$archive_dir/qml
rm -R ./$archive_dir/qml/QtQml/XmlListModel
rm -R ./$archive_dir/qml/QtQml/Models
rm -R ./$archive_dir/qml/QtQml/Base

cp -R $env:QT_PATH/qml/QtQuick ./$archive_dir/qml
rm -R ./$archive_dir/qml/QtQuick/Dialogs
rm -R ./$archive_dir/qml/QtQuick/Effects
rm -R ./$archive_dir/qml/QtQuick/Layouts
rm -R ./$archive_dir/qml/QtQuick/LocalStorage
rm -R ./$archive_dir/qml/QtQuick/NativeStyle
rm -R ./$archive_dir/qml/QtQuick/Particles
rm -R ./$archive_dir/qml/QtQuick/Shapes
rm -R ./$archive_dir/qml/QtQuick/tooling
rm -R ./$archive_dir/qml/QtQuick/Window

# Create qt.conf
Write-Host "Creating qt.conf..."
New-Item ./$archive_dir/qt.conf | Out-Null

# Move back and relocate archive
Set-Location ..
Move-Item ./build/$archive_dir .

Write-Host "Build completed successfully."
