# noauto
# Do not install any package
{ config, pkgs, lib, ... }:

with lib;

{
  imports = [ ./base.nix ];

  programs = builtins.mapAttrs
    (_: v: optionalAttrs (v ? package) { package = pkgs.emptyDirectory; })
    config.programs;
}
