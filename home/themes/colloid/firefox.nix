{ config, lib, colloid-gtk-theme, ... }:

let
  inherit (lib) mkMerge mkBefore;
  cfg = config.nixfiles.programs.firefox;

  tme = colloid-gtk-theme + "/src/other/firefox/chrome/Colloid";
in

{
  imports = [
    ../../programs/firefox.nix
    ../base/firefox.nix
  ];

  programs.firefox.profiles.${cfg.profile} = {
    userChrome = mkMerge [
      (mkBefore ''@import "${tme}/theme.css";'')
      ''

        /* Fix placement of window decorations */
        * {
          --uc-win-ctrl-vertical-offset: 0;
        }

        /* Fix findbar padding */
        .findbar-container {
          padding: 25px !important;
        }
      ''
    ];
    userContent = mkBefore ''
      @import "${tme}/colors/light.css";
      @import "${tme}/colors/dark.css";

      @import "${tme}/pages/newtab.css";
      @import "${tme}/pages/privatebrowsing.css";

      @import "${tme}/parts/video-player.css";
    '';
    settings = {
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "browser.uidensity" = 2;
      "svg.context-properties.content.enabled" = true;
      "browser.tabs.inTitlebar" = 1;
    };
  };
}
