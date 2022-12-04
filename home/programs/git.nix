{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf mkDefault;
  inherit (lib.nixfiles) findValue;
  cfg = config.nixfiles.programs.git;

  primaryEmail = findValue (_: v: v.primary) config.accounts.email.accounts;
in

{
  options.nixfiles.programs.git.enable = mkEnableOption "stupid content tracker";

  config.programs.git = mkIf cfg.enable {
    enable = true;
    userName = mkDefault primaryEmail.realName;
    userEmail = mkDefault primaryEmail.address;
    signing = {
      signByDefault = true;
      key = null;
    };
    extraConfig = {
      pull.rebase = true;
    };
    delta.enable = true;
  };
}
