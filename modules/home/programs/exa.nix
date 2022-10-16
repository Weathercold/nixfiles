{ config, lib, ... }:

with lib;

let cfg = config.nixfiles.programs.exa; in

{
  options.nixfiles.programs.exa.enable = mkEnableOption "managing exa";

  config.programs.exa = mkIf cfg.enable {
    enable = true;
    enableAliases = true;
  };
}
