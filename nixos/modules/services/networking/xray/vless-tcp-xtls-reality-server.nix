# State-of-the-art Xray server configuration using VLESS-TCP-XTLS-REALITY
# https://github.com/chika0801/Xray-examples/blob/main/VLESS-XTLS-uTLS-REALITY/config_server.json
{ config, lib, ... }:

let
  inherit (lib) mkIf;
  cfg = config.nixfiles.services.xray;

  xraySettings = {
    # Never EVER proxy Chinese websites as GFW is known to recognise and record
    # the proxy server's IP. Traffic to Chinese websites should be direct on the
    # client side but also blocked on the server side just to be sure.
    # https://github.com/XTLS/Xray-core/discussions/593#discussioncomment-845165
    routing = {
      domainStrategy = "IPIfNonMatch";
      rules = [
        {
          type = "field";
          domain = [ "bilibili.com" ];
          outboundTag = "block";
        }
        {
          type = "field";
          ip = [ "geoip:cn" "geoip:private" ];
          outboundTag = "block";
        }
      ];
    };

    inbounds = [{
      listen = cfg.address;
      port = 443;
      protocol = "vless";
      settings = {
        clients = map
          (id: {
            inherit id;
            flow = "xtls-rprx-vision";
          })
          cfg.clientIds;
        decryption = "none";
      };
      streamSettings = {
        network = "tcp";
        security = "reality";
        realitySettings = {
          # Requirements: foreign website, TLSv1.3, X25519 & H2 support, not
          # used for forwarding
          # https://bluearchive.jp doesn't support TLSv1.3 :(
          dest = "pjsekai.sega.jp:443";
          # Server name on the certificate of dest
          serverNames = [ "pjsekai.sega.jp" ];
          inherit (cfg.reality) privateKey shortIds;
        };
      };
    }];

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

    # Reduce fingerprint by changing default timeout
    # https://github.com/XTLS/Xray-core/issues/1511#issuecomment-1376887076
    policy.levels."0" = {
      handshake = 2;
      connIdle = 120;
    };
  };
in

{
  imports = [ ./_options.nix ];

  config = mkIf
    (cfg.preset == "vless-tcp-xtls-reality-server")
    {
      networking.firewall.allowedTCPPorts = [ 443 ];
      services.xray.settings = xraySettings;
    };
}
