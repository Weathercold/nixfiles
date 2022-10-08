{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.nixfiles.programs.firefox;
in

{
  options.nixfiles.programs.firefox = {
    enableDevEdition = mkEnableOption "managing Firefox Developer Edition";
    profileDev = mkOption {
      type = types.str;
      default = config.home.username + "-dev";
    };
  };

  config = mkIf cfg.enableDevEdition {
    programs.firefox = {
      enable = true;
      # Empty the package option as it does not support multiple packages
      package = pkgs.emptyDirectory;
      profiles.${cfg.profileDev} = {
        id = 1;
        settings = {
          "services.sync.username" = config.lib.attrsets.findName
            (_: v: v.primary == true)
            config.accounts.email.accounts;
          "browser.aboutConfig.showWarning" = false;
        };
      };
    };
    home.packages = [ pkgs.firefox-devedition-bin ];
  };
}
