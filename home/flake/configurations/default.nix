# noauto
{ self, inputs, config, lib, withSystem, ... }:

let
  inherit (lib) types mkOption mapAttrs splitString;
  inherit (builtins) head;
  inherit (inputs) home-manager;
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
      emails = mkOption {
        type = with types; attrsOf attrs;
        default = { };
        description =
          "User's email accounts with the same type as accounts.email.accounts";
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
        modules = [{
          nixpkgs.overlays = [ (final: prev: import ../../../pkgs { pkgs = final; }) ];
          home = { inherit (c) username homeDirectory; };
          nixfiles = { inherit (c) emails; };
        }] ++ c.modules;
      }))
    cfg;
}
