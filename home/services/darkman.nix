{pkgs, ...}: {
  services.darkman = {
    enable = true;
    settings = {
      lat = 53.54;
      lng = 9.98;
      usegeoclue = false;
    };
    darkModeScripts = {
      mode = "${pkgs.dconf}/bin/dconf write\ /org/gnome/desktop/interface/color-scheme \"'prefer-dark'\"";
      theme = "${pkgs.dconf}/bin/dconf write\ /org/gnome/desktop/interface/gtk-theme \"'Dracula'\"";
      notify = "${import ../scripts/nixos-notify.nix pkgs} -e -r 91191 -t 900 \"Dark Mode Activated\"";
    };
    lightModeScripts = {
      mode = "${pkgs.dconf}/bin/dconf write\ /org/gnome/desktop/interface/color-scheme \"'prefer-light'\"";
      theme = "${pkgs.dconf}/bin/dconf write\ /org/gnome/desktop/interface/gtk-theme \"'Adwaita'\"";
      notify = "${import ../scripts/nixos-notify.nix pkgs} -e -r 91191 -t 900 \"Welcome to the bright side :)\"";
    };
  };
}
