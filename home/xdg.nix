{pkgs, ...}: {
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };
    desktopEntries = {
      rofi-theme-selector = {
        name = "Hidden Rofi Theme Selector";
        noDisplay = true;
      };
      rofi = {
        name = "Hidden Rofi";
        noDisplay = true;
      };
      brave-browser = {
        name = "CC.systems Browser";
        exec = ''${pkgs.brave}/bin/brave --profile-directory=cc-profile --ozone-platform-hint=auto --enable-features=TouchpadOverscrollHistoryNavigation %U'';
        icon = "brave-browser-dev";
        terminal = false;
        type = "Application";
        categories = ["WebBrowser" "Network"];
        mimeType = [
          "application/pdf"
          "application/rdf+xml"
          "application/rss+xml"
          "application/xhtml+xml"
          "application/xhtml_xml"
          "application/xml"
          "image/gif"
          "image/jpeg"
          "image/png"
          "image/webp"
          "text/html"
          "text/xml"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
        ];
      };
      brave-personal = {
        name = "Personal Browser";
        exec = ''${pkgs.brave}/bin/brave --profile-directory=Default --ozone-platform-hint=auto --enable-features=TouchpadOverscrollHistoryNavigation %U'';
        icon = "brave-browser-nightly";
        terminal = false;
        type = "Application";
        categories = ["WebBrowser" "Network"];
        mimeType = [
          "application/pdf"
          "application/rdf+xml"
          "application/rss+xml"
          "application/xhtml+xml"
          "application/xhtml_xml"
          "application/xml"
          "image/gif"
          "image/jpeg"
          "image/png"
          "image/webp"
          "text/html"
          "text/xml"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
        ];
      };
    };
    portal.extraPortals = [
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-termfilechooser
    ];
  };
  home.file."./.config/xdg-desktop-portal-termfilechooser/config".text = ''
    [filechooser]
    cmd=${import ./scripts/term-file-chooser.nix pkgs}
    default_dir=$HOME
    env=TERMCMD=${pkgs.ghostty}/bin/ghostty
  '';
}
