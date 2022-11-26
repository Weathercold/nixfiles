{ config, pkgs, lib, ... }:

let inherit (lib.nixfiles) collectModules; in

{
  imports = [
    ./base.nix
    ../themes
  ]
  ++ collectModules ../programs
  ++ collectModules ../services;

  home.packages = with pkgs; [
    any-nix-shell
    (discord-canary.override { nss = nss_latest; })
  ];

  nixfiles = {
    programs = {
      firefox.enable = true;
      fish.enable = true;
      starship.enable = true;
      exa.enable = true;
      dotdrop.enable = true;
    };
  };

  programs = {
    zoxide.enable = true;
    bat.enable = true;
    fzf.enable = true;
  };
}
