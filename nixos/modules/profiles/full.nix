{ pkgs, ... }: {
  imports = [
    ./desktop.nix
    ../hardware/halo65.nix
  ];

  abszero = {
    services = {
      kanata.enable = true;
      act.enable = true;
      rclone = {
        enable = true;
        enableFileSystems = true;
      };
    };
    programs = {
      neovim.enable = true;
      steam.enable = true;
    };
    i18n.inputMethod.fcitx5.enable = true;
  };

  environment = {
    defaultPackages = [ ];
    systemPackages =
      with pkgs;
      with libsForQt5;
      [
        # TODO: Switch to anki-qt6 when it is no longer broken on Wayland
        anki-bin-qt6
        clinfo # For Plasma Info Center
        ffmpeg_5-full
        gh
        git-absorb
        git-secret
        glxinfo # For Plasma Info Center
        jetbrains.idea-community
        jq
        kooha
        libreoffice-qt
        neofetch
        obsidian
        pciutils # For Plasma Info Center
        protonmail-bridge
        qtstyleplugin-kvantum # For Colloid-kde
        sddm-kcm # SDDM Plasma integration
        unzip
        (ventoy-bin.override {
          defaultGuiType = "qt5";
          withQt5 = true;
        })
        vscode
        vulkan-tools # For Plasma Info Center
        wayland-utils # For Plasma Info Center
        wget
        win2xcur
        xorg.xeyes
        zip
      ];
    sessionVariables = {
      # Allow unfree packages
      NIXPKGS_ALLOW_UNFREE = "1";
      # Enable running commands without installation
      # Currently not needed because nix-index is enabled in home-manager
      # NIX_AUTO_RUN = "1";
      # Make Electron apps run in Wayland native mode
      NIXOS_OZONE_WL = "1";
      # Make Firefox run in Wayland native mode
      MOZ_ENABLE_WAYLAND = "1";
    };
  };

  services = {
    xserver = {
      enable = true;
      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;
      layout = "us";
      libinput = {
        enable = true;
        touchpad = {
          clickMethod = "clickfinger";
          naturalScrolling = true;
          disableWhileTyping = true;
        };
      };
    };
    mpd.enable = true;
    gnome.gnome-keyring.enable = true; # For storing vscode auth token
  };

  programs = {
    ssh = {
      enableAskPassword = true;
      askPassword = "${pkgs.libsForQt5.ksshaskpass}/bin/ksshaskpass";
    };
    xwayland.enable = true;
    dconf.enable = true;
    kdeconnect.enable = true;
  };

  virtualisation.waydroid.enable = true;
}
