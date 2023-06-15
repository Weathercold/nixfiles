{ colloid-gtk-theme, fetchFromGitHub }:

let lock = with builtins; fromJSON (readFile ./lock.json); in

colloid-gtk-theme.overrideAttrs (prev: {
  src = fetchFromGitHub {
    inherit (lock) owner repo rev sha256;
  };
})
