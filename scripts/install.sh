#!/bin/bash
set -e

# ===================================================================
# Windows Build Script
#
# Arguments:
#   $1 - Game version number
#   $2 - Channel type (release / pre-release)
#
# This script:
#   - Downloads the required patch from the Hytale servers
#   - Applies the patch using Butler
#   - Bundles the game data and JRE into a Windows-ready layout
# ===================================================================

VERSION="${1:-1}"
TYPE="${2:-release}"

echo "==================================================================="
echo "--- STARTING WINDOWS BUILD ---"
echo "Version : $VERSION"
echo "Channel : $TYPE"
echo "==================================================================="

# -------------------------------------------------------------------
# Setup Butler (patch apply tool)
# -------------------------------------------------------------------
# Butler is used to apply .pwr patch files safely and efficiently
# -------------------------------------------------------------------
rm -rf tools
mkdir -p tools/butler
cd tools/butler

echo "Downloading Butler..."
wget -q "https://broth.itch.zone/butler/linux-amd64/LATEST/archive/default" -O butler.zip

echo "Extracting Butler..."
unzip -q butler.zip
chmod +x butler

# Save absolute path to Butler binary
BUTLER="$PWD/butler"

cd ../..

# -------------------------------------------------------------------
# Prepare build directories
# -------------------------------------------------------------------
BUILD_DIR="build_windows"

# Clean previous build artifacts
rm -rf "$BUILD_DIR" cache

# Create required directory structure
mkdir -p \
  "$BUILD_DIR/game/data" \
  "$BUILD_DIR/game/jre" \
  "$BUILD_DIR/UserData" \
  cache

# -------------------------------------------------------------------
# Download game patch
# -------------------------------------------------------------------
PATCH_URL="https://game-patches.hytale.com/patches/windows/amd64/$TYPE/0/$VERSION.pwr"

echo "Downloading Patch:"
echo "  $PATCH_URL"

wget -q "$PATCH_URL" -O cache/0.pwr

# -------------------------------------------------------------------
# Apply patch to game data directory
# -------------------------------------------------------------------
echo "Applying Patch..."
"$BUTLER" apply cache/0.pwr --staging-dir cache "$BUILD_DIR/game/data"

# -------------------------------------------------------------------
# Download and install Java Runtime Environment (JRE)
# -------------------------------------------------------------------
# The JRE is bundled to ensure consistent runtime behavior
# -------------------------------------------------------------------
echo "Downloading JRE..."
wget -q \
  "https://launcher.hytale.com/redist/jre/windows/amd64/jre-25.0.1_8.zip" \
  -O cache/jre.zip

echo "Extracting JRE..."
unzip -q cache/jre.zip -d cache/jre_temp

# Move extracted JRE into final build directory
mv cache/jre_temp/*jdk*-jre/* "$BUILD_DIR/game/jre/"

# -------------------------------------------------------------------
# Add Windows start script
# -------------------------------------------------------------------
echo "Adding start.bat..."
cp scripts/start.bat "$BUILD_DIR/start.bat"

# -------------------------------------------------------------------
# Cleanup temporary files
# -------------------------------------------------------------------
rm -rf tools cache

echo "==================================================================="
echo "--- WINDOWS BUILD COMPLETE ---"
echo "==================================================================="
