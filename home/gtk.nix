pkgs: {
  enable = true;
  theme = {
    package = pkgs.whitesur-gtk-theme;
    name = "WhiteSur";
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
    name = "JetBrainsMono Nerd Font Proto";
    size = 10;
  };
}
