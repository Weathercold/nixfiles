{ config
, username
, homeDirectory
, ...
}:
{
  # nixpkgs.config.allowUnfree = true;

  home = {
    inherit username homeDirectory;
    stateVersion = "22.11";
  };

  programs.home-manager.enable = true;

  xdg.configFile.nixpkgs.source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/src/nixfiles";
}
