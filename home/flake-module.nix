{ lib, ... }:

let
  inherit (lib) zipAttrs;
  inherit (lib.nixfiles) genModules collectModules;
  inherit (lib.nixfiles.filesystem) listDirs';
in

{
  imports = collectModules ./flake;

  flake.homeModules =
    zipAttrs (map genModules (listDirs' ./themes))
    // genModules ./profiles;
}
