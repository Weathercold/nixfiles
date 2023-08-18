{ inputs, config, lib, withSystem, ... }:

let
  inherit (inputs) home-manager;
  inherit (builtins) head;
  inherit (lib) types mkOption mapAttrs flatten splitString;
  inherit (lib.nixfiles.filesystem) toModuleList;
  cfg = config.homeConfigurations;

  configModule = { name, config, ... }: {
    options = {
      system = mkOption {
        type = types.nonEmptyStr;
        description = "System architecture";
      };
      username = mkOption {
        type = types.nonEmptyStr;
        default = head (splitString "@" name);
        description = "Username";
      };
      homeDirectory = mkOption {
        type = types.nonEmptyStr;
        default = "/home/${config.username}";
        description = "Absolute path to user's home";
      };
      modules = mkOption {
        type = with types; listOf deferredModule;
        default = [ ];
        description = "List of modules specific to this home configuration";
      };
    };
  };
in

{
  options.homeConfigurations = mkOption {
    type = with types; attrsOf (submodule configModule);
    description = "Abstracted home configuration options";
  };

  config.flake.homeConfigurations = mapAttrs
    (_: c: withSystem c.system
      ({ pkgs, ... }: home-manager.lib.homeManagerConfiguration {
        inherit pkgs lib;
        extraSpecialArgs = { inherit inputs; };
        modules = flatten [
          (toModuleList ../modules/accounts)
          (toModuleList ../modules/programs)
          (toModuleList ../modules/services)
          c.modules
          {
            nixpkgs.overlays = [
              (final: prev: import ../../pkgs { pkgs = final; })
            ];
            home = { inherit (c) username homeDirectory; };
          }
        ];
      }))
    cfg;
}
