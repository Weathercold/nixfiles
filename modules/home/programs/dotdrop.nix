{ config
, lib
, ...
} @ args:

with lib;

let
  # FIXME: Module optional args are broken
  dotdropFishComp = args.dotdropFishComp or builtins.fetchurl {
    url = "https://raw.githubusercontent.com/deadc0de6/dotdrop/master/completion/dotdrop.fish";
    sha256 = "03j3c4l5chw0gdb17911qcxba8lr4zqi81l4idvrjd5a77whpjls";
  };
  cfg = config.programs.dotdrop;
in

{
  options.programs.dotdrop.enable = mkEnableOption "dotfiles manager";

  config = mkIf cfg.enable {
    programs.fish.shellAliases = {
      dotdrop = "~/src/dotfiles/scripts/dotdrop.sh";
      dotsync = "~/src/dotfiles/scripts/dotsync.sh";
      sysdrop = "~/src/sysfiles/scripts/dotdrop.sh";
      syssync = "~/src/sysfiles/scripts/dotsync.sh";
    };
    xdg.configFile."fish/completions/dotdrop.fish".source = dotdropFishComp;
  };
}
