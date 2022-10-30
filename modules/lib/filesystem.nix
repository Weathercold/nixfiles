{ lib, trivial }:

with lib;
with builtins;
with trivial;

rec {
  listDirs = d: pipe d [
    readDir
    (filterAttrs (_: v: v == "directory"))
    attrNames
  ];
  listDir' = d: map (n: d + "/${n}") (listDirs d);

  listFiles = d: pipe d [
    readDir
    (filterAttrs (_: v: v == "regular"))
    attrNames
  ];
  listFiles' = d: map (n: d + "/${n}") (listFiles d);
}
