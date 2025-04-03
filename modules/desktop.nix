{
  lib,
  config,
  pkgs,
  systemArgs,
  ...
}:
with lib; let
  cfg = config.configured.desktop;
in {
  options.configured.desktop = {
    enable = mkEnableOption "Enable a Desktop Environment";
    x11 = mkOption {
      type = types.bool;
      default = false;
      description = "Use x11 instead of Wayland";
    };
  };
  config = mkIf cfg.enable (mkMerge [
    {
      environment.pathsToLink = ["/share/xdg-desktop-portal" "/share/applications"];

      services = {
        /*
        Touchpad support
        */
        libinput = {
          enable = true;
          touchpad = {
            tapping = true;
            naturalScrolling = true;
            scrollMethod = "twofinger";
            disableWhileTyping = true;
          };
        };

        /*
        CUPS
        */
        printing = {
          enable = true;
          drivers = with pkgs; [
            brlaser
          ];
        };

        /*
        Auto-Discovery of
        network devices
        */
        avahi = {
          enable = true;
          nssmdns4 = true;
          openFirewall = true;
        };

        /*
        Audio
        */
        pipewire = {
          enable = true;
          raopOpenFirewall = true;
          pulse.enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          wireplumber = {
            enable = true;
          };
          extraConfig.pipewire = {
            "10-airplay" = {
              "context.modules" = [
                {
                  name = "libpipewire-module-raop-discover";
                }
              ];
            };
          };
        };

        /*
        geTTY replacement with TTF support
        */
        # kmscon = {
        #   enable = true;
        #   fonts = [
        #     {
        #       name = "JetBrainsMono NF";
        #       package = pkgs.nerd-fonts.jetbrains-mono;
        #     }
        #   ];
        #   extraOptions = "--term xterm-256color";
        # };

        /*
        Misc
        */
        dbus.enable = true;
        blueman.enable = true;
      };

      security = {
        polkit.enable = true;
        rtkit.enable = true;
      };

      boot = {
        plymouth = {
          enable = true;
          theme = "abstract_ring"; # rings and colorful_sliced also good
          themePackages = with pkgs; [
            (adi1090x-plymouth-themes.override {
              selected_themes = ["abstract_ring"];
            })
          ];
        };
        kernelParams = [
          "quiet"
          "splash"
          "boot.shell_on_fail"
          "loglevel=3"
          "rd.systemd.show_status=false"
          "rd.udev.log_level=3"
          "udev.log_priority=3"
        ];
      };

      networking = {
        firewall = {
          allowedTCPPortRanges = [
            {
              # KDE Connect
              from = 1714;
              to = 1764;
            }
          ];
          allowedUDPPortRanges = [
            {
              # Apple AirPlay
              from = 6001;
              to = 6002;
            }
            {
              # KDE Connect
              from = 1714;
              to = 1764;
            }
          ];
        };
      };

      hardware = {
        bluetooth = {
          enable = true;
          powerOnBoot = true;
          settings = {
            General = {
              Name = systemArgs.hostname;
              ControllerMode = "dual";
              FastConnectable = "true";
              Experimental = "true";
            };
            Policy = {AutoEnable = "true";};
            LE = {EnableAdvMonInterleaveScan = "true";};
          };
        };
      };

      fonts = {
        enableDefaultPackages = true;

        fontconfig = {
          defaultFonts = {
            serif = ["EB Garamond 08"];
            sansSerif = ["Ubuntu"];
            monospace = ["JetBrainsMono Nerd Font Proto"];
            emoji = ["Apple Color Emoji"];
          };
        };

        packages = with pkgs; [
          nerd-fonts.jetbrains-mono
          ubuntu_font_family
          eb-garamond
          (stdenv.mkDerivation {
            name = "Apple Color Emoji Font";
            enableParallelBuilding = true;
            src = fetchFromGitHub {
              owner = "mistu01";
              repo = "apple-emoji-linux";
              rev = "ios-17.4";
              sha256 = "sha256-k4RFvhvl8tdaFA3Mlp3+ql88lFyEShaPen4PApDlbDc=";
            };
            buildInputs = [
              which
              python3
              python3Packages.fonttools
              python3Packages.nototools
              optipng
              zopfli
              pngquant
              gnumake
              imagemagick
            ];
            installPhase = ''
              runHook preInstall
              mkdir -p $out/share/fonts/truetype
              cp ./AppleColorEmoji.ttf $out/share/fonts/truetype
              runHook postInstall
            '';
          })
          (stdenv.mkDerivation {
            name = "Samsung Classic Clock Font";
            src = ../assets/fonts/samsung/samsung-clock-classic.ttf;
            dontUnpack = true;
            installPhase = ''
              runHook preInstall

              mkdir -p $out/share/fonts/truetype
              cp $src $out/share/fonts/truetype/SamsungClockClassic.ttf

              runHook postInstall
            '';
          })
        ];
        fontDir.enable = true;
      };

      programs = {
        dconf.enable = true;
        steam = {
          enable = true;
          remotePlay.openFirewall = true;
          dedicatedServer.openFirewall = true;
          localNetworkGameTransfers.openFirewall = true;
        };
        kdeconnect.enable = true;
        _1password.enable = true;
        _1password-gui = {
          enable = true;
          polkitPolicyOwners = [systemArgs.username];
        };
      };

      environment = {
        systemPackages = with pkgs; [
          bibata-cursors
          (runCommandLocal "breeze-cursor-default-theme" {} ''
            mkdir -p $out/share/icons
            ln -s ${bibata-cursors}/share/icons/Bibata-Modern-Ice $out/share/icons/default
          '')
        ];
      };
    }
    (mkIf cfg.x11 {
      environment.pathsToLink = ["/libexec"];
      environment = {
        systemPackages = with pkgs; [
          lxappearance
          xclip
          wl-clipboard
          wl-clipboard-x11
        ];
      };
      security.pam.services = {
        login.kwallet = {
          enable = true;
          package = pkgs.kdePackages.kwallet-pam;
        };
      };
      services = {
        displayManager = {
          defaultSession = "none+i3";
          enable = true;
          autoLogin = {
            enable = true;
            user = systemArgs.username;
          };
        };
        xserver = {
          enable = true;
          xkb = {
            layout = "us,de";
            options = "caps:swapescape";
          };
          desktopManager = {
            xterm.enable = false;
          };
          windowManager.i3 = {
            enable = true;
            extraPackages = with pkgs; [
              i3status
              i3lock
              i3blocks
            ];
          };
        };
      };
    })
    (mkIf (cfg.x11 == false) {
      environment = {
        systemPackages = with pkgs; [
          swayimg
          wl-clipboard
          hyprcursor
          hyprpicker
          hyprshot
          hyprutils
        ];
      };
      environment.sessionVariables = {
        ELECTRON_OZONE_PLATFORM_HINT = "wayland";
        NIXOS_OZONE_WL = "1";
      };
      security.pam.services = {
        greetd.kwallet = {
          enable = true;
          package = pkgs.kdePackages.kwallet-pam;
        };
        hyprlock = {};
      };

      programs = {
        hyprland.enable = true;
        hyprlock.enable = true;
      };
      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd ${pkgs.hyprland}/bin/Hyprland";
            user = systemArgs.username;
          };
          initial_session = {
            command = "${pkgs.hyprland}/bin/Hyprland > ~/.hyprland.log 2>&1";
            user = systemArgs.username;
          };
        };
      };
    })
  ]);
}
