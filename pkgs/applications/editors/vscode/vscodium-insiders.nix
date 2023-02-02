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
    x86_64-linux = "0bavang64jkr0yd6fv2c342wzknngvqyg9ib9m8d2kq4ba6naaz7";
    x86_64-darwin = "0b71h9f22rqqc9nddagd6q75iyc4y09rgvd3kwyxf2r89jd2456p";
    aarch64-linux = "0v5icdl1p5vl9hs6z9163r08y4j1lvp9cgzqhp16wnml44gzfgqc";
    aarch64-darwin = "1ixvfjwjf21mgm65jhx50472lxkpqahxjby0rpl52a5frks2h4f9";
    armv7l-linux = "0bk4jbdv4b30y0x2i289ykr4slbyn0j5znk2xsxiz7x5j9ljk795";
  }.${system} or throwSystem;

  sourceRoot = if stdenv.isDarwin then "" else ".";
in

callPackage "${path}/pkgs/applications/editors/vscode/generic.nix" rec {
  version = "1.75.0.23033-insider";
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
