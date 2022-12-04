{ config, pkgs, lib, ... }:

let
  inherit (lib) types mkOption mkEnableOption attrNames genAttrs const;
  cfg = config.nixfiles.programs.thunderbird;
in

{
  options.nixfiles.programs.thunderbird = {
    enable = mkEnableOption "Mozilla's mail client";
    profile = mkOption {
      type = types.nonEmptyStr;
      default = config.home.username;
    };
  };

  config = {
    programs.thunderbird = {
      enable = true;
      profiles.${cfg.profile}.isDefault = true;
    };
    accounts.email.accounts = genAttrs
      (attrNames config.nixfiles.emails)
      (const { thunderbird.enable = true; });
  };
}
