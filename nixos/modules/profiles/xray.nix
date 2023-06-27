# Xray server
{
  imports = [ ./base.nix ];

  boot.kernel.sysctl = {
    # Taken from https://github.com/bannedbook/fanqiang/blob/master/v2ss/server-cfg/sysctl-bbr-cake.conf
    # It seems that bbr+cake is currently faster than bbrplus and bbrv2 (how
    # weird). Need to periodically check for new updates.
    "fs.file-max" = 655350;
    "net.core.default_qdisc" = "cake";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };

  services = {
    openssh = {
      enable = true;
      startWhenNeeded = true;
      # Obfuscate the port. However, according to
      # https://geneva.cs.umd.edu/posts/fully-encrypted-traffic/en/, this won't
      # make the server less detectable by the GFW.
      ports = [ 1337 ];
    };

    xray = {
      enable = true;
      settings = {
        inbounds = [{
          port = "7000-7099";
          protocol = "vless";
          settings = {
            clients = [
              { id = "nixos-inspiron"; }
              { id = "windows-inspiron"; }
            ];
            decryption = "none";
          };
        }];

        outbounds = [{
          protocol = "freedom";
        }];
      };
    };
  };
}
