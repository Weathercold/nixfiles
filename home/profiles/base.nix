{ config, lib, ... }:
{
  nixpkgs.config.allowUnfreePredicate = lib.const true;

  home.stateVersion = "23.05";

  programs.home-manager.enable = true;

  xdg = {
    enable = true;
    configFile.nixpkgs.source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/src/nixfiles";
  };
}
