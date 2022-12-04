{ options, config, lib, ... }:

let
  inherit (lib) types mkOption;
  cfg = config.nixfiles;
in

{
  options.nixfiles.emails = mkOption {
    type = types.attrs;
    default = { };
  };

  config.accounts.email.accounts = cfg.emails;
}
