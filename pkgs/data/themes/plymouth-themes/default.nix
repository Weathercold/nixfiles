{ lib
, stdenv
, fetchFromGitHub
, # theme is reserved, took me a while to figure out
  themes0 ? null
}:

let
  inherit (builtins) isList isString all length concatStringsSep head;
  inherit (lib.nixfiles) isNull;

  matchThemes =
    if themes0 == null then "*"
    else if length themes0 == 1 then head themes0
    else "{${concatStringsSep "," themes0}}";
in

assert isNull themes0 || isList themes0 && all isString themes0;

stdenv.mkDerivation {
  pname = "plymouth-themes";
  version = "2021-07-12";

  src = fetchFromGitHub {
    owner = "adi1090x";
    repo = "plymouth-themes";
    rev = "bf2f570bee8e84c5c20caac353cbe1d811a4745f";
    hash = "sha256-VNGvA8ujwjpC2rTVZKrXni2GjfiZk7AgAn4ZB4Baj2k=";
  };

  dontFixup = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plymouth/themes
    cp -r pack_*/${matchThemes} $out/share/plymouth/themes/
    # Fix script path
    sed -i "s|/usr|$out|" $out/share/plymouth/themes/*/*.plymouth
    runHook postInstall
  '';

  meta = with lib; {
    description = "A huge collection (80+) of plymouth themes ported from android bootanimations";
    license = licenses.gpl3;
    platforms = platforms.linux;
    homepage = "https://github.com/adi1090x/plymouth-themes";
  };
}
