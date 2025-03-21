pkgs: {
  enable = true;
  package = pkgs.ghostty;
  clearDefaultKeybinds = true;
  enableZshIntegration = true;
  settings = {
    theme = "dark:cyberdream-dark,light:cyberdream-light";
    window-padding-x = 4;
    window-padding-y = 4;
    gtk-titlebar = false;
    font-size = 10;
    font-family = [
      "JetBrainsMono Nerd Font Propo"
      "Apple Color Emoji"
    ];
    confirm-close-surface = false;
    resize-overlay = "never";
    window-decoration = false;
    window-padding-balance = true;
    link-url = true;
    keybind = [
      "ctrl+i=csi:6~"
      "ctrl+minus=decrease_font_size:1"
      "ctrl+equal=increase_font_size:1"
      "ctrl+plus=increase_font_size:1"
      "ctrl+shift+v=paste_from_clipboard"
      "ctrl+shift+c=copy_to_clipboard"
      "ctrl+shift+i=inspector:toggle"
      "ctrl+zero=reset_font_size"
      "shift+insert=paste_from_selection"
    ];
  };
  themes = {
    cyberdream-dark = {
      palette = [
        "0=#16181a"
        "1=#ff6e5e"
        "2=#5eff6c"
        "3=#f1ff5e"
        "4=#5ea1ff"
        "5=#bd5eff"
        "6=#5ef1ff"
        "7=#ffffff"
        "8=#3c4048"
        "9=#ff6e5e"
        "10=#5eff6c"
        "11=#f1ff5e"
        "12=#5ea1ff"
        "13=#bd5eff"
        "14=#5ef1ff"
        "15=#ffffff"
      ];
      background = "#131313";
      foreground = "#ffffff";
      cursor-color = "#ffffff";
      selection-background = "#3c4048";
      selection-foreground = "#ffffff";
      background-opacity = 0.89;
    };
    cyberdream-light = {
      palette = [
        "0=#100f0f"
        "1=#af3029"
        "2=#66800b"
        "3=#ad8301"
        "4=#205ea6"
        "5=#a02f6f"
        "6=#24837b"
        "7=#f2f0e5"
        "8=#575653"
        "9=#d14d41"
        "10=#879a39"
        "11=#d0a215"
        "12=#4385be"
        "13=#ce5d97"
        "14=#3aa99f"
        "15=#fffcf0"
      ];
      background = "#fffcf0";
      foreground = "#100f0f";
      cursor-color = "#100f0f";
      selection-background = "#cecdc3";
      selection-foreground = "#100f0f";
      background-opacity = 1;
    };
  };
}
