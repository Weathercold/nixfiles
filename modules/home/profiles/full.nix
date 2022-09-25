{ config, pkgs, ... }:
{
  imports = [ ./base.nix ];

  # nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    any-nix-shell
    colloid-kde
    colloid-gtk-theme
    colloid-icon-theme
  ];

  programs = {
    fish.enable = true;
    starship.enable = true;
    dotdrop.enable = true;
    firefox.enable = true;
    bat.enable = true;
    exa.enable = true;
    fzf.enable = true;
  };
}
