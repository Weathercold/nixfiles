{ inputs, config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nixfiles.programs.dotdrop;
in

{
  options.nixfiles.programs.dotdrop.enable = mkEnableOption "dotfiles manager";

  config = mkIf cfg.enable {
    programs.fish.shellAliases = {
      dotdrop = "~/src/dotfiles/scripts/dotdrop.sh";
      dotsync = "~/src/dotfiles/scripts/dotsync.sh";
      sysdrop = "~/src/sysfiles/scripts/dotdrop.sh";
      syssync = "~/src/sysfiles/scripts/dotsync.sh";
    };
    xdg.configFile."fish/completions/dotdrop.fish".source = inputs.dotdropFishComp;
  };
}
