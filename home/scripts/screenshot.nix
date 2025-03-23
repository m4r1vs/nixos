pkgs:
pkgs.writeShellScript "screenshot"
# bash
''
  OUTPUT="$HOME/Pictures/Screenshots/screenshot_$(date +%Y-%m-%d-%H-%M-%S).png"
  HYPR_OUTPUT="$(mktemp)"
  ${pkgs.hyprshot}/bin/hyprshot -m region -o "/tmp" --freeze -f "tmp_screenshot.png" --silent 2> "$HYPR_OUTPUT"

  if cat $HYPR_OUTPUT | grep -q "cancelled"; then
    ${import ./nixos-notify.nix pkgs} -e "Screenshot Cancelled"
    exit 0
  fi

  ${pkgs.swappy}/bin/swappy -f "/tmp/tmp_screenshot.png" -o "$OUTPUT"
  if [ ! -f "$OUTPUT" ]; then
    mv /tmp/tmp_screenshot.png "$OUTPUT"
  fi
  ${pkgs.wl-clipboard}/bin/wl-copy < "$OUTPUT"
  ${import ./nixos-notify.nix pkgs} -e -i "$OUTPUT" "Copied and saved!"
''
