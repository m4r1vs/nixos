{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.programs.configured.git;
in {
  options.programs.configured.git = {
    enable = mkEnableOption "Version Control";
  };
  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "Marius Niveri";
      userEmail = "mniveri@cc.systems";
    };
  };
}
