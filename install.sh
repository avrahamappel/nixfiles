#!/usr/bin/env bash
#
# Set stuff up

NIXFILES_PATH=$(dirname "$(realpath "$0")")

if ! which nix &> /dev/null
then
    echo "Nix is not installed."
    echo "Go to https://nixos.org/download.html to get started."
    exit 1
fi

if ! which home-manager &> /dev/null
then
    echo "Home Manager is not installed."
    echo "Go to https://nix-community.github.io/home-manager/index.html#sec-install-standalone to get started."
    exit 1
fi

echo "Linking files..."

mkdir -p "$HOME/.config/home-manager"
ln -s -f "$NIXFILES_PATH/home.nix" "$HOME/.config/home-manager/home.nix"

echo "Complete!"
echo "Run 'home-manager switch' to start using your beloved environment!"
