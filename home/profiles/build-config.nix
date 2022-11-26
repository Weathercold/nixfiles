# Profile that disables every package
{ config, pkgs, lib, ... }:

let
  inherit (lib) mkForce;
  inherit (lib.nixfiles) collectModules;
in

{
  imports = [
    ./base.nix
    ../themes
  ]
  ++ collectModules ../programs
  ++ collectModules ../services;

  # programs = builtins.mapAttrs
  #   (_: v: optionalAttrs (v ? package) { package = pkgs.emptyDirectory; })
  #   config.programs;

  home.packages = mkForce [ ];
}
