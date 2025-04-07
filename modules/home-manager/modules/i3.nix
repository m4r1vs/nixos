{
  lib,
  config,
  scripts,
  systemArgs,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.configured.i3;
  theme = systemArgs.theme;
in {
  options.programs.configured.i3 = {
    enable = mkEnableOption "Tiling Wayland Window Manager";
  };
  config = mkIf cfg.enable {
    xsession.windowManager.i3 = {
      enable = true;
      config = {
        modifier = "Mod4";
        gaps = {
          inner = 7;
          smartGaps = false;
        };
        bars = [];
        startup = [
          {
            command = "${pkgs.writeShellScript "launch-polybar" ''
              polybar-msg cmd quit
              if type "xrandr"; then
                for m in $(xrandr --query | grep " connected" | cut -d " " -f1); do
                  MONITOR=$m polybar --reload polybar &
                done
              else
                polybar --reload polybar &
              fi
            ''}";
            always = true;
            notification = false;
          }
          {
            command = "${scripts.brightness-change-notify}";
            always = true;
            notification = false;
          }
          {
            command = "${scripts.volume-change-notify}";
            always = true;
            notification = false;
          }
          {
            command = "${pkgs.kdePackages.kwallet-pam}/libexec/pam_kwallet_init";
            always = true;
            notification = false;
          }
          {
            command = "${pkgs._1password-gui}/bin/1password --silent --ozone-platform-hint=x11";
            always = true;
            notification = false;
          }
          {
            command = "${pkgs.slack}/bin/slack --silent";
            always = true;
            notification = false;
          }
        ];
        terminal = "${pkgs.ghostty}/bin/ghostty";
        keybindings = let
          mod = config.xsession.windowManager.i3.config.modifier;
          terminal = config.xsession.windowManager.i3.config.terminal;
        in {
          "${mod}+Return" = "exec ${terminal}";
          "${mod}+q" = "kill";
          "${mod}+Shift+q" = "exec --no-startup-id ${pkgs.writeShellScript "rofi-power-menu" ''
            ${config.programs.rofi.package}/bin/rofi -show power-menu -modi power-menu:${scripts.rofi-power-menu} -theme-str "entry {placeholder:\"Power Menu...\";}element-icon{enabled:false;}icon-current-entry{enabled:false;}inputbar{padding: 0 0 0 42;}window{padding: 38% 44%;}"
          ''}";
          "${mod}+d" = "exec --no-startup-id ${pkgs.writeShellScript "rofi-launcher" ''
            ${config.programs.rofi.package}/bin/rofi -theme-str "entry {placeholder: \"Launch a Program...\";}entry{padding: 10 10 0 12;}" -combi-modi search:${scripts.rofi-search},drun -show combi
          ''}";

          "${mod}+m" = "exec --no-startup-id ${pkgs.writeShellScript "rofi-emoji" ''
            ${pkgs.rofimoji}/bin/rofimoji --selector-args="-theme-str \"listview{dynamic:true;columns:12;layout:vertical;flow:horizontal;reverse:false;lines:10;}element-text{enabled:false;}element-icon{size:32px;}icon-current-entry{enabled:false;}inputbar{padding: 0 0 0 24;}\"" --use-icons --skin-tone neutral --selector rofi --max-recent 0 --action clipboard
          ''}";

          "${mod}+h" = "focus left";
          "${mod}+j" = "focus down";
          "${mod}+k" = "focus up";
          "${mod}+l" = "focus right";

          "${mod}+Shift+d" = "exec ${pkgs.darkman}/bin/darkman toggle";
          "${mod}+Shift+w" = "exec --no-startup-id ${pkgs.feh}/bin/feh --bg-fill --randomize ${builtins.path {path = ../wallpaper;}}/*";
          "${mod}+Shift+s" = "exec --no-startup-id ${pkgs.flameshot}/bin/flameshot gui";
          "${mod}+Shift+n" = "move workspace to output next";

          "${mod}+Shift+h" = "move left";
          "${mod}+Shift+j" = "move down";
          "${mod}+Shift+k" = "move up";
          "${mod}+Shift+l" = "move right";

          "${mod}+f" = "fullscreen toggle";

          "${mod}+t" = "layout toggle split";

          "${mod}+Shift+space" = "floating toggle";

          # "${mod}+space" = "focus mode_toggle";

          "${mod}+Shift+minus" = "move scratchpad";
          "${mod}+minus" = "scratchpad show";

          "${mod}+1" = "workspace number 1";
          "${mod}+2" = "workspace number 2";
          "${mod}+3" = "workspace number 3";
          "${mod}+4" = "workspace number 4";
          "${mod}+5" = "workspace number 5";
          "${mod}+6" = "workspace number 6";
          "${mod}+7" = "workspace number 7";
          "${mod}+8" = "workspace number 8";
          "${mod}+9" = "workspace number 9";
          "${mod}+0" = "workspace number 10";

          "${mod}+Shift+1" = "move container to workspace number 1";
          "${mod}+Shift+2" = "move container to workspace number 2";
          "${mod}+Shift+3" = "move container to workspace number 3";
          "${mod}+Shift+4" = "move container to workspace number 4";
          "${mod}+Shift+5" = "move container to workspace number 5";
          "${mod}+Shift+6" = "move container to workspace number 6";
          "${mod}+Shift+7" = "move container to workspace number 7";
          "${mod}+Shift+8" = "move container to workspace number 8";
          "${mod}+Shift+9" = "move container to workspace number 9";
          "${mod}+Shift+0" = "move container to workspace number 10";

          "${mod}+r" = "mode resize";
        };
      };
      extraConfig = ''
        default_border pixel 0
      '';
    };
    programs = {
      autorandr.enable = true;
    };
    services = {
      configured = {
        dunst.enable = true;
      };
      polybar = {
        enable = true;
        package = pkgs.polybar;
        script = "sleep infinity"; # Polybar started in i3
        settings = {
          settings = {
            screenchange-reload = "true";
            pseudo-transparency = "false";
          };
          colors = {
            background = "#DD${lib.strings.removePrefix "#" theme.backgroundColor}";
            background-alt = "#060606";
            foreground = "#C5C8C6";
            primary = "${theme.primaryColor.hex}";
            secondary = "${theme.secondaryColor.hex}";
            alert = "#A54242";
            disabled = "#707880";
          };
          "bar/polybar" = {
            monitor = "\${env:MONITOR:}";
            width = "100%";
            height = "20pt";
            radius = "0";
            background = "\${colors.background}";
            foreground = "\${colors.foreground}";
            line-size = "3pt";
            border-size = "0pt";
            border-color = "#00000000";
            padding-left = "0";
            padding-right = "0";
            module-margin = "0";
            separator = "\" 󰇙 \"";
            separator-foreground = "\${colors.disabled}";
            font-0 = "JetBrainsMono Nerd Font:style=SemiBold:size=10:antialias=true;2";
            modules-left = "date pulseaudio";
            modules-center = "i3 xworkspaces";
            modules-right = "tray battery memory cpu wlan eth";
            cursor-click = "pointer";
            cursor-scroll = "ns-resize";
            enable-ipc = "true";
            wm-restack = "i3";
          };
          "module/pulseaudio" = {
            type = "internal/pulseaudio";
            use-ui-max = false;
            format-volume-prefix-foreground = "\${colors.secondary}";
            format-volume = "<ramp-volume> <label-volume>";
            label-volume = "%percentage%%";
            ramp-volume-0 = "%{F${theme.secondaryColor.hex}}󰕿%{F-}";
            ramp-volume-1 = "%{F${theme.secondaryColor.hex}}󰖀%{F-}";
            ramp-volume-2 = "%{F${theme.secondaryColor.hex}}󰕾%{F-}";
            label-muted = "󰖁";
            label-muted-foreground = "\${colors.disabled}";
          };
          "module/i3" = {
            type = "internal/i3";
            format = "<label-mode>";
            label-mode = "%{F#EE8000}  %mode% mode%{F-}";
            pin-workspaces = "true";
          };
          "module/battery" = {
            type = "internal/battery";
            full-at = "99";
            low-at = "20";
            battery = "BAT0";
            adapter = "AC";
            poll-interval = "5";
            format-discharging = "<ramp-capacity>";
            label-full = "%{F#EE8000}󱟢%{F-}";
            label-charging = "%{F#EE8000}󰂄%{F-} %percentage%%";
            label-low = "%{F#EE8000}󰂃%{F-} %percentage%%";
            ramp-capacity-0 = "%{F#EE8000}󰁻%{F-}";
            ramp-capacity-1 = "%{F#EE8000}󰁼%{F-}";
            ramp-capacity-2 = "%{F#EE8000}󰁾%{F-}";
            ramp-capacity-3 = "%{F#EE8000}󰂁%{F-}";
            ramp-capacity-4 = "%{F#EE8000}󰁹%{F-}";
          };
          "module/xworkspaces" = {
            type = "internal/xworkspaces";
            pin-workspaces = "true";
            group-by-monitor = "true";
            label-active = "%{F#EE8000}%name%%{F-}";
            label-active-padding = "1";
            label-occupied = "%{F#008e2f}%name%%{F-}";
            label-occupied-padding = "1";
            label-urgent = "%{F#8e002f}%name%%{F-}";
            label-urgent-padding = "1";
            label-empty = "%{F#008e2f}%name%%{F-}";
            label-empty-padding = "1";
          };
          "module/tray" = {
            type = "internal/tray";
            format-margin = "0px";
            tray-spacing = "4px";
          };
          "module/memory" = {
            type = "internal/memory";
            interval = "2";
            format-prefix = " ";
            format-prefix-foreground = "\${colors.secondary}";
            label = "%gb_free%";
          };
          "module/cpu" = {
            type = "internal/cpu";
            interval = "2";
            format-prefix = " ";
            format-prefix-foreground = "\${colors.secondary}";
            label = "%percentage:2%%";
          };
          network-base = {
            type = "internal/network";
            interval = 5;
          };
          "module/wlan" = {
            "inherit" = "network-base";
            interface-type = "wireless";
            interface = "wlp0s20f3";
            format-connected = "%{F#EE8000}<ramp-signal>%{F-} <label-connected>";
            label-connected = "%local_ip% ";
            label-disconnected = "%{F#EE8000}󰤭%{F-}";
            format-packetloss = "<label-packetloss>";
            label-packetloss = "󰤣";
            ramp-signal-0 = "󰤯";
            ramp-signal-1 = "󰤟";
            ramp-signal-2 = "󰤢";
            ramp-signal-3 = "󰤥";
            ramp-signal-4 = "󰤨";
            ramp-signal-5 = "󰤨";
          };
          "module/eth" = {
            "inherit" = "network-base";
            interface-type = "wired";
            interface = "enp0s31f6";
            label-connected = "%{F#EE8000}󰒍%{F-}";
          };
          "module/date" = {
            type = "internal/date";
            interval = "1";
            date = "%d.%m.%Y %H:%M";
            label = "\" %date%\"";
            label-foreground = "\${colors.primary}";
          };
        };
      };
      picom = {
        enable = true;
        shadow = true;
        fade = true;
        vSync = true;
        inactiveOpacity = 0.92;
        fadeDelta = 3;
        shadowOpacity = 0.58;
        shadowOffsets = [(-20) (-10)];
        backend = "glx";
        settings = {
          blur = {
            method = "dual_kawase";
            strength = 8;
          };
          shadow-radius = 20;
          corner-radius = 5;
          detect-rounded-corners = true;
          detect-client-opacity = true;
          detect-transient = true;
          shadow-exclude = [
            "window_type = 'dock'"
            "window_type = 'menu'"
            "window_type = 'dropdown_menu'"
            "window_type = 'popup_menu'"
            "window_type = 'tooltip'"
          ];
          rounded-corners-exclude = [
            "window_type = 'dock'"
          ];
          blur-background-exclude = [
            "window_type = 'menu'"
            "window_type = 'dropdown_menu'"
            "window_type = 'popup_menu'"
            "window_type = 'tooltip'"
          ];
        };
      };
    };
  };
}
