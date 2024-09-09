#!/usr/bin/env nix-shell
#!nix-shell -p npins -i bash

# Update flake
nix flake update

# Update pins
npins update
