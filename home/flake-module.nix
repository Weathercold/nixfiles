{ lib, ... }:

let
  inherit (lib) recursiveUpdate;
  inherit (builtins) foldl';
  inherit (lib.nixfiles) genModules collectModules;
  inherit (lib.nixfiles.filesystem) listDirs';
in

{
  imports = collectModules ./flake;

  flake.homeModules =
    foldl' recursiveUpdate { } (map genModules (listDirs' ./themes))
    // genModules ./profiles;
}
