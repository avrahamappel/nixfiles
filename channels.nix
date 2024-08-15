{ pkgs, options, ... }:

# This module is designed to work with both NixOS and home-manager modules.

let
  srcs = import ./npins;

  # nixPath = [
  #   "nixpkgs=${pkgs.path}"
  # ];
in

{
  nixpkgs.config.packageOverrides =
    {
      nur = import srcs.NUR.outPath { inherit pkgs; };
    };

  # Allow nix flake commands to work with current version of nixpkgs
  # nix.registry.nixpkgs.to = {
  #   type = "path";
  #   path = pkgs.outPath;
  # };
}
# // (
#   if builtins.hasAttr "channels" options.nix then
#   # An upcoming home-manager option that allows setting user-level channels directly
#     {
#       nix.channels.nixpkgs = pkgs.path;
#     }
#   else if builtins.hasAttr "nixPath" options.nix then
#   # A NixOS option to set the NIX_PATH environment variable,
#   # also available in home-manager in an upcoming release
#     {
#       nix.nixPath = nixPath;
#     }
#   else
#   # Only relevant for home-manager 24.05
#     {
#       home.sessionVariables.NIX_PATH = builtins.replaceStrings [ "\n" ] [ ":" ] nixPath;
#     }
# )
