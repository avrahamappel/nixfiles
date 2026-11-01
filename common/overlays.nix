{ lib, config, ... }:

let
  inherit (import ../npins) irql-vaapi-driver;
in

{
  options = {
    mpvCdSupport = lib.mkEnableOption "Whether to enable MPV to read directly from CD drives, i.e. `mpv cdda://`";
  };

  config = {
    nixpkgs.overlays = [
      # Use a maintained fork of intel-vaapi-driver
      (final: prev: {
        intel-vaapi-driver = prev.intel-vaapi-driver.overrideAttrs {
          version = irql-vaapi-driver.version;
          src = irql-vaapi-driver;
        };
      })

      # Disable failing tests in urllib3-future
      (final: prev: {
        python3Packages = prev.python3Packages.overrideScope
          (finalPython: prevPython: {
            urllib3-future = prevPython.urllib3-future.overridePythonAttrs
              (prevAttrs: {
                disabledTestPaths = prevAttrs.disabledTestPaths ++ [
                  "test/test_async_response.py::TestAsyncResponse::test_chunked_decoding_gzip_swallow_garbage"
                  "test/test_response.py::TestResponse::test_chunked_decoding_gzip_swallow_garbage"
                  "test/test_ssltransport.py::SingleTLSLayerTestCase::test_start_closed_socket"
                ];
              });
          });
      })

    ]
    ++ lib.optional config.mpvCdSupport (self: super: {
      mpv-unwrapped = super.mpv-unwrapped.override {
        cddaSupport = true;
      };
    });
  };
}
