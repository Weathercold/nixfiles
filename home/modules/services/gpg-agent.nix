{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nixfiles.services.gpg-agent;
in

{
  options.nixfiles.services.gpg-agent.enable = mkEnableOption "GnuPG private key agent";

  config.services.gpg-agent = mkIf cfg.enable {
    enable = true;
    enableSshSupport = true;
  };
}
