# Just an adblocker
{ config, lib, ... }:

let
  inherit (lib) mkIf;
  cfg = config.nixfiles.services.xray;

  xraySettings = {
    routing.rules = [{
      type = "field";
      domain = [ "geosite:category-ads-all" ];
      outboundTag = "block";
    }];

    inbounds = [
      {
        protocol = "socks";
        listen = "127.0.0.1";
        port = 10808;
      }
      {
        protocol = "http";
        listen = "127.0.0.1";
        port = 10809;
      }
    ];

    outbounds = [
      {
        tag = "direct";
        protocol = "freedom";
      }
      {
        tag = "block";
        protocol = "blackhole";
      }
    ];
  };
in

{
  imports = [ ./_options.nix ];

  config = mkIf
    (cfg.preset == "blackhole-adblock")
    {
      networking = {
        firewall.allowedTCPPorts = [ 10808 10809 ];
        proxy.default = "http://127.0.0.1:10809";
      };
      environment.sessionVariables.socks_proxy = "socks5://127.0.0.1:10808";
      services.xray.settings = xraySettings;
    };
}
