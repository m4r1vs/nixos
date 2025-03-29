{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    vimAlias = true;
    defaultEditor = true;
    viAlias = true;
    coc.enable = false;
    withNodeJs = true;
    extraPackages = import ./nvim-programs.nix pkgs;
    extraWrapperArgs = [
      "--suffix"
      "PRIMARY_COLOR"
      ":"
      "${(import ../../theme.nix).secondaryColor}"
    ];
  };

  home.file."./.config/nvim/" = {
    source = ./nvim;
    recursive = true;
  };
}
