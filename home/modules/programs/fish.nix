{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.abszero.programs.fish;
in

{
  options.abszero.programs.fish.enable = mkEnableOption "managing fish";

  config.programs.fish = mkIf cfg.enable {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting ""
      any-nix-shell fish --info-right | source
    '';
    functions = {
      qcomm = "qfile (which $argv)";
      fetchhash = "nix flake prefetch --json $argv | jq -r .hash";
    };
  };
}
