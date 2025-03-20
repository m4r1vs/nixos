pkgs: {
  package = pkgs.waybar;
  enable = true;
  style = builtins.readFile ./style.css;
  settings = {
    mainBar = {
      layer = "top";
      position = "bottom";
      mod = "dock";
      height = 28;
      exclusive = true;
      passthrough = false;
      gtk-layer-shell = true;
      reload_style_on_change = true;

      modules-left = ["custom/padd" "custom/l_end" "idle_inhibitor" "clock" "cpu" "memory" "custom/cpuinfo" "custom/r_end" "custom/padd"];
      modules-center = ["custom/padd" "custom/l_end" "hyprland/workspaces" "custom/r_end" "custom/padd"];
      modules-right = ["custom/padd" "custom/l_end" "backlight" "network" "pulseaudio" "custom/updates" "custom/r_end" "custom/l_end" "privacy" "tray" "battery" "custom/r_end" "custom/padd"];

      idle_inhibitor = {
        format = "{icon}";
        rotate = 0;
        format-icons = {
          activated = "󰥔";
          deactivated = "";
        };
      };

      clock = {
        format = "{:%I:%M %p}";
        rotate = 0;
        format-alt = "{:%R 󰃭 %d·%m·%y}";
        tooltip-format = "<span>{calendar}</span>";
        calendar = {
          mode = "month";
          mode-mon-col = 3;
          on-scroll = 1;
          on-click-right = "mode";
          format = {
            months = "<span color='#ffead3'><b>{}</b></span>";
            weekdays = "<span color='#ffcc66'><b>{}</b></span>";
            today = "<span color='#ff6699'><b>{}</b></span>";
          };
        };
        actions = {
          on-click-right = "mode";
          on-click-forward = "tz_up";
          on-click-backward = "tz_down";
          on-scroll-up = "shift_up";
          on-scroll-down = "shift_down";
        };
      };

      cpu = {
        interval = 10;
        format = "󰍛 {usage}%";
        rotate = 0;
        format-alt = "{icon0}{icon1}{icon2}{icon3}";
        format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
      };

      memory = {
        states = {
          c = 90;
          h = 60;
          m = 30;
        };
        interval = 30;
        format = " {used}GB";
        rotate = 0;
        format-m = " {used}GB";
        format-h = " {used}GB";
        format-c = " {used}GB";
        format-alt = " {percentage}%";
        max-length = 10;
        tooltip = true;
        tooltip-format = " {percentage}%\n {used:0.1f}GB/{total:0.1f}GB";
      };

      "custom/cpuinfo" = {
        exec = "${import ../scripts/cpu-info.nix pkgs}/bin/cpu-info";
        return-type = "json";
        format = "{}";
        rotate = 0;
        interval = 10;
        tooltip = true;
        max-length = 1000;
      };

      # "custom/spotify = {
      #     "exec = "mediaplayer.py --player spotify";
      #     "format = " {}";
      #     "rotate = 0;
      #     "return-type = "json";
      #     "on-click = "playerctl play-pause --player spotify";
      #     "on-click-right = "playerctl next --player spotify";
      #     "on-click-middle = "playerctl previous --player spotify";
      #     "on-scroll-up = "volumecontrol.sh -p spotify i";
      #     "on-scroll-down = "volumecontrol.sh -p spotify d";
      #     "max-length = 40;
      #     "escape = true;
      #     "tooltip = true
      # };
      "hyprland/workspaces" = {
        rotate = 0;
        all-outputs = false;
        active-only = false;
        on-click = "activate";
        disable-scroll = true;
        on-scroll-up = "${pkgs.hyprland}/bin/hyprctl dispatch workspace -1";
        on-scroll-down = "${pkgs.hyprland}/bin/hyprctl dispatch workspace +1";
        persistent-workspaces = {};
      };
      backlight = {
        device = "intel_backlight";
        rotate = 0;
        format = "{icon} {percent}%";
        format-icons = ["" "" "" "" "" "" "" "" ""];
        on-scroll-up = "${pkgs.brightnessctl}/bin/brightnessctl set 1%+";
        on-scroll-down = "${pkgs.brightnessctl}/bin/brightnessctl set 1%-";
        min-length = 6;
      };

      network = {
        tooltip = true;
        format-wifi = "";
        rotate = 0;
        format-ethernet = "󰈀";
        tooltip-format = "Network: <big><b>{essid}</b></big>\nSignal strength: <b>{signaldBm}dBm ({signalStrength}%)</b>\nFrequency: <b>{frequency}MHz</b>\nInterface: <b>{ifname}</b>\nIP: <b>{ipaddr}/{cidr}</b>\nGateway: <b>{gwaddr}</b>\nNetmask: <b>{netmask}</b>";
        format-linked = "󰈀 {ifname} (No IP)";
        format-disconnected = "󰖪";
        tooltip-format-disconnected = "Disconnected";
        format-alt = "<span foreground='#99ffdd'> {bandwidthDownBytes}</span> <span foreground='#ffcc66'> {bandwidthUpBytes}</span>";
        interval = 2;
      };

      pulseaudio = {
        format = "{icon} {volume}";
        rotate = 0;
        format-muted = "";
        on-click = "${pkgs.pavucontrol}/bin/pavucontrol -t 3";
        on-click-right = "${pkgs.pamixer}/bin/pamixer -t";
        on-scroll-up = "${pkgs.pamixer}/bin/pamixer -i 1";
        on-scroll-down = "${pkgs.pamixer}/bin/pamixer -d 1";
        tooltip-format = "{icon} {desc} // {volume}%";
        scroll-step = 5;
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = ["" "" ""];
        };
      };

      # "pulseaudio#microphone = {
      #     "format = "{format_source}";
      #     "rotate = 0;
      #     "format-source = "";
      #     "format-source-muted = "";
      #     "on-click = "pavucontrol -t 4";
      #     "on-click-middle = "volumecontrol.sh -i m";
      #     "on-scroll-up = "volumecontrol.sh -i i";
      #     "on-scroll-down = "volumecontrol.sh -i d";
      #     "tooltip-format = "{format_source} {source_desc} // {source_volume}%";
      #     "scroll-step = 5
      # };

      #    "custom/updates = {
      #        "exec = "systemupdate.sh";
      #        "return-type = "json";
      #        "format = "{}";
      #        "rotate = 0;
      #        "on-click = "hyprctl dispatch exec 'systemupdate.sh up'";
      #        "interval = 86400, // once every day
      #        "tooltip = true;
      #        "signal = 20;
      #    };
      privacy = {
        icon-size = 12;
        icon-spacing = 5;
        transition-duration = 250;
        modules = [
          {
            type = "screenshare";
            tooltip = true;
            tooltip-icon-size = 24;
          }
          {
            type = "audio-in";
            tooltip = true;
            tooltip-icon-size = 24;
          }
        ];
      };

      tray = {
        icon-size = 14;
        rotate = 0;
        spacing = 5;
      };

      battery = {
        states = {
          good = 95;
          warning = 30;
          critical = 20;
        };
        format = "{icon} {capacity}%";
        rotate = 0;
        format-charging = " {capacity}%";
        format-plugged = " {capacity}%";
        format-alt = "{time} {icon}";
        format-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
      };

      "custom/l_end" = {
        format = " ";
        interval = "once";
        tooltip = false;
      };

      "custom/r_end" = {
        format = " ";
        interval = "once";
        tooltip = false;
      };

      "custom/sl_end" = {
        format = " ";
        interval = "once";
        tooltip = false;
      };

      "custom/sr_end" = {
        format = " ";
        interval = "once";
        tooltip = false;
      };

      "custom/rl_end" = {
        format = " ";
        interval = "once";
        tooltip = false;
      };

      "custom/rr_end" = {
        format = " ";
        interval = "once";
        tooltip = false;
      };

      "custom/padd" = {
        format = "  ";
        interval = "once";
        tooltip = false;
      };
    };
  };
}
