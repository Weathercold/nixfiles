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
  nixpkgs.config.allowUnfree = true;

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10; # Number of NixOS generations in systemd-boot.
      };
      timeout = null;
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
      options = [ "noauto" "noatime" ];
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
    hostName = "nixos-inspiron";
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

  environment = {
    defaultPackages = [ ];
    systemPackages = with pkgs; [
      comma
      discord-canary
      helix
      gh
      jetbrains.idea-community
      jq
      libreoffice-qt
      libsForQt5.qtstyleplugin-kvantum # For Colloid-kde
      neofetch
      nixos-option
      pciutils
      rnix-lsp # Nix LSP Implementation
      thunderbird
      unzip
      (ventoy-bin.override {
        defaultGuiType = "qt5";
        withQt5 = true;
      })
      vscode-with-extensions
      wget
      xorg.xeyes
      zip
      zoxide
    ];
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
    };
  };

  services = {
    btrfs.autoScrub.enable = true;

    rclone = {
      enable = true;
      enableFileSystems = true;
    };

    xserver = {
      enable = true;
      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;

      layout = "us";
      xkbOptions = "caps:swapescape"; # Swap caps with escape.
      libinput = {
        touchpad = {
          clickMethod = "clickfinger";
          naturalScrolling = true;
          disableWhileTyping = true;
        };
      };
    };

    # Audio
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Music
    mpd.enable = true;

    # Firmware updates
    fwupd.enable = true;

    # Needed for storing vscode auth token
    gnome.gnome-keyring.enable = true;
  };

  programs = {
    git = {
      enable = true;
      config = {
        user = {
          name = userDescription;
          email = userEmail;
        };
      };
    };
    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    gnupg.agent.enable = true;

    dconf.enable = true;
  };

  fonts = {
    fonts = with pkgs; [
      inconsolata-nerdfont
      iosevka-bin
      open-sans
      noto-fonts-cjk-sans
    ];
    fontconfig.defaultFonts = {
      monospace = [ "Inconsolata Nerd Font Mono" "Noto Sans Mono" ];
      sansSerif = [ "Open Sans" "Noto Sans" ];
      serif = [ "Noto Serif" ];
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  system.stateVersion = "22.11";
}
