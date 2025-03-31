{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.configured.qt;
in {
  options.configured.qt = {
    enable = mkEnableOption "Description";
  };

  config = mkIf cfg.enable {
    qt = {
      enable = true;
      platformTheme.name = "gtk";
      style.name = "adwaita-dark";
    };
  };
}
