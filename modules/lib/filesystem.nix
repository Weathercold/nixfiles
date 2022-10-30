{ lib, trivial }:

with lib;
with builtins;
with trivial;

let
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
  listDir' = list readDir' (t: t == "directory");

  # Return a list of files within
  listFiles = list readDir (t: t == "regular");
  # Return a list of paths to files within
  listFiles' = list readDir' (t: t == "regular");

  # Return a list of items within
  listAll = list readDir (const true);
  # Return a list of paths to items within
  listAll' = list readDir' (const true);
}
