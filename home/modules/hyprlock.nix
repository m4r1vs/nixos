{
  config,
  lib,
  pkgs,
  scripts,
  theme,
  ...
}:
with lib; let
  cfg = config.programs.configured.hyprlock;
in {
  options.programs.configured.hyprlock = {
    enable = mkEnableOption "Enable custom hyprlock configuration";
  };

  config = mkIf cfg.enable {
    programs.hyprlock = {
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
            path = "${builtins.path {path = ../wallpaper/Sunset_Tree.jpg;}}";
            # blur_passes = 2;
            # blur_size = 4;
          }
        ];
        label = [
          {
            text = "$TIME";
            font_family = "JetBrainsMono NF Light";
            color = "rgba(${theme.backgroundColorLightRGB},0.86)";
            font_size = 72;
            text_align = "center";
            halign = "center";
            valign = "center";
            position = "0, 218";
            shadow_size = 4;
            shadow_passes = 4;
            shadow_color = "rgb(0,0,0)";
            shadow_boost = 3;
          }
          # {
          #   text = "cmd[update:128000] ${scripts.date-trivia} | ${pkgs.cowsay}/bin/cowsay -r";
          #   font_family = "JetBrainsMono Nerd Font";
          #   color = "rgba(${theme.backgroundColorLightRGB},0.22)";
          #   font_size = 8;
          #   text_align = "left";
          #   halign = "left";
          #   valign = "bottom";
          #   position = "70, 0";
          # }
          {
            text = " Plugged In"; # Consider making this dynamic based on battery status
            color = "rgba(${theme.backgroundColorLightRGB}, 0.86)";
            font_size = 12;
            font_family = "JetBrainsMono NF SemiBold";
            position = "-24, -24";
            text_align = "right";
            halign = "right";
            valign = "top";
            shadow_size = 2;
            shadow_passes = 3;
            shadow_color = "rgb(0,0,0)";
            shadow_boost = 3.2;
          }
          {
            # Use ./scripts relative to this file's location
            text = "cmd[update:1000] ${scripts.mpris-hyprlock} --title";
            color = "rgba(${theme.backgroundColorLightRGB}, 0.86)";
            font_size = 12;
            font_family = "JetBrainsMono NF SemiBold";
            position = "118, -24";
            text_align = "left";
            halign = "left";
            valign = "top";
            shadow_size = 2;
            shadow_passes = 3;
            shadow_color = "rgb(0,0,0)";
            shadow_boost = 2;
          }
          {
            text = "cmd[update:1000] ${scripts.mpris-hyprlock} --length";
            color = "rgba(${theme.backgroundColorLightRGB}, 0.56)";
            font_size = 12;
            font_family = "JetBrainsMono NF SemiBold";
            position = "118, -80";
            text_align = "left";
            halign = "left";
            valign = "top";
            shadow_size = 2;
            shadow_passes = 3;
            shadow_color = "rgb(0,0,0)";
            shadow_boost = 2;
          }
          {
            text = "cmd[update:1000] ${scripts.mpris-hyprlock} --source";
            color = "rgba(${theme.secondaryColorRGB}, 0.32)";
            font_size = 64;
            font_family = "JetBrainsMono Nerd Font";
            position = "-24, -6";
            text_align = "left";
            zindex = 1;
            halign = "left";
            valign = "top";
            shadow_size = 2;
            shadow_passes = 3;
            shadow_color = "rgb(0,0,0)";
            shadow_boost = 2;
          }
          {
            text = "cmd[update:1000] ${scripts.mpris-hyprlock} --artist";
            color = "rgba(${theme.backgroundColorLightRGB}, 0.56)";
            font_family = "JetBrainsMono Nerd Font";
            font_size = 12;
            position = "118, -46";
            text_align = "left";
            halign = "left";
            valign = "top";
            shadow_size = 2;
            shadow_passes = 3;
            shadow_color = "rgb(0,0,0)";
            shadow_boost = 2;
          }
          {
            text = "cmd[update:60000] echo \"$(date +\"%a, %b %d\")  $(${pkgs.wttrbar}/bin/wttrbar --nerd --custom-indicator \"{ICON} {temp_C}°\" | ${pkgs.jq}/bin/jq .text -r)\"";
            font_family = "JetBrainsMono NF Light";
            color = "rgba(${theme.backgroundColorLightRGB},0.72)";
            font_size = 14;
            text_align = "center";
            halign = "center";
            valign = "center";
            position = "0, 142";
            shadow_size = 2;
            shadow_passes = 3;
            shadow_color = "rgb(0,0,0)";
            shadow_boost = 4;
          }
          # {
          #   text = "cmd[update:2000] echo \" $(${scripts.fprint-privacy}) \"";
          #   font_family = "JetBrainsMono Nerd Font";
          #   color = "rgba(${theme.backgroundColorLightRGB},0.22)";
          #   font_size = 34;
          #   text_align = "center";
          #   halign = "center";
          #   valign = "bottom";
          #   position = "0, 162";
          # }
        ];
        input-field = [
          {
            size = "338, 42";
            position = "0, -38";
            halign = "center";
            valign = "center";
            monitor = "";
            dots_center = true;
            fade_on_empty = false;
            font_color = "rgba(${theme.primaryColorRGB},1)";
            rounding = 5;
            check_color = "rgba(${theme.primaryColorRGB},0.56)";
            inner_color = "rgba(${theme.backgroundColorRGB},0.92)";
            fail_color = "rgba(${theme.secondaryColorRGB},1)";
            outline_thickness = 0;
            fail_timeout = 4000;
            font_family = "JetBrainsMono Nerd Font";
            fail_text = "Keep Trying.";
            placeholder_text = " 󰌾 Password ";
            swap_font_color = true;
            shadow_size = 2;
            shadow_passes = 5;
            shadow_color = "rgb(0,0,0)";
            shadow_boost = 1.5;
          }
        ];
        image = [
          {
            size = 82;
            rounding = 5;
            border_size = 0;
            rotate = 0;
            reload_time = 2;
            reload_cmd = "${scripts.mpris-hyprlock} --arturl";
            position = "24, -21";
            halign = "left";
            valign = "top";
            zindex = 2;
            shadow_size = 2;
            shadow_passes = 4;
            shadow_color = "rgb(0,0,0)";
            shadow_boost = 1;
          }
        ];
      };
    };
  };
}
