{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./disks.nix
    ./hardware-configuration.nix
    ./nixpkgs.nix
  ];

  services = {
    /*
    Blinking ThinkPad LED
    */
    thinkmorse = {
      message = "Leck Eier";
      enable = true;
    };

    /*
    Touchpad support
    */
    libinput.enable = true;

    /*
    Fingerprint Scanner Driver
    */
    "06cb-009a-fingerprint-sensor" = {
      enable = true;
      backend = "libfprint-tod";
      calib-data-file = ./calib-data.bin;
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
    kmscon = {
      enable = true;
      fonts = [
        {
          name = "JetBrainsMono NF";
          package = pkgs.nerd-fonts.jetbrains-mono;
        }
      ];
      extraOptions = "--term xterm-256color";
    };

    /*
    Limit CPU when on battery
    */
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 40;
      };
    };

    /*
    Greeter with auto-login
    */
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd ${pkgs.hyprland}/bin/Hyprland";
          user = "mn";
        };
        initial_session = {
          command = "${pkgs.hyprland}/bin/Hyprland > ~/.hyprland.log 2>&1";
          user = "mn";
        };
      };
    };

    /*
    B-Tree FS
    */
    btrfs = {
      autoScrub = {
        enable = true;
        interval = "weekly";
        fileSystems = ["/"];
      };
    };

    /*
    Misc
    */
    dbus.enable = true;
    openssh.enable = true;
    xserver.videoDrivers = ["nvidia"];
    blueman.enable = true;
  };

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  security = {
    pam.services = {
      login.fprintAuth = true;
      sudo.fprintAuth = true;
      greetd.kwallet = {
        enable = true;
        package = pkgs.kdePackages.kwallet-pam;
      };
      hyprlock = {};
    };
    rtkit.enable = true;
  };

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 10d";
    };
    settings = {
      auto-optimise-store = true;
      trusted-substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
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
    initrd = {
      verbose = false;
      systemd.enable = true;
    };
    consoleLogLevel = 0;
    loader = {
      timeout = 0;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    tmp. cleanOnBoot = true;
  };

  networking = {
    hostName = "nixpad";
    networkmanager.enable = true;
    firewall = {
      enable = true;
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

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";

  hardware = {
    nvidia-container-toolkit.enable = true;
    graphics = {
      enable = true;
    };
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      prime = {
        sync.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Name = "nixpad";
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
        src = ./assets/fonts/samsung/samsung-clock-classic.ttf;
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

  users = {
    users.mn = {
      isNormalUser = true;
      extraGroups = [
        "audio"
        "networkmanager"
        "podman"
        "wheel"
      ];
    };
    defaultUserShell = pkgs.zsh;
  };

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
    zsh.enable = true;
    hyprland.enable = true;
    hyprlock.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    kdeconnect.enable = true;

    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = ["mn"];
    };

    nix-index-database.comma.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      bibata-cursors
      (runCommandLocal "breeze-cursor-default-theme" {} ''
        mkdir -p $out/share/icons
        ln -s ${bibata-cursors}/share/icons/Bibata-Modern-Ice $out/share/icons/default
      '')
      curl
      ffmpeg
      fzf
      htop-vim
      imagemagick
      jq
      kdePackages.kwallet
      killall
      libsecret
      podman-tui
      ripgrep
      unzip
      wget
      xdg-utils
    ];
    sessionVariables = {
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      NIXOS_OZONE_WL = "1";
    };
    pathsToLink = ["/share/zsh"];
  };

  system = {
    nixos.label = "ThinkPad.cc.systems";
    stateVersion = "24.11";
  };
}
