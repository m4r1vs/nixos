{
  lib,
  pkgs,
  systemArgs,
  ...
}: {
  wsl = {
    enable = true;
    defaultUser = systemArgs.username;
    interop.includePath = false;
  };

  services.openssh.enable = lib.mkForce false;

  system = {
    nixos.label = systemArgs.hostname + ".niveri.de";
  };

  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "ssh" "/mnt/c/WINDOWS/System32/OpenSSH/ssh.exe $@")
    (writeShellScriptBin "scp" "/mnt/c/WINDOWS/System32/OpenSSH/scp.exe $@")
    (writeShellScriptBin "sftp" "/mnt/c/WINDOWS/System32/OpenSSH/sftp.exe $@")
    (writeShellScriptBin "ssh-add" "/mnt/c/WINDOWS/System32/OpenSSH/ssh-add.exe $@")
    (writeShellScriptBin "ssh-agent" "/mnt/c/WINDOWS/System32/OpenSSH/ssh-agent.exe $@")
    (writeShellScriptBin "ssh-keygen" "/mnt/c/WINDOWS/System32/OpenSSH/ssh-keygen.exe $@")
    (writeShellScriptBin "ssh-keyscan" "/mnt/c/WINDOWS/System32/OpenSSH/ssh-keyscan.exe $@")
  ];
}
