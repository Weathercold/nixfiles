{ pkgs
, userDescription
, userEmail
, ...
}:
{
  imports = [ ./base.nix ];

  nixpkgs.config.allowUnfree = true;

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
      transcrypt
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
