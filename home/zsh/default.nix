{
  pkgs,
  lib,
  ...
}: {
  enable = true;
  package = pkgs.zsh;
  enableCompletion = true;
  autosuggestion.enable = true;
  syntaxHighlighting.enable = true;
  oh-my-zsh = {
    enable = true;
    plugins = [
      "git"
      "sudo"
      "tmux"
    ];
    extraConfig = ''
      ZSH_TMUX_AUTOSTART=true
    '';
  };
  history = {
    append = true;
    size = 50000;
  };
  shellAliases = {
    lg = "${pkgs.lazygit}/bin/lazygit";
    update = "sudo nixos-rebuild switch --flake ~/nixos/#nixpad";
  };
  initExtra = import ./init.nix pkgs;
  plugins = [
    {
      name = "fzf-tab";
      src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
    }
    {
      name = "zsh-vi-mode";
      src = "${pkgs.zsh-vi-mode}/share/zsh-vi-mode";
    }
    {
      name = "powerlevel10k";
      src = pkgs.zsh-powerlevel10k;
      file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    }
    {
      name = "powerlevel10k-config";
      src = lib.cleanSource ./prompt;
      file = "p10k.zsh";
    }
  ];
}
