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
    , nixos-hardware
    }:
    {
      lib = {
        makeNixosConfiguration = { system, modules }:
          nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              home-manager.nixosModules.home-manager
              { home-manager.sharedModules = [ nur.hmModules.nur ]; }
            ] ++ modules;
          };
      };

      dellLatitude3340 = { modules }: self.lib.makeNixosConfiguration {
        system = "x86_64-linux";
        modules = [
          "${nixos-hardware}/dell/latitude/3340"
          ./nixos/dell-latitude-3340.nix
        ] ++ modules;
      };
    };
}
