# State-of-the-art Xray client configuration using VLESS-TCP-XTLS-REALITY
# https://github.com/chika0801/Xray-examples/blob/main/VLESS-XTLS-uTLS-REALITY/config_client.json
{ config, lib, ... }:

let
  inherit (lib) mkIf;
  cfg = config.nixfiles.services.xray;

  xraySettings = {
    routing = {
      domainStrategy = "IPIfNonMatch";
      rules = [
        {
          type = "field";
          domain = [
            "bilibili.com"
            "location.services.mozilla.com"
          ];
          outboundTag = "direct";
        }
        {
          type = "field";
          domain = [ "geosite:category-ads-all" ];
          outboundTag = "block";
        }
        {
          type = "field";
          domain = [ "geosite:cn" "geosite:private" ];
          outboundTag = "direct";
        }
        {
          type = "field";
          domain = [ "geoip:cn" "geoip:private" ];
          outboundTag = "direct";
        }
      ];
    };

    dns.servers = [
      "https://1.1.1.1/dns-query"
      "https://8.8.8.8/dns-query"
      "localhost"
    ];

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
        tag = "proxy";
        protocol = "vless";
        settings.vnext = [{
          inherit (cfg) address;
          port = 443;
          users = [{
            id = cfg.clientId;
            flow = "xtls-rprx-vision";
            encryption = "none";
          }];
        }];
        streamSettings = {
          network = "tcp";
          security = "reality";
          realitySettings = {
            fingerprint = "chrome";
            serverName = "pjsekai.sega.jp";
            inherit (cfg.reality) publicKey shortId;
            spiderX = ""; # I don't know what this is
          };
        };
      }
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
    (cfg.preset == "vless-tcp-xtls-reality-client")
    {
      networking = {
        firewall.allowedTCPPorts = [ 10808 10809 ];
        proxy.default = "http://127.0.0.1:10809";
      };
      environment.sessionVariables.socks_proxy = "socks5://127.0.0.1:10808";
      services.xray.settings = xraySettings;
    };
}
