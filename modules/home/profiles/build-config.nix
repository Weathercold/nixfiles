{ config, pkgs, lib, ... }:
{
  imports = [ ./base.nix ];

  programs = builitins.mapAttrs (_: v: lib.optionalAttrs (v ? package) { package = pkgs.emptyFile; }) config.programs;
}
