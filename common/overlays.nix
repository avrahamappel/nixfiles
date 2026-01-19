{ lib, ... }:

{
  nixpkgs.overlays = [
    # Fix setproctitle tests on macOS
    # https://nixpk.gs/pr-tracker.html?pr=481408
    (self: super:
      lib.optionalAttrs super.stdenv.isDarwin {
        python313 =
          let
            packageOverrides = python-self: python-super: {
              setproctitle = python-super.setproctitle.overridePythonAttrs (prev:
                assert builtins.length prev.disabledTests == 1;
                {
                  disabledTests = prev.disabledTests ++ [
                    "test_fork_segfault"
                    "test_thread_fork_segfault"
                  ];
                }
              );
            };
          in
          super.python313.override { inherit packageOverrides; };
      })
    # More overlays here
  ];
}
