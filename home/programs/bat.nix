{ config, lib, ... }:

with lib;

let cfg = config.nixfiles.programs.bat; in

{
  options.nixfiles.programs.bat.enable = mkEnableOption "managing bat";

  config.programs = mkIf cfg.enable {
    bat.enable = true;
    fish.shellAliases = {
      cat = "bat";
    };
  };
}
