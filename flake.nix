{
  description = "Entrypoint for both NixOS and standalone home-manager";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    home-manager = {
      url = "home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    }:
    {
      nixosModules = {
        default = {
          imports = [
            home-manager.nixosModules.home-manager
            ./nixos
          ];

          # Pin nixpkgs
          nix.registry.nixpkgs.flake = nixpkgs;
          nix.nixPath = [ "nixpkgs=flake:nixpkgs" ];
        };

        dell-latitude-3340.imports = [
          self.nixosModules.default
          ./nixos/dell-latitude-3340.nix
        ];
      };

      hmModules = {
        default = {
          imports = [
            ./home-manager/standalone.nix
          ];

          # Pin nixpkgs
          nix.registry.nixpkgs.flake = nixpkgs;
          home.sessionVariables.NIX_PATH = "nixpkgs=flake:nixpkgs$\{NIX_PATH:+:$NIX_PATH}";
        };

        macos.imports = [
          self.hmModules.default
          ./home-manager/macos
        ];
      };
    };
}
