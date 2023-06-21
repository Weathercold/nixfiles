{ lib, ... }:

let inherit (lib.nixfiles.filesystem) toModuleAttr' toModuleList; in

{
  imports = toModuleList ./configurations;

  flake.nixosModules =
    toModuleAttr' ./modules/hardware
    // toModuleAttr' ./modules/profiles;
}
