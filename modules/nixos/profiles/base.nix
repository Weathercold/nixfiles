{ pkgs
, hostName
, username
, userDescription
, userEmail
, userPassword
, ...
}:
{
  nix = {
    package = pkgs.nixVersions.unstable;
    extraOptions = "experimental-features = nix-command flakes";
  };

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10; # Number of NixOS generations in systemd-boot.
      };
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_zen;
    consoleLogLevel = 3;
    kernelParams = [ "resume_offset=4929334" ];
    kernel.sysctl = { "vm.swappiness" = 20; };

    resumeDevice = "/dev/disk/by-label/nixos";
    tmpOnTmpfs = true;
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
    inherit hostName;
    useDHCP = true;
    firewall.enable = false;
    dhcpcd.enable = false;
    networkmanager = {
      enable = true;
      wifi.macAddress = "random";
    };
  };

  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";

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
    users = {
      ${username} = {
        description = userDescription;
        hashedPassword = userPassword;
        isNormalUser = true;
        extraGroups = [ "wheel" "audio" "networkmanager" ];
      };

      root.hashedPassword = userPassword;
    };
  };
}
