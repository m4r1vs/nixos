{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.configured.gtk;
in {
  options.configured.gtk = {
    enable = mkEnableOption "Gnome/GNU/GUI Toolkit";
  };
  config = mkIf cfg.enable {
    gtk = {
      enable = true;
      gtk3 = {
        bookmarks = [
          "file:///home/mn/Desktop"
          "file:///home/mn/Downloads"
          "file:///home/mn/Documents"
          "file:///home/mn/Pictures"
          "file:///home/mn/Music"
          "file:///home/mn/Projects"
          "file:///home/mn/Videos"
        ];
      };
      theme = {
        package = pkgs.gnome-themes-extra;
        name = "Adwaita";
      };
      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus";
      };
      cursorTheme = {
        package = pkgs.bibata-cursors;
        size = 20;
        name = "Bibata-Modern-Ice";
      };
      font = {
        package = pkgs.ubuntu_font_family;
        name = "Ubuntu";
        size = 10;
      };
    };
  };
}
