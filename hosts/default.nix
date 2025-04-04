{
  pkgs,
  systemArgs,
  ...
}: {
  configured = {
    home-manager.enable = true;
  };

  services = {
    openssh.enable = true;
  };

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
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
    initrd = {
      verbose = false;
      systemd.enable = true;
    };
    consoleLogLevel = 0;
    loader = {
      timeout = 1;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    tmp.cleanOnBoot = true;
  };

  networking = {
    hostName = systemArgs.hostname;
    networkmanager.enable = true;
    firewall = {
      enable = true;
    };
  };

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  users = {
    users.${systemArgs.username} = {
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
    zsh.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    nix-index-database.comma.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      curl
      exiftool
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
    pathsToLink = ["/share/zsh"];
  };

  system = {
    stateVersion = "24.11";
  };
}
