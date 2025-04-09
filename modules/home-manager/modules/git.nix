{
  lib,
  config,
  systemArgs,
  osConfig,
  ...
}:
with lib; let
  cfg = config.programs.configured.git;
  git = systemArgs.git;
in {
  options.programs.configured.git = {
    enable = mkEnableOption "The version controlling software.";
  };
  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = git.name;
      userEmail = git.email;
      extraConfig =
        {
          pull.rebase = true;
        }
        // (optionalAttrs osConfig.wsl.enable {
          core.sshCommand = "ssh.exe";
        });
    };
  };
}
