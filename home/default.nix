{...}: {
  imports = [
    ./modules
    ./packages.nix
  ];

  home = {
    username = "mn";
    homeDirectory = "/home/mn";
    sessionVariables = {
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      NIXOS_OZONE_WL = "1";
    };
    stateVersion = "24.05";
  };

  services = {
    configured = {
      cliphist.enable = true;
      darkman.enable = true;
      dunst.enable = false;
      hypridle.enable = true;
      kdeconnect.enable = true;
      ollama.enable = true;
      swaync.enable = true;
    };
    blueman-applet.enable = true;
    mpris-proxy.enable = true;
    network-manager-applet.enable = true;
    polkit-gnome.enable = true;
    swww.enable = true;
  };

  programs = {
    configured = {
      brave.enable = true;
      direnv.enable = true;
      fzf.enable = true;
      ghostty.enable = true;
      git.enable = true;
      hyprland.enable = true;
      hyprlock.enable = true;
      lazygit.enable = true;
      mpv.enable = true;
      neovim.enable = true;
      newsboat.enable = true;
      rofi.enable = true;
      spotify-player.enable = true;
      ssh.enable = true;
      swappy.enable = true;
      tmux.enable = true;
      waybar.enable = true;
      yazi.enable = true;
      zsh.enable = true;
    };
    bat.enable = true;
    home-manager.enable = true;
    k9s.enable = true;
    obs-studio.enable = true;
    zoxide.enable = true;
  };

  configured = {
    gtk.enable = true;
    qt.enable = true;
    xdg.enable = true;
  };

  fonts.fontconfig.enable = true;
}
