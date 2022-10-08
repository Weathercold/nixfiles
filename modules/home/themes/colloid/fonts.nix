{ pkgs, lib, ... }:
{
  imports = [ ./gtk/font.nix ];

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    inconsolata-nerdfont
    iosevka-bin
    noto-fonts-cjk-sans
  ];
}
