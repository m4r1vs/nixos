{
  lib,
  config,
  systemArgs,
  ...
}:
with lib; let
  isDesktop = systemArgs.isDesktop;
  cfg = config.configured.nvidia;
in {
  options.configured.nvidia = {
    enable = mkEnableOption "Enable NVidia Driver";
  };
  config = mkIf cfg.enable {
    services = mkIf isDesktop {
      xserver.videoDrivers = ["nvidia"];
    };
    hardware = {
      nvidia-container-toolkit.enable = true;
      graphics = {
        enable = true;
      };
      nvidia = {
        modesetting.enable = true;
        powerManagement.enable = false;
        powerManagement.finegrained = false;
        nvidiaSettings = isDesktop;
      };
    };
  };
}
