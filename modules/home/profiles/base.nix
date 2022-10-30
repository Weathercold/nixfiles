# noauto
{ config
, lib
, username
, homeDirectory
, ...
}:
{
  nixpkgs.config.allowUnfreePredicate = lib.const true;

  home = {
    inherit username homeDirectory;
    stateVersion = "22.11";
  };

  programs.home-manager.enable = true;

  xdg = {
    enable = true;
    configFile.nixpkgs.source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/src/nixfiles";
  };

  # FIXME: temporary workaround
  manual.manpages.enable = false;
}
