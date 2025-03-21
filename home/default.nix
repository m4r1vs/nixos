{lib, ...}: {
  imports = [
    <home-manager/nixos>
  ];

  home-manager = {
    useGlobalPkgs = true;
    users.mn = {pkgs, ...}: {
      imports = [
        ./neovim
        ./services/swaync.nix
        ./services/kdeconnect.nix
        ./services/cliphist.nix
        ./services/hypridle.nix
        ./services/darkman.nix
        ./xdg.nix
        ./swappy.nix
        ./hyprland.nix
      ];
      home.packages = import ./packages.nix pkgs;
      services = {
        network-manager-applet.enable = true;
        blueman-applet.enable = true;
        swww.enable = true;
      };
      programs = {
        hyprlock = import ./hyprlock.nix pkgs;
        ssh = import ./ssh.nix;
        spotify-player = import ./spotify-player.nix pkgs;
        bat = import ./bat.nix;
        yazi = import ./yazi.nix;
        fzf = import ./fzf.nix;
        lazygit = import ./lazygit.nix;
        rofi = import ./rofi.nix pkgs;
        direnv = import ./direnv.nix;
        tmux = import ./tmux {
          inherit pkgs;
          inherit lib;
        };
        zsh = import ./zsh {
          inherit pkgs;
          inherit lib;
        };
        git = import ./git.nix;
        zoxide = import ./zoxide.nix;
        chromium = import ./brave.nix pkgs;
        ghostty = import ./ghostty.nix pkgs;
        waybar = import ./waybar pkgs;
      };
      gtk = import ./gtk.nix pkgs;
      qt = {
        enable = true;
        platformTheme.name = "adwaita";
        style.name = "adwaita";
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
