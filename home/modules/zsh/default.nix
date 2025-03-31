{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.configured.zsh;
in {
  options.programs.configured.zsh = {
    enable = mkEnableOption "Z-Shell";
  };
  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      package = pkgs.zsh;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
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
        rebuild = "nix flake update executables --flake ~/NixOS && sudo nixos-rebuild switch --flake ~/NixOS/#nixpad";
        upgrade = "nix flake update --flake ~/NixOS && sudo nixos-rebuild switch --flake ~/NixOS/#nixpad";
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
    };
  };
}
