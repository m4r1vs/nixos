{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.programs.configured.ssh;
in {
  options.programs.configured.ssh = {
    enable = mkEnableOption "Secure Shell";
  };
  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      extraConfig = ''
        Host *
            IdentityAgent ~/.1password/agent.sock
      '';
    };
  };
}
