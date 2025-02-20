#!/bin/bash

DINGUS_DIR="$HOME/dingus"
BIN_DIR="$DINGUS_DIR/bin"
PACKAGES_DIR="$DINGUS_DIR/packages"
VERSION="1.2.0 (LATEST)"

if [[ "$1" == "-v" ]]; then
  echo "dingus version $VERSION"
  exit 0
fi

if [[ "$1" == "install" ]]; then
  PACKAGE_NAME="$2"
  PACKAGE_TOML_URL="https://github.com/packagedingus/packages/packages/$PACKAGE_NAME/package.toml"

  if curl --output /dev/null --silent --head --fail "$PACKAGE_TOML_URL"; then
    echo "📦 Installing $PACKAGE_NAME..."
    
    PACKAGE_URL=$(curl -fsSL "$PACKAGE_TOML_URL" | grep 'url:' | cut -d '"' -f2)
    
    if [[ -z "$PACKAGE_URL" ]]; then
      echo "ERR! 🔴 Failed to get package URL from package.toml"
      exit 1
    fi
    
    mkdir -p "$PACKAGES_DIR/$PACKAGE_NAME"
    curl -fsSL "$PACKAGE_URL" -o "$PACKAGES_DIR/$PACKAGE_NAME/package.tar.gz"
    
    echo "📂 Extracting $PACKAGE_NAME..."
    tar -xzf "$PACKAGES_DIR/$PACKAGE_NAME/package.tar.gz" -C "$PACKAGES_DIR/$PACKAGE_NAME"
    
    echo "✅ Installed $PACKAGE_NAME!"
  else
    echo "ERR! 🔴 $PACKAGE_NAME could not be found! Are you sure it exists?"
    exit 1
  fi
  exit 0
fi

if [[ "$1" == "uninstall" ]]; then
  if [[ "$2" == "all" ]]; then
    echo "🗑️ Removing all installed packages..."
    rm -rf "$PACKAGES_DIR"
    mkdir -p "$PACKAGES_DIR"
    echo "✅ All packages uninstalled!"
  else
    PACKAGE_NAME="$2"
    if [[ -d "$PACKAGES_DIR/$PACKAGE
