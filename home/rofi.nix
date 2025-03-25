{pkgs, ...}
: {
  home.file."./.theme/rofi/dark.rasi".text =
    /*
    rasi
    */
    ''
      * {
        background-color: ${(import ../theme.nix).backgroundColor};
      }
      entry {
        text-color: #EFE7DD;
      }
      element {
        text-color: #EFE7DD;
      }
    '';
  home.file."./.theme/rofi/light.rasi".text =
    /*
    rasi
    */
    ''
      * {
        background-color: ${(import ../theme.nix).backgroundColorLight};
      }
      entry {
        text-color: #000000;
      }
      element {
        text-color: #000000;
      }
    '';
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    terminal = "${pkgs.ghostty}/bin/ghostty";
    extraConfig = {
      display-drun = "";
      display-dmenu = "";
      font = "JetBrainsMono Nerd Font 12";
      location = 0;
      icon-theme = "Papirus";
      show-icons = true;
      kb-remove-to-eol = "";
      kb-mode-complete = "";
      kb-move-end = "";
      kb-accept-entry = "Return,KP_Enter";
      kb-remove-char-back = "BackSpace,Shift+BackSpace";
      kb-row-up = ["Control+k" "Alt+k"];
      kb-row-down = ["Control+j" "Alt+j"];
      kb-row-right = ["Control+l" "Alt+l"];
      kb-row-left = ["Control+h" "Alt+h"];
      kb-page-prev = ["Control+y" "Alt+y"];
      kb-page-next = ["Control+e" "Alt+e"];
    };
    theme = toString (pkgs.writeText "style.rasi"
      /*
      rasi
      */
      ''
        * {
          separatorcolor:     transparent;
          border-color:       transparent;
        }

        window {
          fullscreen: false;
          orientation: vertical;
          width: 745px;
          height: 480px;
          border-radius: 4px;
        }

        mainbox {
          border-radius: 4px;
        }

        icon-current-entry {
          size: 22 px;
          background-color: inherit;
          padding: 11 6 11 14;
          alignment: vertical;
        }

        element {
          padding: 4 12;
        }

        element selected {
          background-color: ${(import ../theme.nix).primaryColor};
          border-radius: 3px;
        }

        element-text {
          background-color: inherit;
          text-color: inherit;
        }

        element-icon {
          size: 24 px;
          background-color: inherit;
          padding: 0 6 0 0;
          alignment: vertical;
        }

        listview {
          columns: 1;
          padding: 8 0;
          fixed-height: true;
          fixed-columns: true;
          fixed-lines: true;
          border: 0 10 6 10;
        }

        entry {
          placeholder-color: #474b4f;
          padding: 10 10 0 0;
          margin: 0 -2 0 0;
        }

        inputbar {
          padding: 0 0 0 8;
          margin: 0 0 0 0;
          children: [icon-current-entry, entry];
        }

        prompt {
          enabled: false;
        }

        @import "~/.theme/rofi/current.rasi"
      '');
  };
}
