{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf mkDefault;
  inherit (lib.abszero.attrsets) findValue;
  cfg = config.abszero.programs.git;

  primaryEmail = findValue (_: v: v.primary) config.accounts.email.accounts;
in

{
  options.abszero.programs.git.enable = mkEnableOption "stupid content tracker";

  config.programs.git = mkIf cfg.enable {
    enable = true;
    userName = mkDefault primaryEmail.realName;
    userEmail = mkDefault primaryEmail.address;
    signing = {
      signByDefault = true;
      key = null;
    };
    extraConfig = {
      core.editor = "nvim";
      pull.rebase = false;
    };
    delta.enable = true;
  };
}
