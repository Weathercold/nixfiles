{ lib, ... }:

let inherit (lib.nixfiles) genModules collectModules; in

{
  imports = collectModules ./flake;

  flake.nixosModules =
    genModules ./hardware
    // genModules ./profiles;
}
