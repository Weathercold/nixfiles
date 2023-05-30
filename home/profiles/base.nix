{ config, ... }:
{
  # FIXME: Still broken, needs --impure to build
  nixpkgs.config.allowUnfree = true;

  home.stateVersion = "23.05";

  programs.home-manager.enable = true;

  xdg = {
    enable = true;
    configFile.nixpkgs.source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/src/nixfiles";
  };
}
