{ config, lib, ... }:

let
  inherit (lib) types mkOption const genAttrs;
  cfg = config.nixfiles.users;
in

{
  options.nixfiles.users.admins = mkOption {
    type = with types; listOf nonEmptyStr;
    description = "List of admin users";
  };

  config.users.users = genAttrs cfg.admins (const {
    extraGroups = [ "wheel" ];
  });
}
