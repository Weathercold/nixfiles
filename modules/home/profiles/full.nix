{ config, pkgs, ... }:
{
  imports = [ ./base.nix ];

  home.packages = with pkgs; [
    any-nix-shell
    (discord-canary.override { nss = nss_latest; })
  ];

  nixfiles = {
    email.enable = true;
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
