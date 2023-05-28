{ lib, ... }:

let
  inherit (lib) types mkOption;
in

{
  options.nixfiles.themes.catppuccin = {
    variant = mkOption {
      type = types.enum [ "latte" "frappe" "macchiato" "mocha" ];
      default = "latte";
      description = ''
        The catppuccino theme variant (latte, frappe, macchiato, mocha).
      '';
    };
    accent = mkOption {
      type = types.nonEmptyStr;
      default = "blue";
      description = ''
        The primary accent color.
      '';
    };
  };
}
