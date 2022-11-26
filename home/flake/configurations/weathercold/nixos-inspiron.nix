{ self, lib, ... }:

let inherit (lib.nixfiles.attrsets) recursiveMerge; in

{
  imports = [ ../. ];

  homeConfigurations."weathercold@nixos-inspiron" = recursiveMerge [
    (import ./. { inherit self lib; })
    {
      system = "x86_64-linux";
      modules = [{
        nixfiles = {
          themes.themes = [ "colloid" ];
        };
        specialization.colloid.default = true;
      }];
    }
  ];
}
