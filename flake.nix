{
  description = "Entrypoint for both NixOS and standalone home-manager";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    home-manager = {
      url = "home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , nur
    }:
    {
      lib = {
        makeNixosConfiguration = { system, modules }:
          nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              home-manager.nixosModules.home-manager
              {
                home-manager.sharedModules = [ nur.hmModules.nur ];

                # Pin nixpkgs
                nix.registry.nixpkgs.flake = nixpkgs;
                nix.nixPath = [ "nixpkgs=flake:nixpkgs" ];
              }
            ] ++ modules;
          };

        makeHomeManagerConfiguration = { system, modules }:
          home-manager.lib.homeManagerConfiguration {
            pkgs = import nixpkgs { inherit system; };
            modules = [
              nur.hmModules.nur
              {
                # Pin nixpkgs
                nix.registry.nixpkgs.flake = nixpkgs;
                home.sessionVariables.NIX_PATH = "nixpkgs=flake:nixpkgs$\{NIX_PATH:+:$NIX_PATH}";
              }
            ] ++ modules;
          };
      };

      dellLatitude3340 = { modules }: self.lib.makeNixosConfiguration {
        system = "x86_64-linux";
        modules = [ ./nixos/dell-latitude-3340.nix ] ++ modules;
      };

      macosM1 = { modules }: self.lib.makeHomeManagerConfiguration {
        system = "aarch64-darwin";
        modules = [ ./home-manager/macos ] ++ modules;
      };
    };
}
