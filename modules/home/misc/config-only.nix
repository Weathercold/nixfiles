# Do not install any package
{ config, pkgs, lib, ... }:
{
  programs = builtins.mapAttrs
    (_: v: lib.optionalAttrs (v ? package) { package = pkgs.emptyDirectory; })
    config.programs;
}
