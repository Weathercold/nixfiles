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
    systemPackages =
      with pkgs;
      with libsForQt5;
      [
        helix
        gh
        jetbrains.idea-community
        jq
        kmail
        libreoffice-qt
        neofetch
        nil # Nix LSP Implementation
        nixos-option
        nixpkgs-fmt
        qtstyleplugin-kvantum # For Colloid-kde
        thunderbird
        transcrypt
        unzip
        (ventoy-bin.override {
          defaultGuiType = "qt5";
          withQt5 = true;
        })
        vscode
        wget
        xorg.xeyes
        zip
      ];
    sessionVariables = {
      NIX_AUTO_RUN = "1";
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

  /* fonts = {
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
  */

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  system.stateVersion = "22.11";
}
