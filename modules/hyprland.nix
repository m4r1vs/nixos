{
  lib,
  config,
  pkgs,
  systemArgs,
  ...
}:
with lib; let
  cfg = config.configured.hyprland;
in {
  options.configured.hyprland = {
    enable = mkEnableOption "Enable hyprland tiling window manager as desktop environment";
  };
  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        wl-clipboard
      ];
      sessionVariables = {
        ELECTRON_OZONE_PLATFORM_HINT = "wayland";
        NIXOS_OZONE_WL = "1";
      };
    };

    security.pam.services = {
      greetd.kwallet = {
        enable = true;
        package = pkgs.kdePackages.kwallet-pam;
      };
      hyprlock = {};
    };
    programs = {
      hyprland.enable = true;
      hyprlock.enable = true;
    };
    services = {
      kmscon = {
        enable = true;
        fonts = [
          {
            name = "JetBrainsMono NF";
            package = pkgs.nerd-fonts.jetbrains-mono;
          }
        ];
        extraOptions = "--term xterm-256color";
      };
      greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd ${pkgs.hyprland}/bin/Hyprland";
            user = systemArgs.username;
          };
          initial_session = {
            command = "${pkgs.hyprland}/bin/Hyprland > ~/.hyprland.log 2>&1";
            user = systemArgs.username;
          };
        };
      };
    };
  };
}
