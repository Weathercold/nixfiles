{ self, config, lib, ... }:

with lib;
with builtins;

let
  inherit (lib.nixfiles) listDirs collectModules;
  cfg = config.nixfiles.themes;

  builtinThemes = listDirs ./.;
  getTheme = n: trivial.throwIfNot
    (elem n builtinThemes)
    "Unknown theme ${n}"
    { imports = collectModules ./${n}; };
in

{
  options.nixfiles.themes.themes = mkOption {
    type = with types; listOf nonEmptyStr;
    default = [ ];
    description = ''
      Predefined themes to build as specializations.
      They can be activated by running scripts found in $out/specialization.
    '';
  };

  config.specialization = genAttrs
    cfg.themes
    (n: { configuration = getTheme n; });
}
