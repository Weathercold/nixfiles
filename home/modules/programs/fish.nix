{ config, pkgs, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.abszero.programs.fish;
in

{
  options.abszero.programs.fish.enable = mkEnableOption "managing fish";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ any-nix-shell ];
    programs.fish = {
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
  };
}
