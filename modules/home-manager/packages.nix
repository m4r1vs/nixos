{
  pkgs,
  systemArgs,
  ...
}: let
  isDesktop = systemArgs.isDesktop;
in {
  home.packages = with pkgs;
    [
      fastfetch
      yt-dlp
    ]
    ++ (
      if isDesktop
      then [
        amberol
        blender
        dbeaver-bin
        diebahn
        discord
        gimp-with-plugins
        gnome-chess
        gnome-clocks
        gnome-decoder
        gnome-network-displays
        libnotify
        inkscape-with-extensions
        kdePackages.kwalletmanager
        nautilus
        nerd-fonts.jetbrains-mono
        networkmanagerapplet
        obsidian
        pavucontrol
        polkit_gnome
        slack
        spotify
        stockfish
        wireplumber
        zathura
      ]
      else []
    );
}
