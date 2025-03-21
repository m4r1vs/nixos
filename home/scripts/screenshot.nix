pkgs:
pkgs.writeShellScript "screenshot"
# bash
''
  OUTPUT="$HOME/Pictures/Screenshots/screenshot_$(date +%Y-%m-%d-%H-%M-%S).png"
  ${pkgs.hyprshot}/bin/hyprshot -m region -o "/tmp" --freeze -f "tmp_screenshot.png" --silent

  if [ $? -eq 1 ]; then
    ${pkgs.libnotify}/bin/notify-send "Screenshot Cancelled"
    exit 0
  fi

  ${pkgs.swappy}/bin/swappy -f "/tmp/tmp_screenshot.png" -o "$OUTPUT"
  if [ ! -f "$OUTPUT" ]; then
    mv /tmp/tmp_screenshot.png "$OUTPUT"
  fi
  ${pkgs.wl-clipboard}/bin/wl-copy < "$OUTPUT"
  ${pkgs.libnotify}/bin/notify-send "Copied and saved!" -i "$OUTPUT"
''
