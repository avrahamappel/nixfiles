self: super:

let
  pkgs = super;

  inherit (pkgs)
    lib
    rustPlatform
    ;

  inherit (import ../npins) cosmic-epoch;

  version = builtins.substring 6 (-1) cosmic-epoch.version;

  cargoHashes = {
    "cosmic-applets-1.7.0" = "sha256-xgpsIynrVcN62IQ++ABZqqbP0ak86eQYTc1SCSxy2l4=";
    "cosmic-applibrary-1.7.0" = "sha256-pr90LG3H8hKD1dJAeO4vfLQLlihB7gjwvhlDNHdRTec=";
  };

  latestCosmicVersion = name: pkgs.${name}.overrideAttrs (final: prev: {
    inherit version;
    src = cosmic-epoch.outPath + "/${name}";

    # Update cargo deps hash
    cargoHash = cargoHashes."${name}-${version}" or lib.fakeHash;

    # Avoid compiling twice
    doCheck = false;

    # Drill down into deps
    cargoDeps = prev.cargoDeps.overrideAttrs (oldDeps: {
      vendorStaging = oldDeps.vendorStaging.overrideAttrs {
        # Forward cargo deps hash
        outputHash = final.cargoHash;
      };
    });
  });
in

{
  cosmic-applets = (latestCosmicVersion "cosmic-applets").overrideAttrs (prev: {
    patches = [ ];
    cargoDeps = prev.cargoDeps.overrideAttrs (prevDeps: {
      patches = [ ];
      vendorStaging = prevDeps.vendorStaging.overrideAttrs {
        patches = [ ];
      };
    });
  });

  cosmic-applibrary = (latestCosmicVersion "cosmic-applibrary").overrideAttrs (prev:

    let
      xdgen-generate-src = "${prev.src}/scripts/xdgen";
      xdgen-generate-version = (fromTOML (builtins.readFile (xdgen-generate-src + "/Cargo.toml"))).package.version;
      xdgen-generate = rustPlatform.buildRustPackage {
        pname = "xdgen-generate";
        version = xdgen-generate-version;

        src = xdgen-generate-src;

        cargoHash = "sha256-u3ia4MOL1cNj3K5ofJ5piwEDsDna2ImZh9uSVRPIQ/o=";

        meta.mainProgram = "xdgen-generate";
      };
    in

    {
      preInstall = prev.preInstall or ''
        env \
            APP_ID=com.system76.CosmicAppLibrary \
            APP_NAME=cosmic-app-library \
            ${lib.getExe xdgen-generate}
      '';

      passthru = { inherit xdgen-generate; };
    }
  );

  # cosmic-bg = prev.cosmic-bg.overrideAttrs { src = "${cosmic-epoch}/cosmic-bg"; inherit version; };
  # cosmic-comp = prev.cosmic-comp.overrideAttrs { src = "${cosmic-epoch}/cosmic-comp"; inherit version; };
  # cosmic-edit = prev.cosmic-edit.overrideAttrs { src = "${cosmic-epoch}/cosmic-edit"; inherit version; };
  # cosmic-files = prev.cosmic-files.overrideAttrs { src = "${cosmic-epoch}/cosmic-files"; inherit version; };
  # cosmic-greeter = prev.cosmic-greeter.overrideAttrs { src = "${cosmic-epoch}/cosmic-greeter"; inherit version; };
  # cosmic-icons = prev.cosmic-icons.overrideAttrs { src = "${cosmic-epoch}/cosmic-icons"; inherit version; };
  # cosmic-idle = prev.cosmic-idle.overrideAttrs { src = "${cosmic-epoch}/cosmic-idle"; inherit version; };
  # cosmic-initial-setup = prev.cosmic-initial-setup.overrideAttrs { src = "${cosmic-epoch}/cosmic-initial-setup"; inherit version; };
  # cosmic-launcher = prev.cosmic-launcher.overrideAttrs { src = "${cosmic-epoch}/cosmic-launcher"; inherit version; };
  # cosmic-monitor = prev.cosmic-monitor.overrideAttrs { src = "${cosmic-epoch}/cosmic-monitor"; inherit version; };
  # cosmic-notifications = prev.cosmic-notifications.overrideAttrs { src = "${cosmic-epoch}/cosmic-notifications"; inherit version; };
  # cosmic-osd = prev.cosmic-osd.overrideAttrs { src = "${cosmic-epoch}/cosmic-osd"; inherit version; };
  # cosmic-panel = prev.cosmic-panel.overrideAttrs { src = "${cosmic-epoch}/cosmic-panel"; inherit version; };
  # cosmic-player = prev.cosmic-player.overrideAttrs { src = "${cosmic-epoch}/cosmic-player"; inherit version; };
  # cosmic-randr = prev.cosmic-randr.overrideAttrs { src = "${cosmic-epoch}/cosmic-randr"; inherit version; };
  # cosmic-screenshot = prev.cosmic-screenshot.overrideAttrs { src = "${cosmic-epoch}/cosmic-screenshot"; inherit version; };
  # cosmic-session = prev.cosmic-session.overrideAttrs { src = "${cosmic-epoch}/cosmic-session"; inherit version; };
  # cosmic-settings-daemon = prev.cosmic-settings-daemon.overrideAttrs { src = "${cosmic-epoch}/cosmic-settings-daemon"; inherit version; };
  # cosmic-settings = prev.cosmic-settings.overrideAttrs { src = "${cosmic-epoch}/cosmic-settings"; inherit version; };
  # cosmic-sound-theme = prev.cosmic-sound-theme.overrideAttrs { src = "${cosmic-epoch}/cosmic-sound-theme"; inherit version; };
  # cosmic-store = prev.cosmic-store.overrideAttrs { src = "${cosmic-epoch}/cosmic-store"; inherit version; };
  # cosmic-term = prev.cosmic-term.overrideAttrs { src = "${cosmic-epoch}/cosmic-term"; inherit version; };
  # cosmic-wallpapers = prev.cosmic-wallpapers.overrideAttrs { src = "${cosmic-epoch}/cosmic-wallpapers"; inherit version; };
  # cosmic-workspaces-epoch = prev.cosmic-workspaces-epoch.overrideAttrs { src = "${cosmic-epoch}/cosmic-workspaces-epoch"; inherit version; };
  # xdg-desktop-portal-cosmic = prev.xdg-desktop-portal-cosmic.overrideAttrs { src = "${cosmic-epoch}/xdg-desktop-portal-cosmic"; inherit version; };
}
