{ config
, lib
, pkgs
, ...
} @ args:

with lib;
with builtins;

let
  cfg = config.nixfiles.themes.firefox;
in

{
  options.nixfiles.themes.firefox.profiles = mkOption {
    type = with types; listOf nonEmptyStr;
    default = [ ];
  };
}
