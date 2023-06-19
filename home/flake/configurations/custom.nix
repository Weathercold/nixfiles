{ self, lib, ... }:

let
  inherit (lib) optionalAttrs;

  system = "x86_64-linux"; # System architecture
  username = "custom";
  hostName = "custom";
  homeDirectory = null; # Default is "/home/${username}"
  # For firefox, put your firefox profile name here.
  firefox-profile = null; # Default is username
in

{
  imports = [ ./. ];

  homeConfigurations."${username}@${hostName}" = {
    inherit system;
    modules = [
      self.homeModules.profiles-build-config
      {
        nixfiles = optionalAttrs (firefox-profile != null)
          { programs.firefox.profile = firefox-profile; };

        # You can have multiple specializations, but only one can be default.
        specialisation = {
          colloid = {
            default = true;
            configuration.imports = with self.homeModules; [
              colloid-discocss
              colloid-fcitx5
              colloid-firefox
              colloid-fonts
              colloid-gtk
              colloid-plasma
            ];
          };

          catppuccin.configuration.imports = with self.homeModules; [
            catppuccin-cursor
            catppuccin-fcitx5
            catppuccin-fonts
          ];
        };
      }
    ];
  } // optionalAttrs (homeDirectory != null) { inherit homeDirectory; };
}
