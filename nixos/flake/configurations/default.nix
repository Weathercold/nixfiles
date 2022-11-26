# noauto
{ inputs, config, lib, withSystem, ... }:

let
  inherit (inputs) nixpkgs;
  inherit (lib) types mkOption mapAttrs;
  cfg = config.nixosConfigurations;

  configModule = { name, ... }: {
    options = {
      system = mkOption {
        type = types.nonEmptyStr;
        description = "System architecture";
      };
      hostName = mkOption {
        type = types.nonEmptyStr;
        default = name;
        description = "Name of the computer. Defaults to the name of the NixOS configuration.";
      };
      rootPassword = mkOption {
        type = types.nonEmptyStr;
        description = "Password of the root user";
      };
      users = mkOption {
        type = with types; attrsOf attrs;
        default = { };
        description = "Configuration of normal users";
      };
      modules = mkOption {
        type = with types; listOf deferredModule;
        default = [ ];
        description = "List of modules specific to this NixOS configuration";
      };
    };
  };
in

{
  options.nixosConfigurations = mkOption {
    type = with types; attrsOf (submodule configModule);
    description = "Abstracted home configuration options";
  };

  config.flake.nixosConfigurations = mapAttrs
    (_: c: withSystem c.system
      ({ system, ... }: nixpkgs.lib.nixosSystem {
        inherit system lib;
        specialArgs = {
          inherit (inputs) nixos-hardware;
        };
        modules = [{
          nixpkgs.overlays = [ config.flake.overlays.default ];
          nixfiles.users.users = c.users;
          networking.hostName = c.hostName;
          users.users.root.hashedPassword = c.rootPassword;
        }] ++ c.modules;
      }))
    cfg;
}
