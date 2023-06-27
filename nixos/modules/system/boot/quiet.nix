{ config, lib, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixfiles.boot;
in

{
  options.nixfiles.boot.quiet = mkEnableOption "quiet boot";

  config.boot = mkIf cfg.quiet {
    consoleLogLevel = 0;
    kernelParams = [ "quiet" "udev.log_level=3" ];
    initrd.verbose = false;
  };
}
