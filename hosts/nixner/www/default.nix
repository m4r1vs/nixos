{lib, ...}: let
  dirContents = builtins.readDir ./.;
  allNames = lib.attrNames dirContents;

  # --- Part 1: Find .nix files in the current directory (excluding default.nix) ---

  nixFilesInCurrentDir =
    lib.filter (
      name: let
        entryType = dirContents.${name};
      in
        entryType == "regular" && lib.hasSuffix ".nix" name && name != "default.nix"
    )
    allNames;

  currentDirNixFilePaths = lib.map (name: ./. + "/${name}") nixFilesInCurrentDir;

  # --- Part 2: Find immediate subdirectories (to import their default.nix) ---

  dirsWithDefaultNix =
    lib.filter (
      name: let
        entryType = dirContents.${name};
        isDir = entryType == "directory";
        subDirPath = ./. + "/${name}";
        defaultNixPath = subDirPath + "/default.nix";
      in
        isDir && (builtins.pathExists defaultNixPath)
    )
    allNames;

  subDirPaths = lib.map (name: ./. + "/${name}") dirsWithDefaultNix;

  allImportPaths = currentDirNixFilePaths ++ subDirPaths;
in {
  imports = allImportPaths;
}
