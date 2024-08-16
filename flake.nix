{
  description = "Entrypoint for both NixOS and standalone home-manager";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    home-manager = {
      url = "home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nur, ... }:
    {
      lib = {
        makeNixosConfiguration = { system, modules, base ? "default" }:
          nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              home-manager.nixosModules.home-manager
              { home-manager.sharedModules = [ nur.hmModules.nur ]; }
              ./nixos/${base}.nix
            ] ++ modules;
          };
      };

      dellLatitude3340 = { modules }: self.lib.makeNixosConfiguration {
        inherit modules;
        system = "x86_64-linux";
        base = "dell-latitude-3340";
      };
    };
}
