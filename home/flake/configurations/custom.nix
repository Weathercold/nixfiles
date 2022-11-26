{ self, config, lib, ... }:

let
  inherit (lib) optionalAttrs;

  system = "x86_64-linux"; # System architecture
  username = "custom";
  hostName = "custom";
  homeDirectory = null; # Default is "/home/${username}"
  themes = [ "colloid" ];
  defaultTheme = "colloid";
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
        nixfiles = {
          themes = {
            inherit themes;
          };
        } // optionalAttrs (!isNull firefox-profile)
          { programs.firefox.profile = firefox-profile; };
        specialization.${defaultTheme}.default = true;
      }
    ];
  } // optionalAttrs (!isNull homeDirectory) { inherit homeDirectory; };
}
