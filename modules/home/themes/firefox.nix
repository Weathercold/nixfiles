{ config, lib, pkgs, ... }:

with lib;
with builtins;

{
  options.nixfiles.themes.firefox.profiles = mkOption {
    type = with types; listOf nonEmptyStr;
    default = [ ];
  };
}
