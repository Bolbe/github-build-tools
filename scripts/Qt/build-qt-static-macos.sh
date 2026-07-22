#!/usr/bin/env bash
#
# build-qt-static.sh
#
# Reproducibly builds a static Qt 6.5.3 for macOS.
# Works both locally and on macOS CI runners (e.g. GitHub Actions `macos-latest`).
#
# Usage:
#   ./build-qt-static.sh
#
# Environment overrides:
#   INSTALL_DIR  (default: $HOME/Qt6.5.3-static)
#   BUILD_DIR    (default: $HOME/qt-build)
#   JOBS         (default: number of CPUs)

set -euo pipefail

# ---------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------
INSTALL_DIR="${INSTALL_DIR:-$HOME/Qt6.5.3-static}"
BUILD_DIR="${BUILD_DIR:-$HOME/qt-build}"
JOBS="${JOBS:-$(sysctl -n hw.ncpu)}"

SRC_TARBALL="qt-everywhere-src-6.5.3.tar.xz"
SRC_URL="https://download.qt.io/archive/qt/6.5/6.5.3/single/$SRC_TARBALL "
SRC_DIR="qt-everywhere-src-6.5.3"

# Modules to strip out before configuring (trims build time / unused deps)
MODULES_TO_REMOVE=(
  qtquick3d qtquick3dphysics qtquickeffectmaker qtgrpc qtscxml qtnetworkauth
  qt5compat qt3d qtactiveqt qtcharts qtcoap qtconnectivity qtdatavis3d
  qtlanguageserver qtlocation qtmqtt qtlottie qtmultimedia qtopcua
  qtpositioning qtremoteobjects qtsensors qtserialbus qtserialport
  qtvirtualkeyboard qtwayland qttools qtwebengine qtdoc qtspeech
  qttranslations qtwebview qtwebchannel qtwebsockets qthttpserver
)

log() { printf '\n\033[1;34m==>\033[0m %s\n' "$1"; }
err() { printf '\n\033[1;31mERROR:\033[0m %s\n' "$1" >&2; }

# ---------------------------------------------------------------------------
# Sanity checks
# ---------------------------------------------------------------------------
if [[ "$(uname -s)" != "Darwin" ]]; then
  err "This script must run on macOS (found $(uname -s)). Static Qt for macOS" \
      "cannot be produced from a Linux container/host."
  exit 1
fi

if ! command -v brew &>/dev/null; then
  err "Homebrew not found. Install it from https://brew.sh first."
  exit 1
fi

# ---------------------------------------------------------------------------
# Dependencies
# ---------------------------------------------------------------------------
log "Installing build dependencies (cmake, ninja)"
brew list cmake &>/dev/null || brew install cmake
brew list ninja &>/dev/null || brew install ninja

# ---------------------------------------------------------------------------
# Fetch source
# ---------------------------------------------------------------------------
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

if [[ ! -f "$SRC_TARBALL" ]]; then
  log "Downloading $SRC_TARBALL from $SRC_URL"
  curl -fL --retry 3 -o "$SRC_TARBALL" "$SRC_URL"
else
  log "Source tarball already present, skipping download"
fi

if [[ ! -d "$SRC_DIR" ]]; then
  log "Extracting source"
  tar xf "$SRC_TARBALL"
else
  log "Source directory already extracted, skipping"
fi

cd "$SRC_DIR"

# ---------------------------------------------------------------------------
# Trim unused modules
# ---------------------------------------------------------------------------
log "Removing unused modules"
for module in "${MODULES_TO_REMOVE[@]}"; do
  if [[ -d "$module" ]]; then
    rm -rf "$module"
    echo "  removed $module"
  fi
done

# ---------------------------------------------------------------------------
# Configure
# ---------------------------------------------------------------------------
log "Configuring Qt (static, release, prefix=$INSTALL_DIR)"
./configure -static \
  -prefix "$INSTALL_DIR" \
  -release \
  -opensource -confirm-license \
  -nomake examples -nomake tests \
  -platform macx-clang \
  -qt-libpng -qt-libjpeg -qt-zlib \
  -no-framework \
  -no-icu \
  -no-dbus \
  -sql-sqlite \
  -strip

# ---------------------------------------------------------------------------
# Build & install
# ---------------------------------------------------------------------------
log "Building with $JOBS parallel jobs (this will take a while)"
cmake --build . --parallel "$JOBS"

log "Installing to $INSTALL_DIR"
cmake --install .

log "Done. Static Qt 6.5.3installed at: $INSTALL_DIR"