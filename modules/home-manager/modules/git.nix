{
  lib,
  config,
  systemArgs,
  ...
}:
with lib; let
  cfg = config.programs.configured.git;
  git = systemArgs.git;
in {
  options.programs.configured.git = {
    enable = mkEnableOption "Version Control";
  };
  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = git.name;
      userEmail = git.email;
    };
  };
}
