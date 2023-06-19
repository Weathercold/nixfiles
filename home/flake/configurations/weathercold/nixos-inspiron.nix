{ self, inputs, lib, ... }:

let inherit (lib.nixfiles.attrsets) recursiveMerge; in

{
  imports = [ ../. ];

  homeConfigurations."weathercold@nixos-inspiron" = recursiveMerge [
    (import ./. { inherit self lib; })
    {
      system = "x86_64-linux";
      modules = [{
        specialisation.colloid = {
          default = true;
          configuration.imports = with self.homeModules; [
            inputs.bocchi-cursors.homeModules.bocchi-cursors-shadowBlack
            colloid-discocss
            colloid-fcitx5
            colloid-firefox
            colloid-fonts
            colloid-gtk
            colloid-plasma
          ];
        };
      }];
    }
  ];
}
