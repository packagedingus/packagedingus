#!/bin/bash

PACKAGE_DIR="$HOME/packages"
BIN_DIR="$HOME/bin"

mkdir -p "$PACKAGE_DIR" "$BIN_DIR"

install_package() {
    PACKAGE_NAME=$1
    PACKAGE_TOML_URL="https://github.com/packagedingus/packages/raw/main/packages/packages/$PACKAGE_NAME/package.toml"
    
    echo "🔎 Searching for package: $PACKAGE_NAME"

    curl -fsSL "$PACKAGE_TOML_URL" -o "$PACKAGE_DIR/$PACKAGE_NAME/package.toml"
    if [ $? -ne 0 ]; then
        echo "❌ ERROR! $PACKAGE_NAME could not be found!"
        return 1
    fi

    PACKAGE_FILE=$(cat "$PACKAGE_DIR/$PACKAGE_NAME/package.toml")
    PACKAGE_URL=$(echo "$PACKAGE_FILE" | grep -oP '(?<=url: ")[^"]+')

    mkdir -p "$PACKAGE_DIR/$PACKAGE_NAME"

    echo "⬇️ Downloading package from $PACKAGE_URL..."
    curl -fsSL "$PACKAGE_URL" -o "$PACKAGE_DIR/$PACKAGE_NAME/package.tar.gz"
    if [ $? -ne 0 ]; then
        echo "❌ ERR! Failed to download the package from $PACKAGE_URL, Please check your WiFi connection."
        return 1
    fi

    echo "📦 Extracting package..."
    tar -xzvf "$PACKAGE_DIR/$PACKAGE_NAME/package.tar.gz" -C "$PACKAGE_DIR/$PACKAGE_NAME" --strip-components=1

    if [ -f "$PACKAGE_DIR/$PACKAGE_NAME/bin/$PACKAGE_NAME" ]; then
        mv "$PACKAGE_DIR/$PACKAGE_NAME/bin/$PACKAGE_NAME" "$BIN_DIR/$PACKAGE_NAME"
        echo "✅ $PACKAGE_NAME has been installed successfully!"
    else
        echo "❌ ERR! No executable found in package."
        return 1
    fi
}

case $1 in
    install)
        if [ -z "$2" ]; then
            echo "❌ Usage: dingus install <package_name>"
            exit 1
        fi
        install_package "$2"
        ;;
    *)
        echo "❌ Usage: dingus {install} <package_name>"
        exit 1
        ;;
esac
