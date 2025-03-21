pkgs: {
  enable = true;
  package = pkgs.brave;
  commandLineArgs = [
    "--ozone-platform-hint=auto"
    "--enable-features=TouchpadOverscrollHistoryNavigation"
  ];
}
