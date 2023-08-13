# An Xray server deployed to Vultr
{ self, inputs, lib, ... }:

let
  inherit (builtins) fromJSON readFile;
  inherit (lib) mkForce recursiveUpdate;

  proxySettings = fromJSON (readFile ./proxy.json);

  mainModule = {
    nixfiles = {
      boot.loader = {
        # Vultr doesn't support UEFI??? Really???
        systemd-boot.enable = mkForce false;
        grub.enable = true;
      };
      users.admins = [ "weathercold" ];
      services.xray = recursiveUpdate
        proxySettings
        { preset = "vless-tcp-xtls-reality-server"; };
    };

    disko.devices.disk.vda = {
      type = "disk";
      device = "/dev/vda";
      content = {
        type = "gpt";
        partitions = {
          bios = {
            label = "bios";
            size = "1M";
            type = "EF02"; # BIOS boot partition for GRUB
          };
          nixos = {
            label = "nixos";
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ]; # Override existing partition
              subvolumes = {
                root = {
                  mountpoint = "/";
                  mountOptions = [ "noatime" "compress-force=zstd" ];
                };
                swap = {
                  mountpoint = "/swap";
                  mountOptions = [ "noatime" ];
                };
              };
            };
          };
        };
      };
    };
    swapDevices = [{
      device = "/swap/swapfile";
      size = 4096;
      discardPolicy = "pages";
    }];

    users.users = rec {
      weathercold = {
        description = "Weathercold";
        isNormalUser = true;
        hashedPassword =
          "$6$QOTimFq0v8u6oN.I$.m0BQc/tC6/8nluwwQT7AmkbJbfNoh2PnO9biVL4wgWA22zlb/0HheieexWgISAB67r/7floX3bQpZrUjZv9v.";
        openssh.authorizedKeys.keys =
          [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIVP5FpnSD0dIEmsQXqvRCdVN9mw5v//B4E3USU9oIeZ Weathercold" ];
      };
      root = {
        inherit (weathercold) hashedPassword openssh;
      };
    };

    services.btrfs.autoScrub.enable = true;
  };
in

{
  imports = [ ../_options.nix ];

  nixosConfigurations.fracture-ray = {
    system = "x86_64-linux";
    modules = with self.nixosModules; [
      profiles-xray
      hardware-vultr-cc-intel-regular
      mainModule
    ];
  };

  flake.deploy.nodes.fracture-ray = {
    hostname = proxySettings.address;
    sshOpts = [ "-p" "1337" ];
    profiles.system = {
      user = "root";
      path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos
        self.nixosConfigurations.fracture-ray;
    };
  };
}
