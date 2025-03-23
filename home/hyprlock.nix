pkgs: {
  enable = true;
  settings = {
    general = {
      disable_loading_bar = true;
      grace = 5;
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
        path = builtins.path {path = ./wallpaper/sunset-tree.jpg;};
        blur_passes = 0;
        blur_size = 0;
      }
    ];
    label = [
      {
        shadow_passes = 3;
        shadow_size = 1;
        shadow_boost = 0.3;
        text = "$TIME";
        font_family = "JetBrainsMono NF Light";
        color = "rgba(${(import ../theme.nix).primaryColorRGB},0.62)";
        font_size = 72;
        text_align = "center";
        halign = "center";
        valign = "top";
        position = "0, -102";
      }
      {
        shadow_passes = 2;
        shadow_size = 1;
        shadow_boost = 1;
        text = "cmd[update:60000] echo \"$(date +\"%a, %b %d\")  $(${pkgs.wttrbar}/bin/wttrbar --nerd --custom-indicator \"{ICON} {temp_C}°\" | ${pkgs.jq}/bin/jq .text -r)\"";
        font_family = "JetBrainsMono NF Light";
        color = "rgba(${(import ../theme.nix).primaryColorRGB},0.83)";
        font_size = 14;
        text_align = "center";
        halign = "center";
        valign = "top";
        position = "0, -218";
      }
      {
        shadow_passes = 2;
        shadow_size = 1;
        shadow_boost = 1.5;
        text = "cmd[update:128000] ${import ./scripts/date-trivia.nix pkgs} | ${pkgs.cowsay}/bin/cowsay -r";
        font_family = "JetBrainsMono Nerd Font";
        color = "rgba(${(import ../theme.nix).primaryColorRGB},0.72)";
        font_size = 8;
        text_align = "left";
        halign = "left";
        valign = "bottom";
        position = "20, 0";
      }
    ];
    input-field = [
      {
        size = "256, 42";
        rounding = 4;
        position = "0, 40";
        halign = "center";
        valign = "center";
        monitor = "";
        dots_center = true;
        fade_on_empty = false;
        font_color = "rgb(${(import ../theme.nix).secondaryColorRGB})";
        check_color = "rgb(${(import ../theme.nix).secondaryColorRGB})";
        inner_color = "rgb(${(import ../theme.nix).backgroundColorRGB})";
        outline_thickness = 0;
        fail_color = "rgb(${(import ../theme.nix).backgroundColorRGB})";
        fail_timeout = 4000;
        font_family = "JetBrainsMono Nerd Font";
        fail_text = "Keep Trying.";
        placeholder_text = "<span foreground=\"#${(import ../theme.nix).secondaryColor}\"> 󰌾 Locked </span>";
        shadow_passes = 4;
        shadow_size = 2;
      }
    ];
  };
}
