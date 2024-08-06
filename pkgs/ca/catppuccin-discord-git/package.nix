{
  stdenv,
  lib,
  fetchFromGitHub,
  mkYarnModules,
  nodejs,
  yarn,
  themes0 ? [ ],
}:

let
  inherit (builtins) length;
  inherit (lib) head concatStringsSep;

  matchTheme =
    if themes0 == [ ] then
      "*"
    else if length themes0 == 1 then
      head themes0
    else
      "{${concatStringsSep "," themes0}}";
in

stdenv.mkDerivation rec {
  pname = "catppuccin-discord";
  version = src.rev;

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "discord";
    rev = "53683e3fcdb558995a2255ddb9f9eb46fac9fc81";
    hash = "sha256-NadbP7zMRTtGAlr0IGSnAYUGOZfgeNYnSFYjIdUWas4=";
  };

  nodeModules = mkYarnModules {
    pname = "catppuccin-discord-node-modules";
    version = src.rev;

    packageJSON = src + "/package.json";
    yarnLock = src + "/yarn.lock";
  };

  nativeBuildInputs = [
    nodejs
    yarn
  ];

  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)
    ln -s "$nodeModules/node_modules" node_modules
    yarn --offline release

    runHook postBuild
  '';

  # Stop yarn from trying to build a binary in distPhase
  distPhase = "true";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/catppuccin-discord
    cp dist/dist/catppuccin-${matchTheme}.theme.css $out/share/catppuccin-discord

    runHook postInstall
  '';

  meta = with lib; {
    description = "Soothing pastel theme for Discord";
    homepage = "https://github.com/catppuccin/discord";
    license = licenses.mit;
    maintainers = with maintainers; [ weathercold ];
    platforms = platforms.all;
    sourceProvenance = with sourceTypes; [ fromSource ];
  };
}
