{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf mkDefault;
  inherit (lib.nixfiles) findValue;
  cfg = config.nixfiles.programs.git;
in

{
  options.nixfiles.programs.git.enable = mkEnableOption "stupid content tracker";

  config.programs.git = mkIf cfg.enable {
    enable = true;
    userName = mkDefault config.home.username;
    # Primary email address
    userEmail = mkDefault
      (findValue (_: v: v.primary) config.accounts.email.accounts).address;
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
