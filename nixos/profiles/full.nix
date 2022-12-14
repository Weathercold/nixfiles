{ config, pkgs, lib, ... }:

let inherit (lib.nixfiles) collectModules; in

{
  imports = [
    ./base.nix
    ../hardware/halo65.nix
  ]
  ++ collectModules ../config
  ++ collectModules ../programs
  ++ collectModules ../services
  ++ collectModules ../system
  ++ collectModules ../virtualisation;

  nixpkgs.config.allowUnfree = true;

  nixfiles = {
    boot.plymouth.enable = true;
    services = {
      kanata.enable = true;
      act.enable = true;
      rclone = {
        enable = true;
        enableFileSystems = true;
      };
    };
  };

  environment = {
    defaultPackages = [ ];
    systemPackages =
      with pkgs;
      with libsForQt5;
      [
        (discord-canary.override {
          nss = nss_latest;
          withOpenASAR = true;
        })
        ffmpeg_5-full
        helix
        gh
        git-secret
        jetbrains.idea-community
        jq
        kdeconnect-kde
        libreoffice-qt
        neofetch
        nil # Nix LSP Implementation
        nixos-option
        nixpkgs-fmt
        qtstyleplugin-kvantum # For Colloid-kde
        unzip
        (ventoy-bin.override {
          defaultGuiType = "qt5";
          withQt5 = true;
        })
        vscode-insiders
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

    xserver = {
      enable = true;
      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;

      layout = "us";
      libinput = {
        touchpad = {
          clickMethod = "clickfinger";
          naturalScrolling = true;
          disableWhileTyping = true;
        };
      };
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    mpd.enable = true;

    gnome.gnome-keyring.enable = true; # For storing vscode auth token
  };

  programs = {
    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    gnupg.agent.enable = true;

    dconf.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };
}
