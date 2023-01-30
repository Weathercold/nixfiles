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
    x86_64-linux = "1pwz7la2q4gcvf1yhgmppxfw73xkkjkbnflc54av07mvq82j4ghg";
    x86_64-darwin = "0i7c8ridaqsfhym175lc0m8r923v1188r4fdbjahmlr1h1z6lam1";
    aarch64-linux = "0iqa24qmz6x71r78h1v1wg2zdka4lx0hj49z5ywhlxigfdmvx7n1";
    aarch64-darwin = "13ydvbf20mx9s15rp1s9hcx13cchds6pf8h6qs4873l2j6ccd84w";
    armv7l-linux = "0f8f45gqq7rni6xc8scl952nlg4454fc0vh3kalxq9a25ymhzkw2";
  }.${system} or throwSystem;

  sourceRoot = if stdenv.isDarwin then "" else ".";
in

callPackage "${path}/pkgs/applications/editors/vscode/generic.nix" rec {
  version = "1.75.0.23030-insider";
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
