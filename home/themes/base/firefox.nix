{ config, lib, firefox-vertical-tabs, ... }:

let cfg = config.nixfiles.programs.firefox; in

{
  imports = [ ../../programs/firefox.nix ];

  programs.firefox.profiles.${cfg.profile}.userChrome =
    lib.mkBefore ''@import "${firefox-vertical-tabs}/userChrome.css";'';
}
