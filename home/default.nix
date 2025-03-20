{lib, ...}: {
  imports = [
    <home-manager/nixos>
  ];

  home-manager = {
    useGlobalPkgs = true;
    users.mn = {pkgs, ...}: {
      imports = [
        ./neovim
      ];
      home.packages = import ./packages.nix pkgs;
      services = import ./services.nix;
      programs = {
        ssh = {
          enable = true;
          extraConfig = ''
            Host *
                IdentityAgent ~/.1password/agent.sock
          '';
        };
        bat = {
          enable = true;
        };
        yazi = {
          enable = true;
        };
        fzf = {
          enable = true;
          enableZshIntegration = false;
        };
        lazygit = {
          enable = true;
          settings = {
            gui = {
              scrollHeight = 4;
            };
          };
        };
        direnv = {
          enable = true;
          enableZshIntegration = true;
          nix-direnv.enable = true;
          mise.enable = true;
          silent = true;
        };
        zsh = import ./zsh {
          inherit pkgs;
          inherit lib;
        };
        git = {
          enable = true;
          userName = "Marius Niveri";
          userEmail = "mniveri@cc.systems";
        };
        zoxide = {
          enable = true;
          package = pkgs.zoxide;
          enableZshIntegration = true;
        };
        chromium = {
          enable = true;
          package = pkgs.brave;
          commandLineArgs = [
            "--ozone-platform-hint=auto"
            "--enable-features=TouchpadOverscrollHistoryNavigation"
          ];
        };
        ghostty = import ./ghostty.nix pkgs;
        waybar = import ./waybar pkgs;
      };
      wayland.windowManager.hyprland = {
        enable = true;
        settings = {
          "$mod" = "SUPER";
          exec-once = "${pkgs.waybar}/bin/waybar";
          exec = "hyprctl setcursor Bibata-Modern-Ice 20";
          input = {
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
            "dimaround,rofi"
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
          };
          dwindle = {
            pseudotile = true;
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
              special = false;
              enabled = true;
              size = 5;
              passes = 3;
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
              "liner, 1, 1, 1, 1"
            ];
            animation = [
              "windows, 1, 1, wind, slide"
              "windowsIn, 1, 1, winIn, slide"
              "windowsOut, 1, 1, winOut, slide"
              "windowsMove, 1, 1, wind, slide"
              "border, 1, 1, liner"
              "borderangle, 1, 7, liner, loop"
              "fade, 1, 2, default"
              "workspaces, 1, 1, wind"
            ];
          };
          monitor = [
            "eDP-1,1920x1080@60.01,0x0, 1"
            "eDP-2,1920x1080@60.01,0x0, 1"
          ];
          binds.movefocus_cycles_fullscreen = false;
          bind =
            [
              "$mod, Return, exec, ${pkgs.ghostty}/bin/ghostty"
              "$mod, D, exec, ${pkgs.rofi-wayland}/bin/rofi -show drun"
              "$mod, h, movefocus, l"
              "$mod, l, movefocus, r"
              "$mod, k, movefocus, u"
              "$mod, j, movefocus, d"
              "$mod SHIFT, s, exec, ${pkgs.hyprshot}/bin/hyprshot -m region --clipboard-only"
              "$mod, q, killactive"
              "$mod SHIFT, w, exec, ${import ./scripts/random-wallpaper.nix pkgs}/bin/random-wallpaper"
              "$mod SHIFT, P, exec, ${pkgs.hyprpicker}/bin/hyprpicker -a"
            ]
            ++ (
              builtins.concatLists (builtins.genList (
                  i: let
                    ws = i + 1;
                  in [
                    "$mod, code:1${toString i}, workspace, ${toString ws}"
                    "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
                  ]
                )
                9)
            );
          binde = [
            "$mod+alt, l, resizeactive, 30 0"
            "$mod+alt, h, resizeactive, -30 0"
            "$mod+alt, k, resizeactive, 0 -30"
            "$mod+alt, j, resizeactive, 0 30"
          ];
        };
      };
      gtk = {
        enable = true;
        theme = {
          package = pkgs.dracula-theme;
          name = "Dracula";
        };
        iconTheme = {
          package = pkgs.tela-circle-icon-theme;
          name = "Tela-circle-dracula";
        };
        cursorTheme = {
          package = pkgs.bibata-cursors;
          size = 20;
          name = "Bibata-Modern-Ice";
        };
        font = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font Proto";
          size = 10;
        };
      };
      fonts.fontconfig.enable = true;
      home = {
        sessionVariables = {
          ELECTRON_OZONE_PLATFORM_HINT = "auto";
          NIXOS_OZONE_WL = "1";
        };
        stateVersion = "24.05";
      };
    };

    backupFileExtension = "backup";
  };
}
