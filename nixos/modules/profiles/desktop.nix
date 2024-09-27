# Desktop essentials
{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkIf;
  inherit (lib.abszero.modules) mkExternalEnableOption;
  cfg = config.abszero.profiles.desktop;
in

{
  imports = [ ./base.nix ];

  options.abszero.profiles.desktop.enable = mkExternalEnableOption config "desktop profile";

  config = mkIf cfg.enable {
    abszero = {
      profiles.base.enable = true;
      boot.lanzaboote.enable = true;
    };

    console.useXkbConfig = true; # use xkbOptions in tty.

    fonts.fontconfig = {
      hinting.style = "medium";
      subpixel.rgba = "rgb";
    };

    networking = {
      nameservers = [
        "1.1.1.1"
        "1.0.0.1"
        "9.9.9.9"
        "149.112.112.112"
      ];
      search = [ "~." ]; # Always use global name servers (shouldn't affect VPNs)
      dhcpcd.enable = false;
      # networkmanager = {
      #   enable = true;
      #   wifi = {
      #     backend = "iwd";
      #     macAddress = "random";
      #   };
      # };
      wireless.iwd = {
        enable = true;
        settings = {
          General = {
            EnableNetworkConfiguration = true;
            AddressRandomization = "network";
            DisableANQP = false; # Use Hotspot 2.0
          };
          Network.NameResolvingService = "systemd"; # Use resolved
          Settings.AlwaysRandomizeAddress = true;
        };
      };
    };

    services = {
      automatic-timezoned.enable = true;
      libinput = {
        enable = true;
        touchpad = {
          clickMethod = "clickfinger";
          naturalScrolling = true;
          disableWhileTyping = true;
        };
      };
      pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
      };
      resolved = {
        enable = true;
        fallbackDns = [ ]; # disable fallback DNS
        dnsovertls = "true";
        dnssec = "true";
        llmnr = "false";
      };
      system76-scheduler.enable = true;
    };

    xdg = {
      portal = {
        enable = true;
        # https://github.com/NixOS/nixpkgs/issues/160923
        xdgOpenUsePortal = true;
        extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
      };
      terminal-exec.enable = true;
    };

    programs.xwayland.enable = true;

    environment.sessionVariables = {
      # Enable running commands without installation
      # Currently not needed because nix-index is enabled in home-manager
      # NIX_AUTO_RUN = "1";
      # Make Electron apps run in Wayland native mode
      NIXOS_OZONE_WL = "1";
    };
  };
}
