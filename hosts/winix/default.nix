{systemArgs, ...}: {
  wsl = {
    enable = true;
    defaultUser = systemArgs.username;
  };

  system = {
    nixos.label = systemArgs.hostname + ".niveri.de";
  };
}
