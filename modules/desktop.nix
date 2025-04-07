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
  config = mkIf cfg.enable {
    environment.pathsToLink = ["/share/xdg-desktop-portal" "/share/applications"];

    configured.i3.enable = cfg.x11;
    configured.hyprland.enable = !cfg.x11;

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
        theme = "colorful_sliced"; # rings and abstract_ring also good
        themePackages = with pkgs; [
          (adi1090x-plymouth-themes.override {
            selected_themes = ["colorful_sliced"];
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
          src = fetchurl {
            url = "https://github.com/samuelngs/apple-emoji-linux/releases/download/v18.4/AppleColorEmoji.ttf";
            hash = "sha256-pP0He9EUN7SUDYzwj0CE4e39SuNZ+SVz7FdmUviF6r0=";
          };
          dontUnpack = true;
          installPhase = ''
            runHook preInstall

            mkdir -p $out/share/fonts/truetype
            cp $src $out/share/fonts/truetype/AppleColorEmoji.ttf

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
  };
}
