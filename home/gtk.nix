pkgs: {
  enable = true;
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
    package = pkgs.nerd-fonts.jetbrains-mono;
    name = "JetBrainsMono NF";
    size = 10;
  };
}
