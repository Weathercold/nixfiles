{ lib, strings }:

let
  inherit (builtins) all filter baseNameOf attrNames readDir readFile;
  inherit (lib)
    pipe const
    mapAttrs mapAttrs' mapAttrsToList zipAttrs filterAttrs nameValuePair
    hasPrefix hasSuffix removeSuffix;
  inherit (lib.filesystem) listFilesRecursive;

  list = readDir: pred: d: pipe d [
    readDir
    (filterAttrs (_: v: pred v))
    attrNames
  ];
in

rec {
  # readDir but the names are absolute paths
  readDir' = d: mapAttrs'
    (n: v: nameValuePair "${toString d}/${n}" v)
    (readDir d);

  # Return a list of directories within
  listDirs = list readDir (t: t == "directory");
  # Return a list of paths to directories within
  listDirs' = list readDir' (t: t == "directory");

  # Return a list of files within
  listFiles = list readDir (t: t == "regular");
  # Return a list of paths to files within
  listFiles' = list readDir' (t: t == "regular");

  # Return a list of items within
  listAll = list readDir (const true);
  # Return a list of paths to items within
  listAll' = list readDir' (const true);

  # Recursively read a directory and return an attribute set where
  # subdirectories are nested sets and files are their absolute paths
  dirToAttrs = d: pipe d [
    readDir
    (mapAttrs (n: v:
      if v == "directory"
      then dirToAttrs "${toString d}/${n}"
      else "${toString d}/${n}"
    ))
  ];

  # Generate an attribute set to be used in e.g. nixosModules.
  genModules = d:
    let contents = readDir d; in
    if contents ? "default.nix" then { ${baseNameOf d} = d; }
    else
      mapAttrs'
        (n: v: nameValuePair "${baseNameOf d}-${n}" v)
        (
          pipe contents [
            (filterAttrs (n: v: hasSuffix ".nix" n && v == "regular"))
            (mapAttrs' (n: _:
              nameValuePair
                (removeSuffix ".nix" n)
                "${toString d}/${n}"
            ))
          ] //
          pipe contents [
            (filterAttrs (_: v: v == "directory"))
            (mapAttrsToList (n: _: genModules "${toString d}/${n}"))
            zipAttrs
          ]
        );

  # Recursively collect all modules in a directory, excluding those that are
  # encrypted or start with `# noauto`. Recursion stops when a default.nix is
  # found.
  collectModules = d:
    let
      files = pipe d [
        # All files...
        listFilesRecursive
        # ... that are nix expressions ...
        (filter (hasSuffix ".nix"))
        # ... and don't start with `# noauto`
        (filter (f: !hasPrefix "# noauto" (readFile f)))
      ];
      # Directories with default.nix...
      defaultDirs = pipe files [
        # ..excluding the root
        (filter (f: hasSuffix "default.nix" f && f != "${toString d}/default.nix"))
        (map (removeSuffix "default.nix"))
      ];
    in
    filter (f: all (d: !hasPrefix d f) defaultDirs) files;
}
