lib:

with builtins;

let
  inherit (import ../lib/strings.nix { inherit lib; }) isEncrypted;
in

{
  internal = [
    ./programs/bat.nix
    ./programs/dotdrop.nix
    ./programs/exa.nix
    ./programs/firefox.nix
    ./programs/fish.nix
    ./programs/starship.nix

    ./themes
    ./themes/firefox.nix
  ]
  ++ filter (f: !isEncrypted (readFile f)) [
    ./accounts/email.nix
  ];

  regular = {
    themes.colloid = import ./themes/colloid;
  };
}
