{
  lib,
  config,
  theme,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.configured.neovim;
in {
  options.programs.configured.neovim = {
    enable = mkEnableOption "Neo VIM";
  };
  config = mkIf cfg.enable {
    home.file."./.config/nvim/" = {
      source = ./nvim;
      recursive = true;
    };
    programs.neovim = {
      enable = true;
      package = pkgs.neovim-unwrapped;
      vimAlias = true;
      defaultEditor = true;
      viAlias = true;
      coc.enable = false;
      extraPackages = import ./nvim-programs.nix pkgs;
      withNodeJs = true;
      extraWrapperArgs = [
        "--suffix"
        "PRIMARY_COLOR"
        ":"
        "${theme.secondaryColor}"
      ];
    };
  };
}
