pkgs: {
  enable = true;
  package = pkgs.brave;
  commandLineArgs = [
    "--ozone-platform-hint=wayland"
    "--enable-features=TouchpadOverscrollHistoryNavigation"
    "--use-gl=desktop"
  ];
}
