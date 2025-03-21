pkgs:
pkgs.writeShellScript "mediaplayer-wrapper"
''
  if command -v ${pkgs.psmisc}/bin/fuser /dev/video0 &>/dev/null && ${pkgs.psmisc}/bin/fuser /dev/video0 &>/dev/null; then
      echo " 󰄀"
  fi
  exit 0
''
