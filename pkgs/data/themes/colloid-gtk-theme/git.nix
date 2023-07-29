{ lib, colloid-gtk-theme, fetchFromGitHub }:
colloid-gtk-theme.overrideAttrs (prev: {
  src = with builtins;
    lib.pipe ./lock.json [
      readFile
      fromJSON
      fetchFromGitHub
    ];
})
