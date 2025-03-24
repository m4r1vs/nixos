pkgs:
pkgs.writeShellScript "nixos-notify"
''
  ${pkgs.libnotify}/bin/notify-send --app-name="nixpad" "$@"
''
