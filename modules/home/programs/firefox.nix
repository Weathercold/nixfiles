{ pkgs, firefoxTheme, ... }:
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
    profiles."weathercold" =
      let
        tme = firefoxTheme;
      in
      {
        userChrome = ''@import "${tme}/theme.css";'';
        userContent = ''
          @import "${tme}/colors/light.css";
          @import "${tme}/colors/dark.css";

          @import "${tme}/pages/newtab.css";
          @import "${tme}/pages/privatebrowsing.css";

          @import "${tme}/parts/video-player.css";
        '';
        settings = {
          "services.sync.username" = "weathercold.scr@gmail.com";
          "browser.aboutConfig.showWarning" = false;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };
      };
  };
}
