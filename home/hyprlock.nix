pkgs: {
  enable = true;
  settings = {
    general = {
      disable_loading_bar = true;
      grace = 5;
      text_trim = false;
      hide_cursor = true;
    };
    auth = {
      fingerprint = {
        enabled = true;
      };
      pam = {
        enabled = true;
      };
    };
    animations = {
      enabled = true;
      bezier = [
        "fade, 0.05, 0.9, 0.1, 1"
      ];
      animation = [
        "fade, 1, 5, fade"
        "inputFieldColors, 1, 3, fade"
      ];
    };
    background = [
      {
        path = builtins.path {path = ./wallpaper/Sunset_Tree.jpg;};
        blur_passes = 2;
        blur_size = 4;
        new_optimizations = true;
      }
    ];
    label = [
      {
        text = "$TIME";
        font_family = "JetBrainsMono NF Light";
        color = "rgba(255,255,255,0.54)";
        font_size = 72;
        text_align = "center";
        halign = "center";
        valign = "top";
        position = "0, -102";
      }
      {
        text = "cmd[update:60000] echo \"$(date +\"%a, %b %d\")  $(${pkgs.wttrbar}/bin/wttrbar --nerd --custom-indicator \"{ICON} {temp_C}°\" | ${pkgs.jq}/bin/jq .text -r)\"";
        font_family = "JetBrainsMono NF Light";
        color = "rgba(255,255,255,0.42)";
        font_size = 14;
        text_align = "center";
        halign = "center";
        valign = "top";
        position = "0, -218";
      }
      {
        text = "cmd[update:128000] ${import ./scripts/date-trivia.nix pkgs} | ${pkgs.cowsay}/bin/cowsay -r";
        font_family = "JetBrainsMono Nerd Font";
        color = "rgba(255,255,255,0.32)";
        font_size = 8;
        text_align = "left";
        halign = "left";
        valign = "bottom";
        position = "70, 0";
      }
    ];
    input-field = [
      {
        size = "556, 42";
        position = "0, 192";
        halign = "center";
        valign = "bottom";
        monitor = "";
        dots_center = true;
        fade_on_empty = false;
        font_color = "rgba(255,255,255,0.78)";
        check_color = "rgba(0,0,0,0)";
        inner_color = "rgba(0,0,0,0)";
        fail_color = "rgba(0,0,0,0)";
        font_size = 18;
        outline_thickness = 0;
        fail_timeout = 4000;
        font_family = "JetBrainsMono Nerd Font";
        fail_text = "Keep Trying.";
        placeholder_text = "Type Password or Swipe Finger";
      }
    ];
  };
}
