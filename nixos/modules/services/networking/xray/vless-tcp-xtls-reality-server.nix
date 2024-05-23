# State-of-the-art Xray server configuration using VLESS-TCP-XTLS-REALITY
# https://github.com/chika0801/Xray-examples/blob/main/VLESS-XTLS-uTLS-REALITY/config_server.json
{ config, lib, ... }:

let
  inherit (lib) mkIf;
  cfg = config.abszero.services.xray;

  xraySettings = {
    log = {
      loglevel = "info";
      dnsLog = true;
    };

    # Never EVER proxy Chinese websites as GFW is known to recognise and record
    # the proxy server's IP. Traffic to Chinese websites should be direct on the
    # client side but also blocked on the server side just to be sure.
    # https://github.com/XTLS/Xray-core/discussions/593#discussioncomment-845165
    routing = {
      domainStrategy = "IPIfNonMatch";
      rules = [
        # Since sniffing is disabled, requests to IP addresses are not matched
        # using domain rules. We have to rely on the clients to send requests
        # to domains.
        {
          type = "field";
          domain = [ "geosite:bilibili" ];
          outboundTag = "block";
        }
        {
          type = "field";
          ip = [
            "geoip:cn"
            "geoip:private"
          ];
          outboundTag = "block";
        }
      ];
    };

    inbounds = [
      {
        port = 443;
        protocol = "vless";
        settings = {
          clients = map (id: {
            inherit id;
            flow = "xtls-rprx-vision";
          }) cfg.clientIds;
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

    # Reduce fingerprint by changing default timeout
    # https://github.com/XTLS/Xray-core/issues/1511#issuecomment-1376887076
    policy.levels."0" = {
      handshake = 2;
      connIdle = 120;
    };
  };
in

mkIf (cfg.enable && cfg.preset == "vless-tcp-xtls-reality-server") {
  # Fix too many open files
  systemd.services.xray.serviceConfig = {
    LimitNPROC = 500;
    LimitNOFILE = 1000000;
  };
  networking.firewall = {
    allowedTCPPorts = [ 443 ];
    allowedUDPPorts = [ 443 ];
  };
  services.xray.settings = xraySettings;
}
