{pkgs, ...}: {
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = ["org.pwmt.zathura-pdf-mupdf.desktop"];
        "inode/directory" = ["yazi.desktop"];
      };
    };
    desktopEntries = {
      yazi = {
        name = "Yazi";
        icon = "duckstation";
        comment = "Blazing fast terminal file manager written in Rust, based on async I/O";
        terminal = false;
        exec = "${pkgs.ghostty}/bin/ghostty --class=ghostty.yazi -e ${pkgs.yazi}/bin/yazi %u";
        type = "Application";
        mimeType = ["inode/directory"];
        categories = ["Utility" "Core" "System" "FileTools" "FileManager"];
      };
      darkman = {
        name = "Toggle Darkmode";
        genericName = "Darkman";
        exec = "${pkgs.darkman}/bin/darkman toggle";
        icon = "com.github.coslyk.MoonPlayer";
        type = "Application";
        noDisplay = true;
        categories = ["Settings"];
      };
      spotify_player = {
        name = "Spotify TUI";
        genericName = "Spotify";
        icon = "spotify-client";
        type = "Application";
        categories = ["Music"];
        noDisplay = true;
      };
      blueman = {
        name = "Bluetooth";
        genericName = "Blueman";
        icon = "blueman";
        type = "Application";
        categories = ["Settings"];
        noDisplay = true;
      };
      nixpad = {
        name = "Marius' NixPad";
        genericName = "NixOS on ThinkPad";
        icon = "nix-snowflake";
        type = "Application";
        categories = ["Settings"];
        noDisplay = true;
      };
      brave-browser = {
        name = "CC.systems Browser";
        exec = ''${pkgs.brave}/bin/brave --profile-directory=cc-profile --disable-session-restore --ozone-platform-hint=auto --enable-features=TouchpadOverscrollHistoryNavigation %U'';
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
        exec = ''${pkgs.brave}/bin/brave --profile-directory=Default --disable-session-restore --ozone-platform-hint=auto --enable-features=TouchpadOverscrollHistoryNavigation %U'';
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
  home.file."./.config/xdg-desktop-portal/portals.conf".text = ''
    [preferred]
    org.freedesktop.impl.portal.FileChooser=termfilechooser
  '';
}
