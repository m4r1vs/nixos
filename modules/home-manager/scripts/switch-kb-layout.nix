{
  pkgs,
  scripts,
  ...
}: {
  switch-kb-layout =
    pkgs.writeShellScript "switch-kb-layout"
    ''
      ${pkgs.hyprland}/bin/hyprctl switchxkblayout all next && sleep 0.05
      layMain=$(${pkgs.hyprland}/bin/hyprctl -j devices | jq '.keyboards' | jq '.[] | select (.main == true)' | awk -F '"' '{if ($2=="active_keymap") print $4}')
      ${scripts.nixos-notify} -e -h string:synchronous:switch-kb-layout -t 1000 -i "${pkgs.papirus-icon-theme}/share/icons/Papirus/128x128/devices/input-keyboard.svg" "Switched Keyboard Layout to:" "$layMain"
    '';
}
