{
  pkgs,
  systemArgs,
  ...
}: let
  isDesktop = systemArgs.isDesktop;
in {
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      /*
      Temporary Fixes / Updates
      */
      (final: prev: {
        tmux = prev.tmux.overrideAttrs {
          src = pkgs.fetchFromGitHub {
            owner = "m4r1vs";
            repo = "tmux";
            rev = "master";
            hash = "sha256-O24yiUNPzUvn7ba2nvDzzKGl1j5hOBi5CHYIbCiIWhg=";
          };
        };
      })
      (final: prev: {
        hyprlandPlugins =
          prev.hyprlandPlugins
          // {
            hyprfocus = prev.hyprlandPlugins.hyprfocus.overrideAttrs {
              src = pkgs.fetchFromGitHub {
                owner = "daxisunder";
                repo = "hyprfocus";
                rev = "main";
                hash = "sha256-ST5FFxyw5El4A7zWLaWbXb9bD9C/tunU+flmNxWCcEY=";
              };
              meta.broken = false;
            };
          };
      })
      /*
      Own Forks
      */
      (final: prev: {
        spotify-player =
          (prev.spotify-player.override {
            withStreaming = isDesktop;
            withDaemon = isDesktop;
            withAudioBackend =
              if isDesktop
              then "pulseaudio"
              else "";
            withMediaControl = isDesktop;
            withImage = isDesktop;
            withNotify = isDesktop;
            withSixel = false;
            withFuzzy = true;
          })
          .overrideAttrs {
            src = pkgs.fetchFromGitHub {
              owner = "m4r1vs";
              repo = "spotify-player";
              rev = "master";
              hash = "sha256-Ck8ma6TTyeCu7XgpiEnrVSFBcZIDco+9k7Fs2hqIJxo=";
            };
          };
      })
      /*
      Mods to packages
      */
      (final: prev: {
        rofi-unwrapped = prev.rofi-unwrapped.overrideAttrs (oldAttrs: {
          patchPhase = ''
            echo "NoDisplay=true" >> ./data/rofi-theme-selector.desktop
            echo "NoDisplay=true" >> ./data/rofi.desktop
          '';
        });
      })
    ];
  };
}
