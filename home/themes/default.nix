{ config, lib, ... }:

let
  inherit (lib) types mkOption assertOneOf genAttrs;
  inherit (lib.nixfiles) listDirs collectModules;
  cfg = config.nixfiles.themes;

  builtinThemes = listDirs ./.;
  getTheme = n:
    assert assertOneOf "theme" n builtinThemes;
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
