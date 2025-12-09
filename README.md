# Nixfiles

My Nix and Home Manager setup.

## 1. Install Nix (if not running NixOS)

See https://nixos.org/download.html

## 2. Clone the repo

```bash
nix-shell -p git --run "git clone https://github.com/avrahamappel/nixfiles.git $NIXFILES_PATH
```

## 3. Consume the flake

**For standalone Home-Manager:**

Add the following to `~/.config/home-manager/flake.nix`:
```nix
{
  inputs = {
    nixfiles.url = "git+file:/path/to/nixfiles?shallow=true";
  };

  outputs = { nixfiles, ... }:
    let
      system = "aarch64-darwin"; # Or whatever you're running

      hmConfiguration = nixfiles.inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import nixfiles.inputs.nixpkgs { inherit system; };
        modules = [
          nixfiles.hmModules.${system}.default
          # If you already have a home.nix, add it in here
          # ./home.nix
          {
            home.username = "USERNAME"; # Your username
            home.homeDirectory = "/Users/USERNAME"; # The absolute path to your ~
          }
        ];
      };
    in
    {
      homeConfigurations.USERNAME = hmConfiguration;

      # If your username contains a dot, you may find it necessary to redeclare it with and without quotes
      # homeConfigurations.USER.NAME = hmConfiguration;
      # homeConfigurations."USER.NAME" = hmConfiguration;
    };
}
```
Lock the flake:
```bash
nix --extra-experimental-features "nix-command flakes" flake lock ~/.config/home-manager/flake.nix
```
And build the profile:
```bash
nix-shell -p nh --run "nh home switch $NIXFILES_PATH"
```

**For NixOS**

Add the following to `/etc/nixos/flake.nix`:
```nix
{
  inputs = {
    nixfiles.url = "git+file:/path/to/nixfiles?shallow=true";
  };

  outputs = { nixfiles, ... }:

  let
    configuration = nixfiles.inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux"; # Or your system here
      modules = [
        nixfiles.nixosModules.default
        ./configuration.nix
      ];
    };
  in

  {
    nixosConfigurations.nixos = configuration; # Default name, replace with your machine's name if it differs
  };
}
```
Lock the flake:
```bash
sudo nix --extra-experimental-features "nix-command flakes" flake lock /etc/nixos/flake.nix
```
And build the system:
```bash
nix-shell -p nh --run "nh os switch"
```
