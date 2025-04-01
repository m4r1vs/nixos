let
  importScript = {
    fileName,
    pkgs,
    systemArgs,
  }: let
    scriptModule = import ./scripts/${fileName};
  in
    scriptModule {
      inherit pkgs systemArgs;
      scripts = makeScripts {inherit pkgs systemArgs;};
      lib = pkgs.lib;
    };

  makeScripts = {
    pkgs,
    systemArgs,
  }: (pkgs.lib.foldl pkgs.lib.mergeAttrs {} (
    pkgs.lib.mapAttrsToList (fileName: fileType:
      importScript {
        inherit fileName pkgs systemArgs;
      }) (builtins.readDir ./scripts)
  ));
in
  makeScripts
