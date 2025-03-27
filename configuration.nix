{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./programs.nix
    ./home/scripts/thinkmorse.nix
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
    printing.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
      wireplumber = {
        enable = true;
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
          command = "${pkgs.hyprland}/bin/Hyprland";
          user = "mn";
        };
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
  };

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "nixpad";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
    };
  };

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";

  hardware = {
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
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };

  fonts = {
    enableDefaultPackages = true;

    fontconfig = {
      defaultFonts = {
        serif = ["Garamond Libre" "Gentium Plus"];
        sansSerif = ["Ubuntu" "Cantarell"];
        monospace = ["JetBrainsMono Nerd Font Proto" "Source Code Pro"];
        emoji = ["Apple Color Emoji"];
      };
    };

    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      ubuntu_font_family
      garamond-libre
      (stdenv.mkDerivation {
        name = "Apple Color Emoji Font";
        enableParallelBuilding = true;
        src = fetchFromGitHub {
          owner = "samuelngs";
          repo = "apple-emoji-linux";
          rev = "ios-17.4";
          sha256 = "sha256-r0xswLw6h4tk2Z2vLSl+5svhLZognn7/xqcmOSyUq0s=";
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
    ];
    fontDir.enable = true;
  };

  users = {
    users.mn = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "audio"
      ];
    };
    defaultUserShell = pkgs.zsh;
  };

  programs = {
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
  };

  environment = {
    systemPackages = with pkgs; [
      bibata-cursors
      comma
      curl
      ffmpeg
      fzf
      htop-vim
      imagemagick
      jq
      kdePackages.kwallet
      kdePackages.kwalletmanager
      killall
      kwalletcli
      networkmanagerapplet
      ripgrep
      unzip
      wget
      xdg-utils
    ];
    sessionVariables = {
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      NIXOS_OZONE_WL = "1";
    };
    pathsToLink = ["/share/zsh"];
  };

  system = {
    nixos.label = "ThinkPad.cc.systems";
    stateVersion = "24.11";
  };
}
