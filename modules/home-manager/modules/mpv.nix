{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.configured.mpv;
in {
  options.programs.configured.mpv = {
    enable = mkEnableOption "Music and Video Player";
  };
  config = mkIf cfg.enable {
    programs.mpv = {
      enable = true;
      scripts = with pkgs; [
        mpvScripts.mpris
        mpvScripts.sponsorblock
        mpvScripts.modernz
        (mpvScripts.buildLua {
          pname = "mpv-notify-send";
          version = "2025-03-30";
          src = fetchFromGitHub {
            owner = "m4r1vs";
            repo = "mpv-notify-send";
            rev = "master";
            hash = "sha256-Tzk1XZmsiVXzsIUaMh8ROlkXkFs0GpoKbSv6QdsvO6M=";
          };
          passthru.extraWrapperArgs = [
            "--prefix"
            "PATH"
            ":"
            (lib.makeBinPath [libnotify])
          ];
        })
      ];
    };
  };
}
