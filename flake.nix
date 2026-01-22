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
    qrscan = {
      url = "github:avrahamappel/qrscan";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.flake-compat.follows = "";
    };
  };

  outputs =
    { nixpkgs
    , home-manager
    , nixpkgs-unstable
    , rycee-nur
    , ...
    }@inputs:

    let
      extraArgs = pkgs: {
        pkgs-unstable = import nixpkgs-unstable {
          system = pkgs.stdenv.hostPlatform.system;
        };
        rycee-nur = pkgs.callPackage rycee-nur { };
        inherit inputs;
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
            imports = [ ./home-manager ];
          };

          # Pin nixpkgs
          nix.registry.nixpkgs.flake = nixpkgs;
          nix.registry.upkgs.flake = nixpkgs-unstable;
          nix.nixPath = [ "nixpkgs=flake:nixpkgs:upkgs=flake:upkgs" ];
        };
      };

      hmModules = {
        default = { pkgs, ... }: {
          _module.args = extraArgs pkgs;

          imports = [ ./home-manager ];
        };

        standalone = {
          imports = [
            ./home-manager/standalone.nix
          ];

          # Pin nixpkgs
          nix.registry.nixpkgs.flake = nixpkgs;
          nix.registry.upkgs.flake = nixpkgs-unstable;
          home.sessionVariables.NIX_PATH = "nixpkgs=flake:nixpkgs:upkgs=flake:upkgs$\{NIX_PATH:+:$NIX_PATH}";
        };

        macos.imports = [
          ./home-manager/macos
        ];
      };
    };
}
