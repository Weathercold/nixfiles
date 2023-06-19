{ config, pkgs, lib, ... }:

let
  inherit (pkgs) fetchFromGitHub;
  inherit (lib) mkBefore;
  cfg = config.nixfiles.programs.firefox;

  lock = with builtins; fromJSON (readFile ./lock.json);
  firefox-vertical-tabs = fetchFromGitHub {
    inherit (lock) owner repo rev sha256;
  };
in

{
  imports = [ ../../../programs/firefox.nix ];

  programs.firefox.profiles.${cfg.profile}.userChrome =
    mkBefore ''@import "${firefox-vertical-tabs}/userChrome.css";'';
}
