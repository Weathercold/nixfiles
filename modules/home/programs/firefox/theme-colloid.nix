{ config
, pkgs
, ...
} @ args:

let
  # FIXME: Module optional args are broken
  # https://github.com/vinceliuice/Colloid-gtk-theme
  colloid-gtk-theme = args.colloid-gtk-theme or (pkgs.fetchFromGitHub {
    owner = "vinceliuice";
    repo = "Colloid-gtk-theme";
    rev = "e3dd0f55b6";
    sha256 = "Sv2sekgEKr/tFyVWyFYXkf+uhlK7FqjXbUBut6nEU5c=";
  });
  firefoxProfile = args.firefoxProfile or config.home.username;

  tme = colloid-gtk-theme + "/src/other/firefox/chrome/Colloid";
in

{
  programs.firefox = {
    profiles.${firefoxProfile} = {
      userChrome = ''@import "${tme}/theme.css";'';
      userContent = ''
        @import "${tme}/colors/light.css";
        @import "${tme}/colors/dark.css";

        @import "${tme}/pages/newtab.css";
        @import "${tme}/pages/privatebrowsing.css";

        @import "${tme}/parts/video-player.css";
      '';
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.uidensity" = 2;
        "browser.tabs.inTitlebar" = 1;
      };
    };
  };
}
