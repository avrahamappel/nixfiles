#!/usr/bin/env nix-shell
#!nix-shell -p npins -i bash

# Update flake
nix flake update

# Update pins
npins update

# Update firefox addons
nix run sourcehut:~rycee/mozilla-addons-to-nix -- \
    home-manager/firefox/addons.json \
    home-manager/firefox/generated-firefox-addons.nix
