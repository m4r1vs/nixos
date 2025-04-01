{
  pkgs,
  scripts,
  ...
}: {
  custom-theme = pkgs.writeShellScript "custom-theme" ''
    if [[ "$1" == "dark" ]]; then
      ln -f ~/.theme/rofi/dark.rasi ~/.theme/rofi/current.rasi
    elif [[ "$1" == "light" ]]; then
      ln -f ~/.theme/rofi/light.rasi ~/.theme/rofi/current.rasi
    else
      ${scripts.nixos-notify} -e "custom-theme.nix: Please provide 'light' or 'dark' as an argument."
    fi
  '';
}
