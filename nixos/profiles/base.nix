{ config, pkgs, lib, ... }:

let inherit (lib) genAttrs attrNames const; in

{
  imports = [ ../config/users.nix ];

  nix = {
    package = pkgs.nixVersions.unstable;
    extraOptions = "experimental-features = nix-command flakes";
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
  };

  system.stateVersion = "23.05";

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10; # Number of NixOS generations in systemd-boot.
      };
      efi.canTouchEfiVariables = true;
    };

    kernelPackages = pkgs.linuxPackages_zen;
    consoleLogLevel = 0;
    kernelParams = [ "resume_offset=4929334" "quiet" "udev.log_level=3" ];
    kernel.sysctl = { "vm.swappiness" = 20; };

    initrd.verbose = false;
    resumeDevice = "/dev/disk/by-label/nixos";
    tmp.useTmpfs = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [ "subvol=root" "noatime" "compress-force=zstd" ];
    };
    "/boot" = {
      device = "/dev/disk/by-label/esp";
      fsType = "vfat";
      options = [ "nofail" "noauto" "noatime" "x-systemd.automount" "x-systemd.idle-timeout=10min" ];
    };
    "/home" = {
      device = "/dev/disk/by-label/data";
      fsType = "btrfs";
      options = [ "subvol=home" "noatime" "compress-force=zstd" ];
    };
    "/nix" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [ "subvol=nix" "noatime" "compress-force=zstd" ];
    };
    "/swap" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [ "subvol=swap" "noatime" ];
    };
  };
  swapDevices = [{ device = "/swap/swapfile"; }];

  networking = {
    useDHCP = true;
    firewall.enable = false;
    dhcpcd.enable = false;
    networkmanager = {
      enable = true;
      wifi.macAddress = "random";
    };
  };

  time.timeZone = "America/Toronto";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "C.UTF-8/UTF-8"
      # "en_CA.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
      # "fr_CA.UTF-8/UTF-8"
      # "zh_CN.UTF-8/UTF-8"
    ];
    extraLocaleSettings = {
      LC_TIME = "en_US.UTF-8";
      LC_NUMERIC = "C.UTF-8";
    };
  };

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  security = {
    rtkit.enable = true;
    sudo = {
      wheelNeedsPassword = false;
      execWheelOnly = true;
    };
  };

  users = {
    mutableUsers = false;
    users = genAttrs
      (attrNames config.nixfiles.users.users)
      (const {
        extraGroups = [ "wheel" "audio" "networkmanager" ];
      });
  };
}
