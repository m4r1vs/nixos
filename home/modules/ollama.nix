{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.services.configured.ollama;
in {
  options.services.configured.ollama = {
    enable = mkEnableOption "Run LLMs locally";
  };
  config = mkIf cfg.enable {
    services.ollama = {
      enable = true;
      acceleration = "cuda";
    };
  };
}
