{ pkgs
, hostName
, userName
, userDescription
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
      timeout = null;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_zen;
    kernel.sysctl = { "vm.swappiness" = 20; };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [ "subvol=root" "noatime" "compress-force=zstd" "autodefrag" ];
    };
    "/boot" = {
      device = "/dev/disk/by-label/esp";
      fsType = "vfat";
      options = [ "noauto" "noatime" ];
    };
    "/home" = {
      device = "/dev/disk/by-label/data";
      fsType = "btrfs";
      options = [ "subvol=home" "noatime" "compress-force=zstd" "autodefrag" ];
    };
    "/nix" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [ "subvol=nix" "noatime" "compress-force=zstd" "autodefrag" ];
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

  services = {
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

  security = {
    rtkit.enable = true;
    sudo = {
      wheelNeedsPassword = false;
      execWheelOnly = true;
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  users = {
    mutableUsers = false;
    users = rec {
      ${userName} = {
        description = userDescription;
        hashedPassword = userPassword;
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" ];
      };

      root.hashedPassword = userPassword;
    };
  };

  # System packages
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      # Work
      helix
      vscode-with-extensions
      jetbrains.idea-community
      rnix-lsp # Nix LSP Implementation

      # Applications
      firefox-wayland
      thunderbird
      discord-canary
      libsForQt5.qtstyleplugin-kvantum # For Colloid-kde

      # Utils
      pciutils
      zip
      unzip
      wget
      nixos-option
      comma
      xorg.xeyes
      gh
      zoxide
      exa
      neofetch
      (ventoy-bin.override {
        defaultGuiType = "qt5";
        withQt5 = true;
      })
    ];
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
    };
  };

  virtualisation.waydroid.enable = true;

  programs = {
    git = {
      enable = true;
      config = {
        user = {
          name = "Weathercold";
          email = "weathercold.scr@gmail.com";
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
      monospace = [ "Inconsolata Nerd Font" ];
      sansSerif = [ "Open Sans" "Noto Sans" ];
      serif = [ "Noto Serif" ];
    };
  };

  system.stateVersion = "22.11";
}
