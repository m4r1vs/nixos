pkgs:
{
      enable = true;
      package = pkgs.ghostty;
      clearDefaultKeybinds = true;
      enableZshIntegration = true;
      settings = {
        theme = "dark:cyberdream-dark,light:cyberdream-dark";
        window-padding-x = 4;
        window-padding-y = 4;
        gtk-titlebar = false;
        font-size = 10;
        font-family = "JetBrainsMono Nerd Font Propo";
        # font-family = "Apple Color Emoji";
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
      };
}
