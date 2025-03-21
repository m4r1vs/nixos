pkgs:
pkgs.writeShellScript "nixos-notify"
''
  if [[ " $@ " =~ "-i" ]]; then
    ${pkgs.libnotify}/bin/notify-send "$@"
  else
    ${pkgs.libnotify}/bin/notify-send -i "${builtins.path {path = ../assets/nixpad-mascot-icon.png;}}" "$@"
  fi
''
