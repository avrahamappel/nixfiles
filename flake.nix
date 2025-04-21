{
  description = "Entrypoint for both NixOS and standalone home-manager";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    home-manager = {
      url = "home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    rycee-nur = {
      flake = false;
      url = "gitlab:rycee/nur-expressions";
    };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , nixos-hardware # Indirect, resolved by flake registry
    , nixpkgs-unstable
    , rycee-nur
    }:

    let
      extraArgs = pkgs: {
        pkgs-unstable = import nixpkgs-unstable {
          inherit (pkgs) system;
        };
        rycee-nur = pkgs.callPackage rycee-nur { };
      };
    in

    {
      nixosModules = {
        default = { pkgs, ... }: {
          _module.args = extraArgs pkgs;

          imports = [
            home-manager.nixosModules.home-manager
            ./nixos
          ];

          home-manager.users.avraham = {
            _module.args = extraArgs pkgs;
            imports = [ ./home-manager/personal.nix ];
          };

          # Pin nixpkgs
          nix.registry.nixpkgs.flake = nixpkgs;
          nix.registry.upkgs.flake = nixpkgs-unstable;
          nix.nixPath = [ "nixpkgs=flake:nixpkgs" ];
        };

        dell-latitude-3340.imports = [
          self.nixosModules.default
          "${nixos-hardware}/dell/latitude/3340"
          ./nixos/dell-latitude-3340.nix
        ];
      };

      hmModules = {
        default = { pkgs, ... }: {
          _module.args = extraArgs pkgs;

          imports = [
            ./home-manager/standalone.nix
          ];

          # Pin nixpkgs
          nix.registry.nixpkgs.flake = nixpkgs;
          nix.registry.upkgs.flake = nixpkgs-unstable;
          home.sessionVariables.NIX_PATH = "nixpkgs=flake:nixpkgs$\{NIX_PATH:+:$NIX_PATH}";
        };

        macos.imports = [
          self.hmModules.default
          ./home-manager/macos
        ];
      };
    };
}
