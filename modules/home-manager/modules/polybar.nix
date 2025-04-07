{
  lib,
  config,
  pkgs,
  systemArgs,
  ...
}:
with lib; let
  cfg = config.services.configured.polybar;
  theme = systemArgs.theme;
in {
  options.services.configured.polybar = {
    enable = mkEnableOption "Enable Polybar Statusbar";
  };
  config = mkIf cfg.enable {
    services.polybar = {
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
  };
}
