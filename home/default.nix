{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./neovim
    ./xdg.nix
    ./swappy.nix
    ./hyprland.nix

    ./services/cliphist.nix
    ./services/darkman.nix
    ./services/kdeconnect.nix
    ./services/swaync.nix
    ./services/hypridle.nix
  ];

  home = {
    username = "mn";
    homeDirectory = "/home/mn";
    packages = import ./packages.nix pkgs;
    sessionVariables = {
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      NIXOS_OZONE_WL = "1";
    };
    stateVersion = "24.05";
  };

  services = {
    blueman-applet.enable = true;
    network-manager-applet.enable = true;
    polkit-gnome.enable = true;
    swww.enable = true;
  };

  programs = {
    bat = import ./bat.nix;
    chromium = import ./brave.nix pkgs;
    direnv = import ./direnv.nix;
    fzf = import ./fzf.nix;
    ghostty = import ./ghostty.nix pkgs;
    git = import ./git.nix;
    home-manager.enable = true;
    hyprlock = import ./hyprlock.nix pkgs;
    lazygit = import ./lazygit.nix;
    rofi = import ./rofi.nix pkgs;
    spotify-player = import ./spotify-player.nix pkgs;
    ssh = import ./ssh.nix;
    tmux = import ./tmux {
      inherit pkgs;
      inherit lib;
    };
    waybar = import ./waybar pkgs;
    yazi = import ./yazi {
      inherit pkgs;
    };
    zoxide = import ./zoxide.nix;
    zsh = import ./zsh {
      inherit pkgs;
      inherit lib;
    };
  };

  gtk = import ./gtk.nix pkgs;

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };

  fonts.fontconfig.enable = true;
}
