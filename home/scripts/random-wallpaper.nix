pkgs:
pkgs.writeShellScript "random-wallpaper"
# bash
''
  WALLPAPER="$(find ${builtins.path {path = ../wallpaper;}} -type f | shuf -n 1)"
  ${pkgs.libnotify}/bin/notify-send "Showing "$(basename "$WALLPAPER")""
  ${pkgs.swww}/bin/swww img "$WALLPAPER" --transition-type any --transition-fps 60 --transition-step 20 --transition-duration 1
''
