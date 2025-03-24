{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./programs.nix
    ./home/scripts/thinkmorse.nix
  ];

  services.thinkmorse = {
    message = "Leck Eier";
    enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixpad";
  networking.networkmanager.enable = true;
  networking.firewall = {
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

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";

  services.printing.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  hardware.graphics = {
    enable = true;
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.xserver.videoDrivers = ["nvidia"];

  services.kmscon = {
    enable = true;
    fonts = [
      {
        name = "JetBrainsMono NF";
        package = pkgs.nerd-fonts.jetbrains-mono;
      }
    ];
    extraOptions = "--term xterm-256color";
  };

  services.tlp = {
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

  fonts.enableDefaultPackages = true;

  fonts.fontconfig = {
    defaultFonts = {
      serif = ["Garamond Libre" "Gentium Plus"];
      sansSerif = ["Ubuntu" "Cantarell"];
      monospace = ["JetBrainsMono Nerd Font Proto" "Source Code Pro"];
      emoji = ["Apple Color Emoji"];
    };
  };

  fonts.packages = with pkgs; [
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

  fonts.fontDir.enable = true;

  hardware.nvidia = {
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

  services.libinput.enable = true;

  users.users.mn = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
    ];
  };

  users.defaultUserShell = pkgs.zsh;

  programs.zsh.enable = true;
  programs.hyprland.enable = true;
  programs.hyprlock.enable = true;

  programs.kdeconnect.enable = true;

  # 1May require "hardware acceleration" to be enabled in order to work on Wayland
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = ["mn"];
  };

  environment.systemPackages = with pkgs; [
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

  environment.sessionVariables = {
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    NIXOS_OZONE_WL = "1";
  };
  environment.pathsToLink = ["/share/zsh"];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;

  services.blueman = {
    enable = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "mn";
      };
      initial_session = {
        command = "${pkgs.hyprland}/bin/Hyprland";
        user = "mn";
      };
    };
  };

  nixpkgs.overlays = [
    (final: prev: {
      libfprint-tod = prev.libfprint-tod.overrideAttrs (oldAttrs: {
        buildInputs = oldAttrs.buildInputs ++ [prev.nss];
      });
    })
    (final: prev: {
      rofi-unwrapped = prev.rofi-unwrapped.overrideAttrs (oldAttrs: {
        patchPhase = ''
          echo "NoDisplay=true" >> ./data/rofi-theme-selector.desktop
          echo "NoDisplay=true" >> ./data/rofi.desktop
        '';
      });
    })
  ];

  services."06cb-009a-fingerprint-sensor" = {
    enable = true;
    backend = "libfprint-tod";
    calib-data-file = ./calib-data.bin;
  };

  security.pam.services.login.fprintAuth = true;
  security.pam.services.sudo.fprintAuth = true;

  services.dbus.enable = true;

  security.pam.services.greetd.kwallet = {
    enable = true;
    package = pkgs.kdePackages.kwallet-pam;
  };

  security.pam.services.hyprlock = {};

  system.stateVersion = "24.11";
}
