{ lib, ... }:

let inherit (lib.nixfiles.filesystem) toModuleAttr toModuleAttr' toModuleList; in

{
  imports = toModuleList ./configurations;

  flake.nixosModules =
    toModuleAttr ./modules/themes
    // toModuleAttr' ./modules/hardware
    // toModuleAttr' ./modules/profiles;
}
