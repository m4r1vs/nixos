{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.configured.kmscon;
in {
  options.services.configured.kmscon = {
    enable = mkEnableOption "Enable Kmscon geTTY replacement";
  };
  config = mkIf cfg.enable {
    services.kmscon = {
      enable = true;
      fonts = [
        {
          name = "JetBrainsMono NF";
          package = pkgs.nerd-fonts.jetbrains-mono;
        }
      ];
      extraOptions = "--term xterm-256color";
    };
  };
}
