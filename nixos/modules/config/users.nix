{ config, lib, ... }:

let
  inherit (lib) types mkOption mkOverride mapAttrs mergeAttrs;
  cfg = config.nixfiles.users;

  userModule = {
    options = {
      description = mkOption {
        type = with types; nullOr str;
        default = null;
        # If this option is null then ignore it by giving it an even lower
        # priority than mkDefault (1000).
        apply = v: if v == null then mkOverride 1001 v else v;
        description = "User description";
      };
      hashedPassword = mkOption {
        type = with types; nullOr nonEmptyStr;
        default = config.users.users.root.hashedPassword;
        description = "User's hashed password";
      };
      home = mkOption {
        type = with types; nullOr nonEmptyStr;
        default = null;
        apply = v: if v == null then mkOverride 1001 v else v;
        description = "Absolute path to user's home";
      };
    };
  };
in

{
  options.nixfiles.users.users = mkOption {
    type = with types; attrsOf (submodule userModule);
    description = "Configuration of normal users";
  };

  config.users.users =
    mapAttrs (_: mergeAttrs { isNormalUser = true; }) cfg.users;
}
