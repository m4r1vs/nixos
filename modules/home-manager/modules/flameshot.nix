{
  lib,
  config,
  systemArgs,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.configured.flameshot;
  theme = systemArgs.theme;
in {
  options.services.configured.flameshot = {
    enable = mkEnableOption "Enable Flameshot for X11 Screenshots";
  };
  config = mkIf cfg.enable {
    services.flameshot = {
      enable = true;
      package = pkgs.flameshot;
      settings = {
        General = {
          disabledTrayIcon = true;
          showStartupLaunchMessage = false;
          uiColor = theme.primaryColor.hex;
          drawColor = theme.primaryColor.hex;
          contrastUiColor = theme.secondaryColor.hex;
          showHelp = false;
        };
      };
    };
  };
}
