{pkgs, ...}: {
  wayland.windowManager.hyprland = {
    enable = true;
    plugins = with pkgs; [
      hypr-dynamic-cursors
      hyprfocus
    ];
    settings = {
      exec-once = [
        "${pkgs.waybar}/bin/waybar"
        "${pkgs._1password-gui}/bin/1password --silent --ozone-platform-hint=x11"
        "${pkgs.slack}/bin/slack"
        "${import ./scripts/volume-change-notify.nix pkgs}"
        "${import ./scripts/brightness-change-notify.nix pkgs}"
      ];
      cursor = {
        inactive_timeout = 3;
      };
      exec = "${pkgs.hyprland}/bin/hyprctl setcursor Bibata-Modern-Ice 20";
      env = [
        "LIBVA_DRIVER_NAME,nvidia"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      ];
      input = {
        kb_layout = "us,de";
        kb_options = "caps:swapescape";
        touchpad = {
          natural_scroll = true;
        };
        follow_mouse = 1;
        sensitivity = 0.8;
        force_no_accel = false;
        accel_profile = "flat";
        numlock_by_default = true;
      };
      misc = {
        vrr = 0;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        force_default_wallpaper = 0;
      };
      layerrule = [
        "unset,waybar"
        "blur,rofi"
        "dimaround,rofi"
        "blur,swaync-control-center"
        "dimaround,swaync-control-center"
      ];
      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
        workspace_swipe_forever = true;
        workspace_swipe_direction_lock = false;
      };
      general = {
        border_size = 0;
        gaps_in = 4;
        gaps_out = 8;
        layout = "dwindle";
      };
      plugin = {
        hyprfocus = {
          enabled = true;
          animate_floating = true;
          animate_workspacechange = true;
          focus_animation = "flash";
          bezier = "realsmooth, 0.28,0.29,0.69,1.08";
          flash = {
            flash_opacity = 0.88;
            in_bezier = "realsmooth";
            in_speed = 0.4;
            out_bezier = "realsmooth";
            out_speed = 1.5;
          };
        };
        dynamic-cursors = {
          enabled = true;
          threshold = 1;
          mode = "tilt";
          shake = {
            enabled = false;
          };
        };
      };
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      decoration = {
        rounding = 5;
        rounding_power = 3;
        dim_inactive = true;
        dim_strength = 0.10;
        inactive_opacity = 0.95;
        dim_special = 0.3;
        shadow = {
          enabled = true;
          range = 12;
          render_power = 2;
          color = "0x66000000";
          color_inactive = "0x33000000";
        };
        blur = {
          special = true;
          enabled = true;
          size = 4;
          passes = 2;
          new_optimizations = true;
          ignore_opacity = true;
          xray = false;
        };
      };
      animations = {
        enabled = true;
        bezier = [
          "wind, 0.05, 0.9, 0.1, 1"
          "winIn, 0.1, 1.1, 0.1, 1"
          "winOut, 0.3, 0, 0, 1"
        ];
        animation = [
          "windows, 1, 1, wind, popin 75%"
          "windowsIn, 1, 1, winIn, popin 75%"
          "windowsOut, 1, 1, winOut, popin 75%"
          "windowsMove, 1, 1.5, wind, slide"
          "layers, 1, 1, wind, popin 75%"
          "fade, 1, 2, default"
          "workspaces, 1, 1, wind, slide"
          "specialWorkspace, 1, 2, wind, slidefadevert 10%"
        ];
      };
      windowrulev2 = [
        "float,initialClass:^(ghostty.yazi)$"
        "size 1400 700, initialClass:^(ghostty.yazi)$"

        "float,initialClass:^(ghostty.spotify_player)$"
        "size 1700 900, initialClass:^(ghostty.spotify_player)$"
        "workspace special:spotify_player silent,initialClass:^(ghostty.spotify_player)$"

        "size 1700 900, initialClass:^(Slack)$"
        "workspace special:Slack silent,initialClass:^(Slack)$"
      ];
      monitor = [
        "DP-1,3440x1440@99.98,-760x-1440, 1"
        "eDP-1,1920x1080@60.01,0x0, 1"
        "eDP-2,1920x1080@60.01,0x0, 1"
        "HDMI-A-1,3440x1440@59.94,-760x-1440, 1"
      ];
      binds.movefocus_cycles_fullscreen = false;
      bind =
        [
          "SUPER, q, killactive"

          "SUPER, h, movefocus, l"
          "SUPER, l, movefocus, r"
          "SUPER, k, movefocus, u"
          "SUPER, j, movefocus, d"

          "SUPER, t, togglesplit"
          "SUPER+Shift, N, movecurrentworkspacetomonitor, +1"

          "SUPER, F, fullscreen,"
          "SUPER+Shift, F, fullscreenstate, 2,"
          "SUPER+Shift, Space, togglefloating"

          "SUPER, Return, exec, ${pkgs.ghostty}/bin/ghostty"
          "SUPER, d, exec, ${pkgs.rofi-wayland}/bin/rofi -theme-str \"entry {placeholder: \\\"  Launch...\\\";}\" -combi-modi search:${import ./scripts/rofi-search.nix pkgs},drun -show combi"
          "SUPER, s, exec, ${import ./scripts/screenshot.nix pkgs}"
          "SUPER, E, exec, ${pkgs.xdg-utils}/bin/xdg-open ~/Downloads"
          "SUPER, m, exec, ${pkgs.rofimoji}/bin/rofimoji --selector-args=\"-theme-str \\\"listview{dynamic:true;columns:12;layout:vertical;flow:horizontal;reverse:false;lines:10;}element-text{enabled:false;}element-icon{size:36px;}inputbar{enabled:false;}\\\"\" --use-icons --typer wtype --clipboarder wl-copy --skin-tone neutral --selector rofi --max-recent 0 --action clipboard"
          "SUPER, SPACE, exec, ${import ./scripts/switch-kb-layout.nix pkgs}"
          "SUPER, c, exec, ${pkgs.rofi-wayland}/bin/rofi -modi calculator:${import ./scripts/rofi-calculator.nix pkgs} -show calculator"

          "SUPER, F1, togglespecialworkspace, spotify_player"
          "SUPER, F1, exec, pgrep spotify_player || ${pkgs.ghostty}/bin/ghostty --class=ghostty.spotify_player -e ${(import ./spotify-player.nix pkgs).package}/bin/spotify_player"

          "SUPER, F2, togglespecialworkspace, Slack"
          "SUPER, F2, exec, pgrep Slack || ${pkgs.slack}/bin/slack"

          "SUPER+Shift, s, exec, ${import ./scripts/screenshot.nix pkgs} edit"
          "SUPER+Shift, c, exec, ${pkgs.swaynotificationcenter}/bin/swaync-client -t"
          "SUPER+Shift, d, exec, ${pkgs.darkman}/bin/darkman toggle"
          "SUPER+Shift, w, exec, ${import ./scripts/random-wallpaper.nix pkgs}"
          "SUPER+Shift, z, exec, ${import ./scripts/toggle-zen.nix pkgs}"
          "SUPER+Shift, P, exec, ${pkgs.hyprpicker}/bin/hyprpicker -a"
          "SUPER+Shift, q, exec,  ${pkgs.rofi-wayland}/bin/rofi -show power-menu -modi power-menu:${import ./scripts/rofi-power-menu.nix pkgs} -theme-str \"entry {placeholder:\\\"Power Menu...\\\";}element-icon{enabled:false;}icon-current-entry{enabled:false;}inputbar{padding: 0 0 0 42;}window{padding: 38% 44%;}\""
          "SUPER+Shift, b, exec,  ${import ./scripts/rofi-bluetooth.nix pkgs}"
          "SUPER+Shift, i, exec, ${pkgs._1password-gui}/bin/1password --quick-access --ozone-platform-hint=x11"
          "SUPER+Shift, v, exec, ${import ./scripts/rofi-cliphist.nix pkgs}"
        ]
        ++ (
          builtins.concatLists (builtins.genList (
              i: let
                ws = i + 1;
              in [
                "SUPER, code:1${toString i}, workspace, ${toString ws}"
                "SUPER+Shift, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            )
            9)
        );
      bindle = [
        "SUPER, bracketright, exec, ${pkgs.pamixer}/bin/pamixer -i 5"
        "SUPER, slash, exec, ${pkgs.pamixer}/bin/pamixer -d 5"
        "SUPER, backslash, exec, ${pkgs.pamixer}/bin/pamixer -t"
      ];
      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
        "SUPER, X, resizewindow"
        "SUPER, Y, movewindow"
        "SUPER, Z, movewindow"
      ];
      "$moveactivewindow" = "grep -q \"true\" <<< $(${pkgs.hyprland}/bin/hyprctl activewindow -j | jq -r .floating) && ${pkgs.hyprland}/bin/hyprctl dispatch moveactive";
      binde = [
        "SUPER+Shift, bracketright, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 1%+"
        "SUPER+Shift, slash, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 1%-"

        "SUPER+Shift, h,exec, $moveactivewindow -30 0 || ${pkgs.hyprland}/bin/hyprctl dispatch movewindow l"
        "SUPER+Shift, l,exec, $moveactivewindow 30 0 || ${pkgs.hyprland}/bin/hyprctl dispatch movewindow r"
        "SUPER+Shift, k,exec, $moveactivewindow  0 -30 || ${pkgs.hyprland}/bin/hyprctl dispatch movewindow u"
        "SUPER+Shift, j,exec, $moveactivewindow 0 30 || ${pkgs.hyprland}/bin/hyprctl dispatch movewindow d"

        "SUPER+alt, l, resizeactive, 30 0"
        "SUPER+alt, h, resizeactive, -30 0"
        "SUPER+alt, k, resizeactive, 0 -30"
        "SUPER+alt, j, resizeactive, 0 30"
      ];
    };
  };
}
