{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    vimAlias = true;
    viAlias = true;
    coc.enable = false;
    withNodeJs = true;
    extraPackages = import ./nvim-programs.nix pkgs;
  };

  home.file."./.config/nvim/" = {
    source = ./nvim;
    recursive = true;
  };
}
