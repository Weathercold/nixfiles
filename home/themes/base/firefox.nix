{ config, lib, firefox-vertical-tabs, ... }:

let
  inherit (lib) mkMerge mkBefore;
  cfg = config.nixfiles.programs.firefox;
in

{
  imports = [ ../../programs/firefox.nix ];

  programs.firefox.profiles.${cfg.profile}.userChrome = mkMerge [
    (mkBefore ''@import "${firefox-vertical-tabs}/userChrome.css";'')
    ''

      /* Fix placement of window decorations */
      * {
        --uc-win-ctrl-vertical-offset: 0;
      }
    ''
  ];
}
