pkgs:
pkgs.writeShellScript "switch-kb-layout"
# bash
''
  ${pkgs.hyprland}/bin/hyprctl switchxkblayout all next
  layMain=$(${pkgs.hyprland}/bin/hyprctl -j devices | jq '.keyboards' | jq '.[] | select (.main == true)' | awk -F '"' '{if ($2=="active_keymap") print $4}')
  notify-send -e -r 91190 -t 800 -i "${pkgs.papirus-icon-theme}/share/icons/Papirus/128x128/devices/input-keyboard.svg" "''${layMain}"
''
