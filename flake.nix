{
  description = "Entrypoint for both NixOS and standalone home-manager";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    home-manager = {
      url = "home-manager/release-25.11";
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
    , nixpkgs-unstable
    , rycee-nur
    }:

    let
      extraArgs = pkgs: {
        pkgs-unstable = import nixpkgs-unstable {
          system = pkgs.stdenv.hostPlatform.system;
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
      };

      hmModules = {
        default = { pkgs, ... }: {
          _module.args = extraArgs pkgs;

          # Pin nixpkgs
          nix.registry.nixpkgs.flake = nixpkgs;
          nix.registry.upkgs.flake = nixpkgs-unstable;
          home.sessionVariables.NIX_PATH = "nixpkgs=flake:nixpkgs$\{NIX_PATH:+:$NIX_PATH}";
        };

        standalone.imports = [
          ./home-manager/standalone.nix
        ];

        macos.imports = [
          ./home-manager/macos
        ];
      };
    };
}
