pkgs:
pkgs.writeShellScript "gracefull-systemctl" ''
  ${import ./nixos-notify.nix pkgs} -e "Gracefully Performing Action:" "$1"
  ${pkgs.psmisc}/bin/killall -q -w brave
  systemctl $1
''
