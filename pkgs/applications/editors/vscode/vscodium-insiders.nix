{ stdenv
, lib
, path
, callPackage
, fetchurl
, nixosTests
, commandLineArgs ? ""
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  plat = {
    x86_64-linux = "linux-x64";
    x86_64-darwin = "darwin-x64";
    aarch64-linux = "linux-arm64";
    aarch64-darwin = "darwin-arm64";
    armv7l-linux = "linux-armhf";
  }.${system} or throwSystem;

  archive_fmt = if stdenv.isDarwin then "zip" else "tar.gz";

  sha256 = {
    x86_64-linux = "1qmxnq0b9x7jzjl3aqrxa5dqpm1ji33cywc36vdpl1n285wbndk5";
    x86_64-darwin = "1n1495b27pczhry9jbiy6ibncqywbxq1sb27l95x9qjz0bxjk0pc";
    aarch64-linux = "1fj0hx9bjqn4c2galgy3zj2hkx7qfnjzn3r1i50zw6x2m4wq0qpw";
    aarch64-darwin = "03357nja970k726c6irn9qh2y4j5103vm43b9ys1c66srr7248p6";
    armv7l-linux = "1aqx9igx4cy38v651wli5zy9m7fkv609a8zbpl8mh6na59bcldfa";
  }.${system} or throwSystem;

  sourceRoot = if stdenv.isDarwin then "" else ".";
in

callPackage "${path}/pkgs/applications/editors/vscode/generic.nix" rec {
  version = "1.74.0.22340-insider";
  pname = "vscodium-insiders";
  updateScript = ./update-vscodium-insiders.sh;

  executableName = "codium-insiders";
  longName = "VSCodium - Insiders";
  shortName = "Codium - Insiders";
  inherit commandLineArgs;

  src = fetchurl {
    url = "https://github.com/VSCodium/vscodium-insiders/releases/download"
      + "/${version}/VSCodium-${plat}-${version}.${archive_fmt}";
    inherit sha256;
  };
  inherit sourceRoot;

  # tests = nixosTests.vscodium;

  meta = with lib; {
    description = ''
      Open source source code editor developed by Microsoft for Windows,
      Linux and macOS (VS Code without MS branding/telemetry/licensing)
    '';
    longDescription = ''
      Open source source code editor developed by Microsoft for Windows,
      Linux and macOS. It includes support for debugging, embedded Git
      control, syntax highlighting, intelligent code completion, snippets,
      and code refactoring. It is also customizable, so users can change the
      editor's theme, keyboard shortcuts, and preferences
    '';
    homepage = "https://github.com/VSCodium/vscodium-insiders";
    downloadPage = "https://github.com/VSCodium/vscodium-insiders/releases";
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "codium-insiders";
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
      "armv7l-linux"
    ];
  };
}
