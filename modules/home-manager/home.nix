{systemArgs, ...}: let
  isDesktop = systemArgs.isDesktop;
in {
  imports = [
    ./modules
    ./packages.nix
  ];

  home = {
    username = systemArgs.username;
    homeDirectory = "/home/${systemArgs.username}";
    sessionVariables =
      if isDesktop
      then {
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
        NIXOS_OZONE_WL = "1";
      }
      else {};
    stateVersion = "24.05";
  };

  services = {
    configured = {
      cliphist.enable = isDesktop;
      darkman.enable = isDesktop;
      hypridle.enable = isDesktop;
      kdeconnect.enable = isDesktop;
      ollama.enable = true;
      swaync.enable = isDesktop;
    };
    blueman-applet.enable = isDesktop;
    mpris-proxy.enable = isDesktop;
    network-manager-applet.enable = isDesktop;
    polkit-gnome.enable = isDesktop;
    swww.enable = isDesktop;
  };

  programs = {
    configured = {
      brave.enable = isDesktop;
      direnv.enable = true;
      fzf.enable = true;
      ghostty.enable = isDesktop;
      git.enable = true;
      hyprland.enable = isDesktop;
      hyprlock.enable = isDesktop;
      lazygit.enable = true;
      mpv.enable = isDesktop;
      neovim.enable = true;
      newsboat.enable = true;
      rofi.enable = isDesktop;
      spotify-player.enable = true;
      ssh.enable = true;
      swappy.enable = isDesktop;
      tmux.enable = true;
      waybar.enable = isDesktop;
      yazi.enable = true;
      zsh.enable = true;
    };
    bat.enable = true;
    home-manager.enable = true;
    k9s.enable = true;
    obs-studio.enable = isDesktop;
    zoxide.enable = true;
  };

  configured = {
    gtk.enable = isDesktop;
    qt.enable = isDesktop;
    xdg.enable = isDesktop;
  };

  fonts.fontconfig.enable = isDesktop;
}
